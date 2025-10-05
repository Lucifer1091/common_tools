// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as p;

// import '../index.dart';

// class FileService {
//   FileService._();

//   static Future<XFile?> pickImage({
//     ImageSource imageSource = ImageSource.gallery,
//     double? maxWidth,
//     double? maxHeight,
//     int? quality,
//   }) async {
//     try {
//       if (!MyPlatform.isDesktop) {
//         // For Android / IOS / Web

//         final XFile? image = await ImagePicker().pickImage(
//           source: imageSource,
//           maxWidth: maxWidth,
//           maxHeight: maxHeight,
//           imageQuality: quality,
//         );
//         // Check for Invalid File formats
//         if (image != null) {
//           final String ext = p.extension(image.path).toLowerCase();
//           if (image.mimeType == 'image/jpeg' ||
//               image.mimeType == 'image/jpg' ||
//               image.mimeType == 'image/png' ||
//               ext == '.jpg' ||
//               ext == '.jpeg' ||
//               ext == '.png') {
//             return image;
//           } else {
//             SnackBars.error(title: 'Invalid File Format.');
//           }
//         }
//       } else {
//         // For Windows / MacOs / Linux

//         final FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: ['jpg', 'jpeg', 'png'],
//         );

//         if (result != null) {
//           return XFile(result.files.single.path!);
//         }
//       }
//     } on PlatformException catch (_) {
//       SnackBars.error(title: 'Failed to pick Image.');
//     }
//     return null;
//   }

//   static Future<XFile?> pickFile({
//     double? maxWidth,
//     double? maxHeight,
//     int? quality,
//     List<String>? allowedExtensions,
//   }) async {
//     try {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions:
//             allowedExtensions ??
//             [
//               'jpg',
//               'jpeg',
//               'png',
//               'doc',
//               'docx',
//               'pdf',
//               'xls',
//               'xlsx',
//               'csv',
//               'txt',
//             ],
//       );

//       if (result == null) return null;

//       final String? fileExt = result.files.single.extension?.toLowerCase();

//       if (fileExt == 'jpg' ||
//           fileExt == 'jpeg' ||
//           fileExt == 'png' ||
//           fileExt == 'doc' ||
//           fileExt == 'docx' ||
//           fileExt == 'xls' ||
//           fileExt == 'xlsx' ||
//           fileExt == 'csv' ||
//           fileExt == 'pdf' ||
//           fileExt == 'txt') {
//         if (MyPlatform.isWeb) {
//           return XFile.fromData(
//             result.files.single.bytes!,
//             mimeType: fileExt,
//             name: result.files.single.name,
//           );
//         } else {
//           return XFile(
//             result.files.single.path!,
//             mimeType: fileExt,
//             name: result.files.single.name,
//           );
//         }
//       } else {
//         SnackBars.error(title: 'Invalid File Format.');
//       }
//     } on PlatformException catch (_) {
//       SnackBars.error(title: 'Failed to pick File.');
//     }
//     return null;
//   }

//   static Future<List<XFile?>?> pickMultipleImages({
//     double? maxWidth,
//     double? maxHeight,
//     int? quality,
//   }) async {
//     try {
//       if (!MyPlatform.isDesktop) {
//         // For Android / IOS / Web

//         final List<XFile?> images = await ImagePicker().pickMultiImage(
//           maxWidth: maxWidth,
//           maxHeight: maxHeight,
//           imageQuality: quality,
//         );
//         return images;
//       } else {
//         // For Windows / MacOs / Linux

//         final FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.image,
//           allowMultiple: true,
//         );

//         if (result != null) {
//           return result.paths.map((path) => XFile(path!)).toList();
//         }
//       }
//     } on PlatformException catch (_) {
//       SnackBars.error(title: 'Failed to pick Image.');
//     }
//     return null;
//   }

//   static Future<List<XFile>?> pickFiles({
//     double? maxWidth,
//     double? maxHeight,
//     int? quality,
//     List<String>? allowedExtensions,
//   }) async {
//     try {
//       final List<String> fileExtensions = [
//         'jpg',
//         'jpeg',
//         'png',
//         'doc',
//         'docx',
//         'pdf',
//         'xls',
//         'xlsx',
//         'csv',
//         'txt',
//         'ppt',
//         'pptx',
//         'mp3',
//         'mp4',
//       ];

