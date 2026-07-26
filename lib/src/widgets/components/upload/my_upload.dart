import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../models/my_picked_file.dart';
import '../../../services/file_service.dart';
import '../../common/my_gesture_detector.dart';
import '../image/my_image.dart';
import '../loading/indicators/my_loader_options.dart';
import '../loading/my_loader.dart';
import '../text/my_text.dart';

enum MyUploadMediaType { image, video }

enum MyUploadValidatorError { overSize, overQuantity }

enum MyUploadFileStatus { success, loading, error, retry }

enum MyUploadType { add, remove, replace }

enum MyUploadBoxType { roundedSquare, circle }

@immutable
class MyUploadFile {
  const MyUploadFile({
    required this.id,
    this.source,
    this.progress,
    this.status = MyUploadFileStatus.success,
    this.loadingText = 'Loading...',
    this.retryText = 'Re-Upload',
    this.errorText = 'Error',
    this.canDelete = true,
  });

  final int id;
  final Object? source;
  final bool canDelete;
  final int? progress;
  final String loadingText;
  final String retryText;
  final String errorText;
  final MyUploadFileStatus status;

  Key get key {
    return switch (source) {
      final File file => Key(file.path),
      final MyPickedFile file => Key(file.path),
      final Object value => Key(value.toString()),
      null => const Key(''),
    };
  }

  MyUploadFile copyWith({
    int? id,
    Object? source,
    int? progress,
    MyUploadFileStatus? status,
    String? loadingText,
    String? retryText,
    String? errorText,
    bool? canDelete,
  }) {
    return MyUploadFile(
      id: id ?? this.id,
      source: source ?? this.source,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      loadingText: loadingText ?? this.loadingText,
      retryText: retryText ?? this.retryText,
      errorText: errorText ?? this.errorText,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyUploadFile &&
            other.id == id &&
            other.source == source &&
            other.progress == progress &&
            other.status == status &&
            other.loadingText == loadingText &&
            other.retryText == retryText &&
            other.errorText == errorText &&
            other.canDelete == canDelete;
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    progress,
    status,
    loadingText,
    retryText,
    errorText,
    canDelete,
  );
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
    this.addIcon,
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
  final IconData? addIcon;

  @override
  State<MyUpload> createState() => _MyUploadState();
}

class _MyUploadState extends State<MyUpload> {
  List<MyUploadFile> fileList = [];

  bool get canUpload => widget.multiple
      ? (widget.max == 0 || fileList.length < widget.max)
      : fileList.isEmpty;

  final Map<MyUploadBoxType, MyImageType> _imageTypeMap = {
    MyUploadBoxType.roundedSquare: MyImageType.squircle,
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

  Future<List<MyPickedFile>> getMediaFromPicker(bool isMultiple) async {
    if (widget.mediaType.isEmpty) return [];

    var medias = <MyPickedFile>[];

    try {
      if (isMultiple) {
        medias = await FileService.pickMultipleImages() ?? [];
      } else {
        MyPickedFile? media;

        if (widget.mediaType.contains(MyUploadMediaType.image)) {
          media = await FileService.pickImage();
        } else {
          media = await FileService.pickVideo();
        }

        if (media != null) medias = [media];
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

  Future<void> extractImageList(List<MyPickedFile> files) async {
    if (!canUpload || files.isEmpty) return;

    final result = await validateResources(files);

    if (result != null) {
      widget.onValidate?.call(result);
      return;
    }

    final originMaxKeys = fileList.isEmpty
        ? 0
        : fileList.map((file) => file.id).reduce(max);

    final newFiles = <MyUploadFile>[];
    for (var i = 0; i < files.length; i++) {
      newFiles.add(MyUploadFile(id: originMaxKeys + i + 1, source: files[i]));
    }

    widget.onChange?.call(newFiles, MyUploadType.add);
  }

  Future<void> replaceMedia(
    List<MyPickedFile> files,
    MyUploadFile oldFile,
  ) async {
    if (files.isEmpty || files.length != 1) return;

    final result = await validateResources(files, false);

    if (result != null) {
      widget.onValidate?.call(result);
      return;
    }

    final newFile = MyUploadFile(id: oldFile.id, source: files[0]);

    widget.onChange?.call([newFile], MyUploadType.replace);
  }

  Future<MyUploadValidatorError?> validateResources(
    List<MyPickedFile> files, [
    bool? multiple,
  ]) async {
    MyUploadValidatorError? error;

    var isMultiple = multiple ?? widget.multiple;

    if (multiple != null) isMultiple = multiple;

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
      child: MyGestureDetector(
        onTap: onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.type == MyUploadBoxType.circle
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.secondary,
                )
              : BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: MyBorderRadius.medium,
                ),
          child: Center(
            child: Icon(
              widget.addIcon ?? LucideIcons.imagePlus,
              color: context.colorScheme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(BuildContext context, MyUploadFile file) {
    return MyGestureDetector(
      onTap: () async {
        widget.onClick?.call(file.id);

        if (widget.enabledReplaceType ?? false) {
          final files = await getMediaFromPicker(false);
          unawaited(replaceMedia(files, file));
        }
      },
      child: Stack(
        children: [
          MyImage(
            key: file.key,
            width: widget.width,
            height: widget.height,
            source: file.source,
            type: _imageTypeMap[widget.type] ?? MyImageType.squircle,
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
              child: MyGestureDetector(
                onTap: () => onDelete(file),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: widget.type == MyUploadBoxType.circle
                      ? const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                        )
                      : const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          borderRadius: BorderRadius.only(
                            bottomLeft: MyRadi.medium,
                            topRight: MyRadi.medium,
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
        displayText = file.progress != null
            ? '${file.progress!}%'
            : file.loadingText;
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
      decoration: widget.type == MyUploadBoxType.circle
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            )
          : BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              borderRadius: MyBorderRadius.medium,
            ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: file.status == MyUploadFileStatus.loading,
              child: MyLoader(
                size: MyLoaderSize.extraSmall,
                options: MyLoaderOptions(strokeWidth: 2.5),
              ),
            ),
            Visibility(
              visible:
                  file.status == MyUploadFileStatus.retry ||
                  file.status == MyUploadFileStatus.error,
              child: Icon(
                file.status == MyUploadFileStatus.retry
                    ? LucideIcons.refreshCw
                    : LucideIcons.circleSlash,
                size: 18,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: MyText(
                displayText,
                textColor: Colors.white,
                style: const TextStyle(fontSize: 12, height: 1.67),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
