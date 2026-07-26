import 'dart:io';

/// Returns `true` when [path] exists on the local file system.
bool filePathExists(String path) {
  final FileSystemEntityType type = FileSystemEntity.typeSync(path);
  return type == FileSystemEntityType.file ||
      type == FileSystemEntityType.directory ||
      type == FileSystemEntityType.link;
}

/// Builds a file URI for [path].
Uri fileUri(String path) {
  return Uri.file(path);
}
