import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import '../../index.dart';

extension FileExtensionX on XFile {
  /// Get file name
  String get fileName => p.basename(path);

  /// Get file extension
  String get extension => p.extension(path);

  /// Get mime type
  String? get mimeType {
    // On web, path may not exist → fallback to mime lookup from bytes
    final fromPath = lookupMimeType(path);
    if (fromPath != null) return fromPath;

    return this.mimeType;
  }

  /// check weather file is image
  bool get isImage =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.image);

  /// check whether file is pdf
  bool get isPdf =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.pdf);

  /// check whether file is audio
  bool get isAudio =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.audio);

  /// check weather file is video
  bool get isVideo =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.video);

  /// check weather file is ms doc
  bool get isDoc =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.doc);

  /// check whether file is presentation document
  bool get isPPT =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.ppt);

  /// check whether file is excel sheet
  bool get isExcel =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.excel);

  /// check whether file is excel sheet
  bool get isTxt =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.txt);

  /// check whether file is excel sheet
  bool get isXml =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.xml);

  /// check whether file is svg
  bool get isSvg =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.svg);

  /// check whether file is csv
  bool get isCsv =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.csv);

  /// check whether file is archive
  bool get isArchive =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.archive);

  /// check whether file is json
  bool get isJson =>
      RegexMatcher.matchFile(mimeType ?? extension, RegexFileType.json);

  /// checks whether given file is docx, pdf, xls, ppt or txt
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

  /// get file size in mb
  Future<double> get sizeInMb async {
    final sizeInBytes = await length();
    return sizeInBytes / (1024 * 1024);
  }
}
