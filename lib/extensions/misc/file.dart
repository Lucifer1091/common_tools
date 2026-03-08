import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../index.dart';

/// Extra metadata and file-type helpers for [XFile].
///
/// Type checks are based on detected MIME type first, then file extension.
extension FileExtensionX on XFile {
  /// File name with extension (basename of [path]).
  String get fileName => p.basename(path);

  /// File extension including the leading dot (for example `.png`).
  String get extension => p.extension(path);

  /// MIME type inferred from file path, then fallback to [XFile.mimeType].
  String? get detectedMimeType => lookupMimeType(path) ?? mimeType;

  /// Returns `true` when this file is an image.
  bool get isImage => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.image,
  );

  /// Returns `true` when this file is a PDF.
  bool get isPdf =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.pdf);

  /// Returns `true` when this file is an audio file.
  bool get isAudio => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.audio,
  );

  /// Returns `true` when this file is a video file.
  bool get isVideo => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.video,
  );

  /// Returns `true` when this file is a Word document.
  bool get isDoc =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.doc);

  /// Returns `true` when this file is a PowerPoint document.
  bool get isPPT =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.ppt);

  /// Returns `true` when this file is a spreadsheet.
  bool get isExcel => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.excel,
  );

  /// Returns `true` when this file is a text document.
  bool get isTxt =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.txt);

  /// Returns `true` when this file is XML.
  bool get isXml =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.xml);

  /// Returns `true` when this file is SVG.
  bool get isSvg =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.svg);

  /// Returns `true` when this file is CSV.
  bool get isCsv =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.csv);

  /// Returns `true` when this file is an archive (zip/rar/...).
  bool get isArchive => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.archive,
  );

  /// Returns `true` when this file is JSON.
  bool get isJson =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.json);

  /// Returns `true` when this file matches any supported known type.
  ///
  /// Includes: image, svg, video, audio, pdf, doc, ppt, excel, txt, xml, csv,
  /// archive, and json.
  bool get isFile =>
      isImage ||
      isSvg ||
      isVideo ||
      isAudio ||
      isPdf ||
      isDoc ||
      isPPT ||
      isExcel ||
      isTxt ||
      isXml ||
      isCsv ||
      isArchive ||
      isJson;

  /// Returns a formatted human-readable file size (for example `12.4 MB`).
  ///
  /// [decimals] controls fraction digits in the output.
  ///
  /// Example:
  /// ```dart
  /// final label = await file.getSizeWithSuffix(decimals: 1); // e.g. "2.5 MB"
  /// ```
  Future<String> getSizeWithSuffix({int decimals = 0}) async {
    final bytes = await length();
    if (bytes <= 0) return '0 Bytes';

    const suffixes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    final unitIndex = (math.log(bytes) / math.log(1024)).floor().clamp(
      0,
      suffixes.length - 1,
    );

    return '${(bytes / math.pow(1024, unitIndex)).toStringAsFixed(decimals)} ${suffixes[unitIndex]}';
  }

  /// Returns file size converted to the given [unit].
  ///
  /// Example:
  /// ```dart
  /// final sizeInMb = await file.getSize(unit: SizeUnit.MB);
  /// ```
  Future<double> getSize({SizeUnit unit = SizeUnit.MB}) async {
    final bytes = await length();
    if (bytes <= 0) return 0;

    return bytes / math.pow(1024, unit.id);
  }
}
