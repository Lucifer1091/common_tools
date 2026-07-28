// ignore_for_file: strict_top_level_inference, inference_failure_on_untyped_parameter

import 'package:logger/logger.dart';

final logger = _Logger();

class _Logger {
  late Logger _logger, _logger12;

  _Logger() {
    _logger = Logger(printer: PrettyPrinter(methodCount: 4));
    _logger12 = Logger(printer: PrettyPrinter(methodCount: 12));
  }

  void debug(message, {bool showDetails = false}) {
    showDetails ? _logger12.d(message) : _logger.d(message);
  }

  void trace(message, {bool showDetails = false}) {
    showDetails ? _logger12.t(message) : _logger.t(message);
  }

  void error(message, {StackTrace? stackTrace, bool showDetails = false}) {
    showDetails
        ? _logger12.e(message, stackTrace: stackTrace)
        : _logger.e(message, stackTrace: stackTrace);
  }

  void fatal(message, {StackTrace? stackTrace, bool showDetails = false}) {
    showDetails
        ? _logger12.f(message, stackTrace: stackTrace)
        : _logger.f(message, stackTrace: stackTrace);
  }

  void info(message, {bool showDetails = false}) {
    showDetails ? _logger12.i(message) : _logger.i(message);
  }

  void warn(message, {bool showDetails = false}) {
    showDetails ? _logger12.w(message) : _logger.w(message);
  }
}
