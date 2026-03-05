import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../index.dart';

extension FileExtensionX on XFile {
  /// Get file name.
  String get fileName => p.basename(path);

  /// Get file extension.
  String get extension => p.extension(path);

  /// Get mime type inferred from file path, then fallback to [XFile.mimeType].
  String? get detectedMimeType => lookupMimeType(path) ?? mimeType;

  /// Check whether file is image.
  bool get isImage => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.image,
  );

  /// Check whether file is pdf.
  bool get isPdf =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.pdf);

  /// Check whether file is audio.
  bool get isAudio => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.audio,
  );

  /// Check whether file is video.
  bool get isVideo => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.video,
  );

  /// Check whether file is ms doc.
  bool get isDoc =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.doc);

  /// Check whether file is presentation document.
  bool get isPPT =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.ppt);

  /// Check whether file is excel sheet.
  bool get isExcel => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.excel,
  );

  /// Check whether file is text.
  bool get isTxt =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.txt);

  /// Check whether file is xml.
  bool get isXml =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.xml);

  /// Check whether file is svg.
  bool get isSvg =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.svg);

  /// Check whether file is csv.
  bool get isCsv =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.csv);

  /// Check whether file is archive.
  bool get isArchive => RegexMatcher.matchFile(
    detectedMimeType ?? extension,
    RegexFileType.archive,
  );

  /// Check whether file is json.
  bool get isJson =>
      RegexMatcher.matchFile(detectedMimeType ?? extension, RegexFileType.json);

  /// Checks whether given file is docx, pdf, xls, ppt or txt.
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

  /// Returns a formatted string with the appropriate size suffix (e.g., KB, MB).
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

  /// Converts the file size to the specified [SizeUnit].
  Future<double> getSize({SizeUnit unit = SizeUnit.MB}) async {
    final bytes = await length();
    if (bytes <= 0) return 0;

    return bytes / math.pow(1024, unit.id);
  }
}
