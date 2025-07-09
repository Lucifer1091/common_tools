import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../../exports/index.dart' hide FormData;

enum LogColor { none, black, red, green, yellow, blue, magenta, cyan, white }

enum LogType {
  /// Prints only response header with Time and Url
  mini,

  /// Prints full log but prints body as simple json --> easy to copy
  simple,

  /// Prints full log both request and response
  extended,
  none,
}

const _prefix = 'dio_logger';
const _startTimeKey = '$_prefix@start_time';

class DioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int kInitialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  final void Function(Object object) logPrint;

  /// log request color
  final LogColor requestColor;

  /// log response color
  final LogColor responseColor;

  /// log error color
  final LogColor errorColor;

  /// Print according to the type only
  final LogType logType;

  /// Show response time in sec true by default
  final bool showTimeInMs;

  final JsonEncoder _encoder = const JsonEncoder.withIndent('\t');

  DioLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
    this.compact = true,
    this.logPrint = print,
    this.requestColor = LogColor.yellow,
    this.responseColor = LogColor.green,
    this.errorColor = LogColor.red,
    this.logType = LogType.none,
    this.showTimeInMs = false,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request && logType != LogType.mini) {
      _printRequestHeader(options, color: requestColor);
    }
    if (requestHeader && logType != LogType.mini) {
      _printMapAsTable(
        options.queryParameters,
        header: 'Query Parameters',
        color: requestColor,
      );
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
      _printMapAsTable(requestHeaders, header: 'Headers', color: requestColor);
      _printMapAsTable(options.extra, header: 'Extras', color: requestColor);
    }
    if (requestBody && options.method != 'GET' && logType != LogType.mini) {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          _printMapAsTable(
            options.data as Map?,
            header: 'Body',
            color: requestColor,
          );
        }

        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);

          Map result = {};

          formDataMap.forEach((key, value) {
            dynamic temp;
            if (value is MultipartFile) {
              temp = value.filename ?? value;
            } else {
              temp = value;
            }
            result[key] = temp;
          });

          _printMapAsTable(
            result,
            header: 'Form data | ${data.boundary}',
            color: requestColor,
          );
        } else {
          _printBlock(data.toString(), color: requestColor);
        }
      }
    }
    // Starts the time as Api is hitting
    options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
          header: 'DioError ║ Status: ${err.response?.statusCode} '
              '${err.response?.statusMessage}',
          text: uri.toString(),
          color: errorColor,
        );
        if (err.response != null && err.response?.data != null) {
          _logPrint('╔ ${err.type.toString()}', color: errorColor);
          _printResponse(err.response!, color: errorColor);
        }
        _printLine('╚', '╝', errorColor);
        _logPrint('', color: errorColor);
      } else {
        _printBoxed(
          header: 'DioError ║ ${err.type}',
          text: err.message,
          color: errorColor,
        );
      }
    }
    super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    _printResponseHeader(response);
    if (responseHeader && logType != LogType.mini) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody && logType != LogType.mini) {
      if (logType == LogType.simple) {
        _logBlock(isBegin: true, type: ' Body ', pre: '\n');

        String json = _encoder.convert(response.data);
        dev.log('\n$json');

        _logBlock(isBegin: false, pre: '\n');
      } else {
        _logPrint('╔ Body');
        _logPrint('║');

        // This will print in different thread to avoid UI lagging
        if (!kIsWeb) {
          final isolateParse = VoidIsolateParser(
            run: () => _printResponse(response),
          );
          await isolateParse.parseInBackground();
        } else {
          _printResponse(response);
        }

        _logPrint('║');
        _printLine('╚');
      }
    }
    super.onResponse(response, handler);
  }

  /// Function for [LogType.simple]
  void _logBlock({bool isBegin = true, String type = '', String pre = ''}) {
    dev.log('$pre${'═' * (maxWidth ~/ 2)}$type${'═' * (maxWidth ~/ 2)}');
  }

  void _printBoxed({String? header, String? text, LogColor? color}) {
    _logPrint('', color: color);
    _logPrint('╔╣ $header', color: color);
    _logPrint('║  $text', color: color);
    _printLine('╚', '╝', color);
  }

  void _printResponse(Response response, {LogColor? color}) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map, color: color);
      } else if (response.data is Uint8List) {
        _logPrint('║${_indent()}[', color: color);
        _printUint8List(response.data as Uint8List, color: color);
        _logPrint('║${_indent()}]', color: color);
      } else if (response.data is List) {
        _logPrint('║${_indent()}[', color: color);
        _printList(response.data as List, color: color);
        _logPrint('║${_indent()}]', color: color);
      } else {
        _printBlock(response.data.toString(), color: color);
      }
    }
  }

  void _printResponseHeader(Response response, {LogColor? color}) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    final diff = DateTime.now().millisecondsSinceEpoch -
        response.requestOptions.extra[_startTimeKey];

    final time = showTimeInMs ? '$diff ms' : '${diff / 1000} s';

    _printBoxed(
      header: 'Response ║ $method '
          '║ Status: ${response.statusCode} ${response.statusMessage} ║ '
          'Time : $time',
      text: uri.toString(),
      color: color,
    );
  }

  void _printRequestHeader(RequestOptions options, {LogColor? color}) {
    final uri = options.uri;
    final method = options.method;

    _printBoxed(
      header: 'Request ║ $method ',
      text: uri.toString(),
      color: color,
    );
  }

  void _printLine([String pre = '', String suf = '╝', LogColor? color]) =>
      _logPrint('$pre${'═' * maxWidth}$suf', color: color);

  void _printKV(String? key, Object? v, {LogColor? color}) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      _logPrint(pre, color: color);
      _printBlock(msg, color: color);
    } else {
      _logPrint('$pre$msg', color: color);
    }
  }

  void _printBlock(String msg, {LogColor? color}) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      _logPrint(
        (i >= 0 ? '║ ' : '') +
            msg.substring(
              i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length),
            ),
        color: color,
      );
    }
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
    LogColor? color,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) _logPrint('║$initialIndent{', color: color);

    data.keys.toList().asMap().forEach(
      (index, dynamic key) {
        final isLast = index == data.length - 1;
        dynamic value = data[key];
        if (value is String) {
          value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
        }
        if (value is Map) {
          if (compact && _canFlattenMap(value)) {
            _logPrint(
              '║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}',
              color: color,
            );
          } else {
            _logPrint('║${_indent(tabs)} $key: {', color: color);
            _printPrettyMap(value, initialTab: tabs, color: color);
          }
        } else if (value is List) {
          if (compact && _canFlattenList(value)) {
            _logPrint(
              '║${_indent(tabs)} $key: ${value.toString()}',
              color: color,
            );
          } else {
            _logPrint('║${_indent(tabs)} $key: [', color: color);
            _printList(value, tabs: tabs, color: color);
            _logPrint('║${_indent(tabs)} ]${isLast ? '' : ','}', color: color);
          }
        } else {
          final msg = value.toString().replaceAll('\n', '');
          final indent = _indent(tabs);
          final linWidth = maxWidth - indent.length;
          if (msg.length + indent.length > linWidth) {
            final lines = (msg.length / linWidth).ceil();
            for (var i = 0; i < lines; ++i) {
              _logPrint(
                '║${_indent(tabs)} ${msg.substring(
                  i * linWidth,
                  math.min<int>(i * linWidth + linWidth, msg.length),
                )}',
                color: color,
              );
            }
          } else {
            _logPrint(
              '║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}',
              color: color,
            );
          }
        }
      },
    );

    _logPrint(
      '║$initialIndent}${isListItem && !isLast ? ',' : ''}',
      color: color,
    );
  }

  void _printList(List list, {int tabs = kInitialTab, LogColor? color}) {
    list.asMap().forEach(
      (i, dynamic e) {
        final isLast = i == list.length - 1;
        if (e is Map) {
          if (compact && _canFlattenMap(e)) {
            _logPrint(
              '║${_indent(tabs)}  $e${!isLast ? ',' : ''}',
              color: color,
            );
          } else {
            _printPrettyMap(
              e,
              initialTab: tabs + 1,
              isListItem: true,
              isLast: isLast,
              color: color,
            );
          }
        } else {
          _logPrint(
            '║${_indent(tabs + 2)} $e${isLast ? '' : ','}',
            color: color,
          );
        }
      },
    );
  }

  void _printUint8List(
    Uint8List list, {
    int tabs = kInitialTab,
    LogColor? color,
  }) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    for (var element in chunks) {
      _logPrint('║${_indent(tabs)} ${element.join(", ")}', color: color);
    }
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header, LogColor? color}) {
    if (map == null || map.isEmpty) return;
    _logPrint('╔ $header ', color: color);
    map.forEach(
      (dynamic key, dynamic value) {
        _printKV(key.toString(), value, color: color);
      },
    );
    _printLine('╚', '╝', color);
  }

  Future<void> _logPrint(Object object, {LogColor? color}) async {
    /// log color code
    String? logColor = switch (color ?? responseColor) {
      LogColor.black => '\x1B[30m',
      LogColor.red => '\x1B[31m',
      LogColor.green => '\x1B[32m',
      LogColor.yellow => '\x1B[33m',
      LogColor.blue => '\x1B[34m',
      LogColor.magenta => '\x1B[35m',
      LogColor.cyan => '\x1B[36m',
      LogColor.white => '\x1B[37m',
      LogColor.none || _ => '',
    };

    logPrint('$logColor$object${(logColor).isEmpty ? '' : '\x1B[0m'}');
  }
}
