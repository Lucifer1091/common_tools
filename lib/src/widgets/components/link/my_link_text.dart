import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../extensions/widget.dart';

/// Easy to use text widget, which converts inlined urls into clickable links.
/// Allows custom styling.
class MyLinkText extends StatefulWidget {
  /// Creates a [MyLinkText] widget, used for inlined urls.
  const MyLinkText(
    this.text, {
    super.key,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.shouldTrimParams = false,
    this.onLinkTap,
    this.maxLines,
  });

  /// Text, which may contain inlined urls.
  final String text;

  /// Style of the non-url part of supplied text.
  final TextStyle? textStyle;

  /// Style of the url part of supplied text.
  final TextStyle? linkStyle;

  /// Determines how the text is aligned.
  final TextAlign textAlign;

  /// If true, this will cut off all visible params after '?'.
  /// This is only for improved readability. When executing the url
  /// the link with all params will stay the same.
  final bool shouldTrimParams;

  final int? maxLines;

  /// Overrides default behavior when tapping on links.
  /// Provides the url that was tapped.
  final void Function(String url)? onLinkTap;

  @override
  State<MyLinkText> createState() => _MyLinkTextState();
}

class _MyLinkTextState extends State<MyLinkText> {
  static final _regex = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%.,_\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\,+.~#?&//=]*)',
  );
  static final _shortenedRegex = RegExp(r'(.*)\?');

  final _gestureRecognizers = <TapGestureRecognizer>[];
  List<String> _textParts = const [];
  List<String> _links = const [];

  @override
  void initState() {
    super.initState();
    _rebuildParsedText();
  }

  @override
  void didUpdateWidget(covariant MyLinkText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _rebuildParsedText();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    _gestureRecognizers.clear();
  }

  void _rebuildParsedText() {
    _disposeRecognizers();

    final matches = _regex.allMatches(widget.text).toList(growable: false);
    _textParts = widget.text.split(_regex);
    _links = [
      for (final match in matches)
        if ((match.group(0) ?? '').isNotEmpty) match.group(0)!,
    ];

    for (final link in _links) {
      _gestureRecognizers.add(
        TapGestureRecognizer()..onTap = () => _launchUrl(link),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (widget.onLinkTap != null) {
      widget.onLinkTap!(url);
      return;
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyle = widget.textStyle ?? themeData.textTheme.bodyMedium;
    final linkStyle =
        widget.linkStyle ??
        themeData.textTheme.bodyMedium
            ?.copyWith(color: themeData.colorScheme.secondary)
            .underlined(
              color: themeData.colorScheme.secondary,
              distance: 3,
              thickness: 2,
            );

    if (_links.isEmpty) {
      return Text(
        widget.text,
        style: textStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final textSpans = <TextSpan>[];

    int i = 0;
    for (final part in _textParts) {
      textSpans.add(TextSpan(text: part, style: textStyle));

      if (i < _links.length) {
        final link = _links[i];
        String? shortenedLink;

        if (widget.shouldTrimParams) {
          shortenedLink = _shortenedRegex.firstMatch(link)?.group(1);
        }

        textSpans.add(
          TextSpan(
            text: shortenedLink ?? link,
            style: linkStyle,
            recognizer: _gestureRecognizers[i],
          ),
        );

        i++;
      }
    }

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
