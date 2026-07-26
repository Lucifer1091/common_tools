import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../extensions/context/theme.dart';
import '../localization/my_translations.dart';
import '../models/my_picked_file.dart';
import '../utilities/my_platform.dart';
import '../widgets/components/button/my_button.dart';
import '../widgets/components/dialog/my_alert_dialog.dart';
import '../widgets/components/dialog/my_dialog.dart';
import '../widgets/components/dialog/my_dialog_config.dart';

class FileService {
  FileService._();

  // File extension constants
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const _documentExtensions = [
    'doc',
    'docx',
    'pdf',
    'xls',
    'xlsx',
    'csv',
    'txt',
    'ppt',
    'pptx',
    'json',
  ];

  static const _videoExtensions = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'webm',
    'flv',
    'wmv',
    '3gp',
    'ts',
    'mts',
  ];

  static const _audioExtensions = ['mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg'];

  static const List<String> _allExtensions = [
    ..._imageExtensions,
    ..._documentExtensions,
    ..._videoExtensions,
    ..._audioExtensions,
  ];

  // MIME type constants
  static const _imageMimeTypes = {
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
  };

  static const _videoMimeTypes = {
    'video/mp4',
    'video/quicktime',
    'video/x-msvideo',
    'video/x-matroska',
    'video/webm',
    'video/x-flv',
    'video/x-ms-wmv',
    'video/3gpp',
    'video/mp2t',
  };

  static Future<MyPickedFile?> pickImage({
    ImageSource imageSource = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? quality,
    int? maxSizeInBytes,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        return await _pickUsingImagePicker(
          imageSource: imageSource,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          quality: quality,
          maxSizeInBytes: maxSizeInBytes,
        );
      } else {
        return await _pickUsingFilePicker(maxSizeInBytes: maxSizeInBytes);
      }
    } on PlatformException catch (_) {}
    return null;
  }

  static Future<MyPickedFile?> _pickUsingImagePicker({
    required ImageSource imageSource,
    double? maxWidth,
    double? maxHeight,
    int? quality,
    int? maxSizeInBytes,
  }) async {
    final platformFile = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );
    if (platformFile == null) return null;
    final image = myPickedFileFromPlatformFile(platformFile);

    if (!_isValidImageFormat(image)) {
      return null;
    }

    if (!await _validateFileSize(image, maxSizeInBytes)) return null;

    return image;
  }

  static Future<MyPickedFile?> _pickUsingFilePicker({
    int? maxSizeInBytes,
  }) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _imageExtensions,
    );

    if (result == null) return null;

    final file = MyPickedFile.fromPath(result.files.single.path!);

    if (!_isValidImageFormat(file)) {
      return null;
    }

    if (!await _validateFileSize(file, maxSizeInBytes)) return null;

    return file;
  }

  static bool _isValidImageFormat(MyPickedFile image) {
    final ext = p.extension(image.path).toLowerCase();
    return _imageMimeTypes.contains(image.mimeType) ||
        _imageExtensions.contains(ext.replaceFirst('.', ''));
  }

  static bool _isValidVideoFormat(MyPickedFile video) {
    final ext = p.extension(video.path).toLowerCase();
    return _videoMimeTypes.contains(video.mimeType) ||
        _videoExtensions.contains(ext.replaceFirst('.', ''));
  }

  static Future<bool> _validateFileSize(
    MyPickedFile file,
    int? maxSizeInBytes,
  ) async {
    if (maxSizeInBytes == null) return true;

    final fileSize = await file.length();
    if (fileSize > maxSizeInBytes) {
      return false;
    }
    return true;
  }

  static Future<MyPickedFile?> pickFile({
    List<String>? allowedExtensions,
    int? maxSizeInBytes,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions:
            allowedExtensions ?? [..._imageExtensions, ..._documentExtensions],
      );

      if (result == null) return null;

      final file = result.files.single;
      final fileExt = file.extension?.toLowerCase();

      if (!_isValidFileExtension(fileExt, extensions: allowedExtensions)) {
        return null;
      }

      if (maxSizeInBytes != null && file.size > maxSizeInBytes) {
        return null;
      }

      return MyPlatform.isWeb
          ? MyPickedFile.fromData(
              file.bytes!,
              mimeType: fileExt,
              name: file.name,
            )
          : MyPickedFile.fromPath(
              file.path!,
              mimeType: fileExt,
              name: file.name,
            );
    } on PlatformException catch (_) {}
    return null;
  }

  static bool _isValidFileExtension(String? ext, {List<String>? extensions}) {
    final extensions0 = extensions ?? _allExtensions;
    return ext != null && extensions0.contains(ext);
  }

  static Future<List<MyPickedFile>?> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    int? maxLimit,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        final files = await ImagePicker().pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
          limit: maxLimit,
        );
        return files.map(myPickedFileFromPlatformFile).toList();
      } else {
        final FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );
        final files = result?.paths
            .map((path) => MyPickedFile.fromPath(path!))
            .toList();
        return files?.sublist(0, maxLimit ?? files.length);
      }
    } on PlatformException catch (_) {}
    return null;
  }

  static Future<MyPickedFile?> pickVideo({
    int? maxSizeInBytes,
    Duration? maxDuration,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        return await _pickVideoUsingImagePicker(
          maxSizeInBytes: maxSizeInBytes,
          maxDuration: maxDuration,
          source: source,
        );
      } else {
        return await _pickVideoUsingFilePicker(maxSizeInBytes: maxSizeInBytes);
      }
    } on PlatformException catch (_) {}
    return null;
  }

  static Future<MyPickedFile?> _pickVideoUsingImagePicker({
    int? maxSizeInBytes,
    Duration? maxDuration,
    ImageSource source = ImageSource.gallery,
  }) async {
    final platformFile = await ImagePicker().pickVideo(
      source: source,
      maxDuration: maxDuration,
    );
    if (platformFile == null) return null;
    final video = myPickedFileFromPlatformFile(platformFile);

    if (!_isValidVideoFormat(video)) {
      return null;
    }

    if (!await _validateFileSize(video, maxSizeInBytes)) return null;

    return video;
  }

  static Future<MyPickedFile?> _pickVideoUsingFilePicker({
    int? maxSizeInBytes,
  }) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _videoExtensions,
    );

    if (result == null) return null;

    final file = MyPickedFile.fromPath(result.files.single.path!);

    if (!_isValidVideoFormat(file)) {
      return null;
    }

    if (!await _validateFileSize(file, maxSizeInBytes)) return null;

    return file;
  }

  static Future<List<MyPickedFile>?> pickMultipleVideos({
    Duration? maxDuration,
    int? maxSizeInBytes,
    int? maxLimit,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        final files = await ImagePicker().pickMultiVideo(
          limit: maxLimit,
          maxDuration: maxDuration,
        );
        return files.map(myPickedFileFromPlatformFile).toList();
      } else {
        final FilePickerResult? result = await FilePicker.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: _videoExtensions,
        );

        if (result == null) return null;

        final videos = result.paths
            .map((path) => MyPickedFile.fromPath(path!))
            .toList();

        for (final video in videos) {
          if (!_isValidVideoFormat(video)) {
            return null;
          }
        }

        return _buildXFilesList(
          result.files,
          maxSizeInBytes,
        ).sublist(0, maxLimit ?? videos.length);
      }
    } on PlatformException catch (_) {}
    return null;
  }

  static Future<List<MyPickedFile>?> pickFiles({
    List<String>? allowedExtensions,
    int? maxSizeInBytes,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: allowedExtensions ?? _allExtensions,
      );

      if (result == null) return null;

      // Validate all file extensions
      for (final file in result.files) {
        final fileExt = file.extension?.toLowerCase();
        if (!_isValidFileExtension(fileExt)) {
          return null;
        }
      }

      return _buildXFilesList(result.files, maxSizeInBytes);
    } on PlatformException catch (_) {}
    return null;
  }

  static List<MyPickedFile> _buildXFilesList(
    List<PlatformFile> files,
    int? maxSizeInBytes,
  ) {
    return files
        .where((file) => maxSizeInBytes == null || file.size <= maxSizeInBytes)
        .map(
          (file) => MyPlatform.isWeb
              ? MyPickedFile.fromData(
                  file.bytes!,
                  mimeType: file.extension?.toLowerCase(),
                  name: file.name,
                )
              : MyPickedFile.fromPath(
                  file.path!,
                  mimeType: file.extension?.toLowerCase(),
                  name: file.name,
                ),
        )
        .toList();
  }

  static Future<MyPickedFile?> showFilePickerPopup(
    BuildContext context, {
    bool isFilePicker = false,
    List<String>? allowedExtensions,
  }) async {
    if (MyPlatform.isDesktop) {
      return isFilePicker
          ? await pickFile(allowedExtensions: allowedExtensions)
          : await pickImage();
    }

    return _showImagePickerDialog(context, isFilePicker: isFilePicker);

    // return context.isCompact
    //     ? await _showImagePickerSheet(context, isFilePicker: isFilePicker)
    //     : await _showImagePickerDialog(context, isFilePicker: isFilePicker);
  }

  static Future<MyPickedFile?> _showImagePickerDialog(
    BuildContext context, {
    bool isFilePicker = false,
  }) => MyDialog.show<MyPickedFile?>(
    context: context,
    builder: (context) {
      final translations = MyTranslations.of(context);
      return MyAlertDialog.vertical(
        title: translations.uploadImage,
        content: translations.uploadImagePrompt,
        buttons: [
          MyDialogButtonOptions(
            title: translations.captureFromCamera,
            titleColor: context.colorScheme.primaryForeground,
            action: () async {
              final image = await pickImage(imageSource: ImageSource.camera);
              if (context.mounted) {
                Navigator.of(context).pop<MyPickedFile>(image);
              }
            },
          ),
          MyDialogButtonOptions(
            title: translations.uploadFromGallery,
            action: () async {
              final image = await pickImage();
              if (context.mounted) {
                Navigator.of(context).pop<MyPickedFile>(image);
              }
            },
            type: MyButtonType.outline,
          ),
          MyDialogButtonOptions(
            title: translations.cancel,
            action: () async {
              if (context.mounted) Navigator.of(context).pop();
            },
            type: MyButtonType.destructive,
            titleColor: context.colorScheme.destructiveForeground,
          ),
        ],
      );
    },
  );
}
