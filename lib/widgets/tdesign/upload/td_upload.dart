import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../index.dart';
import '../image/td_image.dart';
import '../loading/td_loading.dart';
import '../text/my_text.dart';

enum TDUploadMediaType { image, video }

enum TDUploadValidatorError { overSize, overQuantity }

enum TDUploadFileStatus { success, loading, error, retry }

enum TDUploadType { add, remove, replace }

enum TDUploadBoxType { roundedSquare, circle }

class TDUploadFile {
  TDUploadFile({
    required this.key,
    this.remotePath,
    this.assetPath,
    this.file,
    this.progress,
    this.status = TDUploadFileStatus.success,
    this.loadingText = 'Loading...',
    this.retryText = 'Re-Upload',
    this.errorText = 'Error',
    this.canDelete = true,
  });

  final int key;
  final String? remotePath;
  final String? assetPath;
  final File? file;
  final bool canDelete;
  final int? progress;
  final String loadingText;
  final String retryText;
  final String errorText;
  TDUploadFileStatus status;
}

typedef TDUploadErrorEvent = void Function(Object e);
typedef TDUploadClickEvent = void Function(int value);
typedef TDUploadValueChangedEvent =
    void Function(List<TDUploadFile> files, TDUploadType type);
typedef TDUploadValidatorEvent = void Function(TDUploadValidatorError e);

class TDUpload extends StatefulWidget {
  const TDUpload({
    required this.files,
    super.key,
    this.max = 0,
    this.mediaType = const [TDUploadMediaType.image, TDUploadMediaType.video],
    this.sizeLimit,
    this.onCancel,
    this.onError,
    this.onValidate,
    this.onClick,
    this.onMaxLimitReached,
    this.onChange,
    this.multiple = false,
    this.width = 80.0,
    this.height = 80.0,
    this.type = TDUploadBoxType.roundedSquare,
    this.enabledReplaceType = false,
  });

  final List<TDUploadFile> files;

  /// Used to control the number of files uploaded, 0 means no limit, only
  /// valid when multiple is true
  final int max;

  final List<TDUploadMediaType> mediaType;

  final double? sizeLimit;

  final bool multiple;

  final VoidCallback? onCancel;

  final TDUploadErrorEvent? onError;

  final TDUploadValidatorEvent? onValidate;

  final TDUploadClickEvent? onClick;

  final VoidCallback? onMaxLimitReached;

  final TDUploadValueChangedEvent? onChange;

  final double? width;

  final double? height;

  final TDUploadBoxType type;

  final bool? enabledReplaceType;

  @override
  State<TDUpload> createState() => _TDUploadState();
}

class _TDUploadState extends State<TDUpload> {
  List<TDUploadFile> fileList = [];

  bool get canUpload =>
      widget.multiple
          ? (widget.max == 0 || fileList.length < widget.max)
          : fileList.isEmpty;
  final ImagePicker _picker = ImagePicker();

  final Map<TDUploadBoxType, TDImageType> _imageTypeMap = {
    TDUploadBoxType.roundedSquare: TDImageType.roundedSquare,
    TDUploadBoxType.circle: TDImageType.circle,
  };

