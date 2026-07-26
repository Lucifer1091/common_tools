import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';

/// Package-owned cross-platform file selected by a picker or download.
@immutable
class MyPickedFile {
  MyPickedFile.fromPath(
    String path, {
    String? mimeType,
    String? name,
    int? length,
    DateTime? lastModified,
  }) : _file = XFile(
         path,
         mimeType: mimeType,
         name: name,
         length: length,
         lastModified: lastModified,
       );

  MyPickedFile.fromData(
    Uint8List bytes, {
    String? mimeType,
    String? name,
    int? length,
    DateTime? lastModified,
    String? path,
  }) : _file = XFile.fromData(
         bytes,
         mimeType: mimeType,
         name: name,
         length: length,
         lastModified: lastModified,
         path: path,
       );

  const MyPickedFile._(this._file);

  final XFile _file;

  String get path => _file.path;
  String get name => _file.name;
  String? get mimeType => _file.mimeType;

  Future<int> length() => _file.length();
  Future<DateTime> lastModified() => _file.lastModified();
  Future<Uint8List> readAsBytes() => _file.readAsBytes();
  Future<String> readAsString({Encoding encoding = utf8}) {
    return _file.readAsString(encoding: encoding);
  }

  Stream<Uint8List> openRead([int? start, int? end]) {
    return _file.openRead(start, end);
  }

  Future<void> saveTo(String path) => _file.saveTo(path);
}

MyPickedFile myPickedFileFromPlatformFile(XFile file) {
  return MyPickedFile._(file);
}

XFile platformFileFromMyPickedFile(MyPickedFile file) => file._file;
