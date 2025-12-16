import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../index.dart';

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

  static Future<XFile?> pickImage({
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
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick Image.');
    }
    return null;
  }

  static Future<XFile?> _pickUsingImagePicker({
    required ImageSource imageSource,
    double? maxWidth,
    double? maxHeight,
    int? quality,
    int? maxSizeInBytes,
  }) async {
    final XFile? image = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );

    if (image == null) return null;

    if (!_isValidImageFormat(image)) {
      SnackBars.error(title: 'Invalid File Format.');
      return null;
    }

    if (!await _validateFileSize(image, maxSizeInBytes)) return null;

    return image;
  }

  static Future<XFile?> _pickUsingFilePicker({int? maxSizeInBytes}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _imageExtensions,
    );

    if (result == null) return null;

    final file = XFile(result.files.single.path!);

    if (!_isValidImageFormat(file)) {
      SnackBars.error(title: 'Invalid File Format.');
      return null;
    }

    if (!await _validateFileSize(file, maxSizeInBytes)) return null;

    return file;
  }

  static bool _isValidImageFormat(XFile image) {
    final ext = p.extension(image.path).toLowerCase();
    return _imageMimeTypes.contains(image.mimeType) ||
        _imageExtensions.contains(ext.replaceFirst('.', ''));
  }

  static bool _isValidVideoFormat(XFile video) {
    final ext = p.extension(video.path).toLowerCase();
    return _videoMimeTypes.contains(video.mimeType) ||
        _videoExtensions.contains(ext.replaceFirst('.', ''));
  }

  static Future<bool> _validateFileSize(XFile file, int? maxSizeInBytes) async {
    if (maxSizeInBytes == null) return true;

    final fileSize = await file.length();
    if (fileSize > maxSizeInBytes) {
      _showMediaSizeExceedError(maxSizeInBytes);
      return false;
    }
    return true;
  }

  static Future<XFile?> pickFile({
    List<String>? allowedExtensions,
    int? maxSizeInBytes,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions:
            allowedExtensions ?? [..._imageExtensions, ..._documentExtensions],
      );

      if (result == null) return null;

      final file = result.files.single;
      final fileExt = file.extension?.toLowerCase();

      if (!_isValidFileExtension(fileExt, extensions: allowedExtensions)) {
        SnackBars.error(title: 'Invalid File Format.');
        return null;
      }

      if (maxSizeInBytes != null && file.size > maxSizeInBytes) {
        _showMediaSizeExceedError(maxSizeInBytes);
        return null;
      }

      return MyPlatform.isWeb
          ? XFile.fromData(file.bytes!, mimeType: fileExt, name: file.name)
          : XFile(file.path!, mimeType: fileExt, name: file.name);
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick file.');
    }
    return null;
  }

  static bool _isValidFileExtension(String? ext, {List<String>? extensions}) {
    final extensions0 = extensions ?? _allExtensions;
    return ext != null && extensions0.contains(ext);
  }

  static Future<List<XFile>?> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    int? maxLimit,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        return await ImagePicker().pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
          limit: maxLimit,
        );
      } else {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );
        final files = result?.paths.map((path) => XFile(path!)).toList();
        return files?.sublist(0, maxLimit ?? files.length);
      }
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick Image.');
    }
    return null;
  }

  static Future<XFile?> pickVideo({
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
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick Video.');
    }
    return null;
  }

  static Future<XFile?> _pickVideoUsingImagePicker({
    int? maxSizeInBytes,
    Duration? maxDuration,
    ImageSource source = ImageSource.gallery,
  }) async {
    final XFile? video = await ImagePicker().pickVideo(
      source: source,
      maxDuration: maxDuration,
    );

    if (video == null) return null;

    if (!_isValidVideoFormat(video)) {
      SnackBars.error(title: 'Invalid Video Format.');
      return null;
    }

    if (!await _validateFileSize(video, maxSizeInBytes)) return null;

    return video;
  }

  static Future<XFile?> _pickVideoUsingFilePicker({int? maxSizeInBytes}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _videoExtensions,
    );

    if (result == null) return null;

    final file = XFile(result.files.single.path!);

    if (!_isValidVideoFormat(file)) {
      SnackBars.error(title: 'Invalid Video Format.');
      return null;
    }

    if (!await _validateFileSize(file, maxSizeInBytes)) return null;

    return file;
  }

  static Future<List<XFile>?> pickMultipleVideos({
    Duration? maxDuration,
    int? maxSizeInBytes,
    int? maxLimit,
  }) async {
    try {
      if (!MyPlatform.isDesktop) {
        return await ImagePicker().pickMultiVideo(
          limit: maxLimit,
          maxDuration: maxDuration,
        );
      } else {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: _videoExtensions,
        );

        if (result == null) return null;

        final videos = result.paths.map((path) => XFile(path!)).toList();

        for (final video in videos) {
          if (!_isValidVideoFormat(video)) {
            SnackBars.error(title: 'Invalid Video Format.');
            return null;
          }
        }

        return _buildXFilesList(
          result.files,
          maxSizeInBytes,
        ).sublist(0, maxLimit ?? videos.length);
      }
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick Videos.');
    }
    return null;
  }

  static Future<List<XFile>?> pickFiles({
    List<String>? allowedExtensions,
    int? maxSizeInBytes,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: allowedExtensions ?? _allExtensions,
      );

      if (result == null) return null;

      // Validate all file extensions
      for (final file in result.files) {
        final fileExt = file.extension?.toLowerCase();
        if (!_isValidFileExtension(fileExt)) {
          SnackBars.error(title: 'Invalid File Format.');
          return null;
        }
      }

      return _buildXFilesList(result.files, maxSizeInBytes);
    } on PlatformException catch (_) {
      SnackBars.error(title: 'Failed to pick Files.');
    }
    return null;
  }

  static List<XFile> _buildXFilesList(
    List<PlatformFile> files,
    int? maxSizeInBytes,
  ) {
    return files.map((file) {
      if (maxSizeInBytes != null && file.size > maxSizeInBytes) {
        _showMediaSizeExceedError(maxSizeInBytes);
      }

      return MyPlatform.isWeb
          ? XFile.fromData(
            file.bytes!,
            mimeType: file.extension?.toLowerCase(),
            name: file.name,
          )
          : XFile(
            file.path!,
            mimeType: file.extension?.toLowerCase(),
            name: file.name,
          );
    }).toList();
  }

  static Future<XFile?> showFilePickerPopup(
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

  static Future<XFile?> _showImagePickerDialog(
    BuildContext context, {
    bool isFilePicker = false,
  }) => MyDialog.show<XFile?>(
    context: context,
    builder: (context) {
      return MyAlertDialog.vertical(
        title: 'Upload Image',
        content: 'How do you want to upload an image ?',
        buttons: [
          MyDialogButtonOptions(
            title: 'Capture From Camera',
            titleColor: context.colorScheme.primaryForeground,
            action: () async {
              final image = await pickImage(imageSource: ImageSource.camera);
              if (context.mounted) Navigator.of(context).pop<XFile>(image);
            },
          ),
          MyDialogButtonOptions(
            title: 'Upload From Gallery',
            action: () async {
              final image = await pickImage();
              if (context.mounted) Navigator.of(context).pop<XFile>(image);
            },
            type: MyButtonType.outline,
          ),
          MyDialogButtonOptions(
            title: 'Cancel',
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

  static void _showMediaSizeExceedError(int sizeInBytes) {
    SnackBars.error(
      title: 'Image size exceeds ${sizeInBytes ~/ (1024 * 1024)} MB limit.',
    );
  }
}