//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: true,
//         allowedExtensions: allowedExtensions ?? fileExtensions,
//       );

//       if (result == null) return null;

//       for (final PlatformFile file in result.files) {
//         final String? fileExt = file.extension?.toLowerCase();

//         if (!fileExtensions.contains(fileExt)) {
//           SnackBars.error(title: 'Invalid File Format.');
//           return null;
//         }
//       }

//       final List<XFile> files = [];

//       if (MyPlatform.isWeb) {
//         for (final PlatformFile file in result.files) {
//           files.add(
//             XFile.fromData(
//               file.bytes!,
//               mimeType: file.extension?.toLowerCase(),
//               name: file.name,
//             ),
//           );
//         }
//       } else {
//         for (final PlatformFile file in result.files) {
//           files.add(
//             XFile(
//               file.path!,
//               mimeType: file.extension?.toLowerCase(),
//               name: file.name,
//             ),
//           );
//         }
//       }

//       return files;
//     } on PlatformException catch (_) {
//       SnackBars.error(title: 'Failed to pick Files.');
//     }
//     return null;
//   }

//   static Future<XFile?> showFilePickerPopup(
//     BuildContext context, {
//     bool isFilePicker = false,
//     List<String>? allowedExtensions,
//   }) async {
//     XFile? source;
//     // For Windows / MacOs / Linux Upload image/file by galley only.
//     if (MyPlatform.isDesktop) {
//       if (isFilePicker) {
//         source = await pickFile(allowedExtensions: allowedExtensions);
//       } else {
//         source = await pickImage();
//       }
//     } else {
//       if (isFilePicker) {
//         source = await pickFile(allowedExtensions: allowedExtensions);
//       } else {
//         source =
//             context.isCompact
//                 ? await _showImagePickerSheet(
//                   context,
//                   isFilePicker: isFilePicker,
//                 )
//                 : await _showImagePickerDialog(
//                   context,
//                   isFilePicker: isFilePicker,
//                 );
//       }
//     }
//     return source;
//   }

//   static Future<XFile?> _showImagePickerDialog(
//     BuildContext context, {
//     bool isFilePicker = false,
//   }) => OLDDialogs.show<XFile?>(
//     context,
//     content: SizedBox(
//       width: 400,
//       height: 120,
//       child: Center(
//         child: _buildImagePickerContent(context, isFilePicker: isFilePicker),
//       ),
//     ),
//   );

//   static Future<XFile?> _showImagePickerSheet(
//     BuildContext context, {
//     bool isFilePicker = false,
//   }) async => BottomSheets.show<XFile?>(
//     context,
//     color: context.colorScheme.background,
//     showDivider: false,
//     maxHeight: 160,
//     maxWidth: 500,
//     bottomSheet: _buildImagePickerContent(context, isFilePicker: isFilePicker),
//   );

//   static Widget _buildImagePickerContent(
//     BuildContext context, {
//     bool isFilePicker = false,
//   }) {
//     XFile? image;

//     return Material(
//       type: MaterialType.transparency,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             onTap: () async {
//               image = await pickImage(imageSource: ImageSource.camera).then((
//                 value,
//               ) {
//                 Navigator.of(context).pop<XFile>(image);
//                 return value;
//               });
//             },
//             leading: Icon(
//               Icons.camera_alt_outlined,
//               color: context.colorScheme.primary,
//             ),
//             title: Text('Capture from camera', style: context.bodyLarge),
//           ),
//           if (!isFilePicker) ...[
//             ListTile(
//               onTap: () async {
//                 image = await pickImage().then((value) {
//                   Navigator.of(context).pop<XFile>(image);
//                   return value;
//                 });
//               },
//               leading: Icon(
//                 Icons.photo_size_select_actual_outlined,
//                 color: context.colorScheme.primary,
//               ),
//               title: Text('Upload from gallery', style: context.bodyLarge),
//             ),
//           ] else ...[
//             ListTile(
//               onTap: () async {
//                 image = await pickFile().then((value) {
//                   Navigator.of(context).pop<XFile>(image);
//                   return value;
//                 });
//               },
//               leading: Icon(
//                 Icons.upload_file_outlined,
//                 color: context.colorScheme.primary,
//               ),
//               title: Text('Upload from storage', style: context.bodyLarge),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
