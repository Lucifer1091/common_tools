import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../index.dart';

enum MyUploadMediaType { image, video }

enum MyUploadValidatorError { overSize, overQuantity }

enum MyUploadFileStatus { success, loading, error, retry }

enum MyUploadType { add, remove, replace }

enum MyUploadBoxType { roundedSquare, circle }

class MyUploadFile {
  MyUploadFile({
    required this.key,
    this.remotePath,
    this.assetPath,
    this.file,
    this.progress,
    this.status = MyUploadFileStatus.success,
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
  MyUploadFileStatus status;
}

typedef MyUploadErrorEvent = void Function(Object e);
typedef MyUploadClickEvent = void Function(int value);
typedef MyUploadValueChangedEvent =
    void Function(List<MyUploadFile> files, MyUploadType type);
typedef MyUploadValidatorEvent = void Function(MyUploadValidatorError e);

class MyUpload extends StatefulWidget {
  const MyUpload({
    required this.files,
    super.key,
    this.max = 0,
    this.mediaType = const [MyUploadMediaType.image, MyUploadMediaType.video],
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
    this.type = MyUploadBoxType.roundedSquare,
    this.disabled = false,
    this.enabledReplaceType = false,
    this.wrapSpacing,
    this.wrapRunSpacing,
    this.wrapAlignment,
  });

  final List<MyUploadFile> files;

  /// Used to control the number of files uploaded, 0 means no limit, only
  /// valid when multiple is true
  final int max;
  final List<MyUploadMediaType> mediaType;
  final double? sizeLimit;
  final bool multiple;
  final VoidCallback? onCancel;
  final MyUploadErrorEvent? onError;
  final MyUploadValidatorEvent? onValidate;
  final MyUploadClickEvent? onClick;
  final VoidCallback? onMaxLimitReached;
  final MyUploadValueChangedEvent? onChange;
  final double? width;
  final double? height;
  final MyUploadBoxType type;
  final bool? enabledReplaceType;
  final bool? disabled;
  final double? wrapSpacing;
  final double? wrapRunSpacing;
  final WrapAlignment? wrapAlignment;

  @override
  State<MyUpload> createState() => _MyUploadState();
}

class _MyUploadState extends State<MyUpload> {
  List<MyUploadFile> fileList = [];

  bool get canUpload =>
      widget.multiple
          ? (widget.max == 0 || fileList.length < widget.max)
          : fileList.isEmpty;

  final ImagePicker _picker = ImagePicker();

  final Map<MyUploadBoxType, MyImageType> _imageTypeMap = {
    MyUploadBoxType.roundedSquare: MyImageType.roundedSquare,
    MyUploadBoxType.circle: MyImageType.circle,
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
        widget.onValidate!(MyUploadValidatorError.overQuantity);
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
        if (widget.mediaType.contains(MyUploadMediaType.image)) {
          media = await _picker.pickImage(source: ImageSource.gallery);
        } else {
          media = await _picker.pickVideo(source: ImageSource.gallery);
        }
        if (media != null) {
          medias = [media];
        }
      }

      if (widget.max > 0 &&
          isMultiple &&
          fileList.length + medias.length > widget.max) {
        if (widget.onMaxLimitReached != null) {
          widget.onMaxLimitReached!();
        } else if (widget.onValidate != null) {
          widget.onValidate?.call(MyUploadValidatorError.overQuantity);
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

    final newFiles = <MyUploadFile>[];
    for (var i = 0; i < files.length; i++) {
      newFiles.add(
        MyUploadFile(
          key: originMaxKeys + i + 1,
          file: File(files[i].path),
          assetPath: files[i].path,
        ),
      );
    }

    widget.onChange?.call(newFiles, MyUploadType.add);
  }

  Future<void> replaceMedia(List<XFile> files, MyUploadFile oldFile) async {
    if (files.isEmpty || files.length != 1) return;

    final result = await validateResources(files, false);

    if (result != null) {
      widget.onValidate?.call(result);
      return;
    }

    final newFile = MyUploadFile(
      key: oldFile.key,
      file: File(files[0].path),
      assetPath: files[0].path,
    );

    widget.onChange?.call([newFile], MyUploadType.replace);
  }

  Future<MyUploadValidatorError?> validateResources(
    List<XFile> files, [
    bool? multiple,
  ]) async {
    MyUploadValidatorError? error;

    var isMultiple = multiple ?? widget.multiple;

    if (multiple != null) {
      isMultiple = multiple;
    }

    if (isMultiple && widget.max > 0) {
      final remain = widget.max - fileList.length;

      if (files.length > remain) {
        return MyUploadValidatorError.overQuantity;
      }
    }

    for (final file in files) {
      if (widget.sizeLimit != null) {
        final fileSize = await file.length();
        final sizeLimitInBytes = widget.sizeLimit! * 1024;
        if (fileSize > sizeLimitInBytes) {
          error = MyUploadValidatorError.overSize;
          break;
        }
      }
    }

    return error;
  }

  void onDelete(MyUploadFile file) {
    widget.onChange?.call([file], MyUploadType.remove);
  }

  @override
  Widget build(BuildContext context) {
    final children = fileList.map((f) => _buildImageBox(context, f)).toList();
    if (canUpload) {
      children.add(
        _buildUploadBox(
          context,
          shouldDisplay: canUpload,
          onTap: () async {
            if (widget.disabled!) return;

            final files = await getMediaFromPicker(widget.multiple);
            unawaited(extractImageList(files));
          },
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: widget.wrapSpacing ?? 8,
        runSpacing: widget.wrapRunSpacing ?? 16,
        alignment: widget.wrapAlignment ?? WrapAlignment.start,
        children: children,
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
              widget.type == MyUploadBoxType.circle
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

  Widget _buildImageBox(BuildContext context, MyUploadFile file) {
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
          MyImage(
            key: Key(file.assetPath ?? ''),
            width: widget.width,
            height: widget.height,
            image: file.remotePath ?? file.assetPath ?? file.file,
            type: _imageTypeMap[widget.type] ?? MyImageType.roundedSquare,
          ),
          Visibility(
            visible: file.status != MyUploadFileStatus.success,
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
                      widget.type == MyUploadBoxType.circle
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

  Widget _buildShadowBox(MyUploadFile file) {
    var displayText = '';
    switch (file.status) {
      case MyUploadFileStatus.loading:
        displayText =
            file.progress != null ? '${file.progress!}%' : file.loadingText;
      case MyUploadFileStatus.retry:
        displayText = file.retryText;
      case MyUploadFileStatus.error:
        displayText = file.errorText;
      case MyUploadFileStatus.success:
        break;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration:
          widget.type == MyUploadBoxType.circle
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
                visible: file.status == MyUploadFileStatus.loading,
                child: const MyLoader(
                  size: MyLoaderSize.large,
                  // iconColor: Colors.white,
                ),
              ),
              Visibility(
                visible:
                    file.status == MyUploadFileStatus.retry ||
                    file.status == MyUploadFileStatus.error,
                child: Icon(
                  file.status == MyUploadFileStatus.retry
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