  @override
  void initState() {
    super.initState();
    fileList = widget.files;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateInitialFiles();
    });
  }

  void _validateInitialFiles() {
    if (widget.max > 0 && fileList.length > widget.max) {
      if (widget.onMaxLimitReached != null) {
        widget.onMaxLimitReached!();
      } else if (widget.onValidate != null) {
        widget.onValidate!(TDUploadValidatorError.overQuantity);
      } else {
        throw Exception('Initial file count exceeds the maximum limit');
      }
    }
  }

  Future<List<XFile>> getMediaFromPicker(bool isMultiple) async {
    if (widget.mediaType.isEmpty) {
      return [];
    }

    var medias = <XFile>[];
    try {
      if (isMultiple) {
        medias = await _picker.pickMultiImage();
      } else {
        XFile? media;
        if (widget.mediaType.contains(TDUploadMediaType.image)) {
          media = await _picker.pickImage(source: ImageSource.gallery);
        } else {
          media = await _picker.pickVideo(source: ImageSource.gallery);
        }
        if (media != null) {
          medias = [media];
        }
      }

      if (widget.max > 0 && fileList.length + medias.length > widget.max) {
        if (widget.onMaxLimitReached != null) {
          widget.onMaxLimitReached!();
        } else if (widget.onValidate != null) {
          widget.onValidate?.call(TDUploadValidatorError.overQuantity);
        }
        return [];
      }
    } on PlatformException catch (e) {
      widget.onError?.call(e);
    } catch (e) {
      widget.onError?.call(e);
    }

    return medias;
  }

  Future<void> extractImageList(List<XFile> files) async {
    if (!canUpload || files.isEmpty) {
      return;
    }

    final result = await validateResources(files);

    if (result != null) {
      widget.onValidate?.call(result);
      return;
    }

    final originMaxKeys =
        fileList.isEmpty ? 0 : fileList.map((file) => file.key).reduce(max);

    final newFiles = <TDUploadFile>[];
    for (var i = 0; i < files.length; i++) {
      newFiles.add(
        TDUploadFile(
          key: originMaxKeys + i + 1,
          file: File(files[i].path),
          assetPath: files[i].path,
        ),
      );
    }

    widget.onChange?.call(newFiles, TDUploadType.add);
  }

  Future<void> replaceMedia(List<XFile> files, TDUploadFile oldFile) async {
    if (files.isEmpty || files.length != 1) return;

    final result = await validateResources(files);

    if (result != null) {
      widget.onValidate?.call(result);
      return;
    }

    final newFile = TDUploadFile(
      key: oldFile.key,
      file: File(files[0].path),
      assetPath: files[0].path,
    );

    widget.onChange?.call([newFile], TDUploadType.replace);
  }

  Future<TDUploadValidatorError?> validateResources(
    List<XFile> files, [
    bool? multiple,
  ]) async {
    TDUploadValidatorError? error;

    var isMultiple = widget.multiple;
    if (multiple != null) {
      isMultiple = multiple;
    }

    if (isMultiple && widget.max > 0) {
      final remain = widget.max - fileList.length;

      if (files.length > remain) {
        return TDUploadValidatorError.overQuantity;
      }
    }

    for (final file in files) {
      if (widget.sizeLimit != null) {
        final fileSize = await file.length();
        final sizeLimitInBytes = widget.sizeLimit! * 1024;
        if (fileSize > sizeLimitInBytes) {
          error = TDUploadValidatorError.overSize;
          break;
        }
      }
    }

    return error;
  }

  void onDelete(TDUploadFile file) {
    widget.onChange?.call([file], TDUploadType.remove);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 16,
        children: [
          ...fileList.map((file) => _buildImageBox(context, file)),
          _buildUploadBox(
            context,
            shouldDisplay: canUpload,
            onTap: () async {
              if (!canUpload) return;

              final files = await getMediaFromPicker(widget.multiple);
              unawaited(extractImageList(files));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(
    BuildContext context, {
    void Function()? onTap,
    bool shouldDisplay = true,
  }) {
    return Visibility(
      visible: shouldDisplay,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration:
              widget.type == TDUploadBoxType.circle
                  ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeColors.neutral.shade50,
                  )
                  : BoxDecoration(
                    color: ThemeColors.neutral.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Color.fromRGBO(0, 0, 0, 0.4),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(BuildContext context, TDUploadFile file) {
    return GestureDetector(
      onTap: () async {
        widget.onClick?.call(file.key);

        if (widget.enabledReplaceType ?? false) {
          final files = await getMediaFromPicker(false);
          unawaited(replaceMedia(files, file));
        }
      },
      child: Stack(
        children: [
          TDImage(
            key: Key(file.assetPath ?? ''),
            width: widget.width,
            height: widget.height,
            imgUrl: file.remotePath,
            // assetUrl: file.assetPath,
            imageFile: file.file,
            type: _imageTypeMap[widget.type] ?? TDImageType.roundedSquare,
          ),
          Visibility(
            visible: file.status != TDUploadFileStatus.success,
            child: _buildShadowBox(file),
          ),
          Visibility(
            visible: file.canDelete,
            child: Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  onDelete(file);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration:
                      widget.type == TDUploadBoxType.circle
                          ? const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          )
                          : const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                  child: const Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowBox(TDUploadFile file) {
    var displayText = '';
    switch (file.status) {
      case TDUploadFileStatus.loading:
        displayText =
            file.progress != null ? '${file.progress!}%' : file.loadingText;
      case TDUploadFileStatus.retry:
        displayText = file.retryText;
      case TDUploadFileStatus.error:
        displayText = file.errorText;
      case TDUploadFileStatus.success:
        break;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration:
          widget.type == TDUploadBoxType.circle
              ? const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(0, 0, 0, 0.4),
              )
              : BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: file.status == TDUploadFileStatus.loading,
                child: const TDLoading(
                  size: TDLoadingSize.large,
                  iconColor: Colors.white,
                ),
              ),
              Visibility(
                visible:
                    file.status == TDUploadFileStatus.retry ||
                    file.status == TDUploadFileStatus.error,
                child: Icon(
                  file.status == TDUploadFileStatus.retry
                      ? Icons.refresh_rounded
                      : Icons.cancel_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText(
                  displayText,
                  textColor: Colors.white,
                  style: const TextStyle(fontSize: 12, height: 1.67),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
