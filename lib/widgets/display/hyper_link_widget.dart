import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../index.dart';

/// HyperLinkWidget
class HyperLinkWidget extends StatefulWidget {
  const HyperLinkWidget({
    required this.text,
    super.key,
    this.style,
    this.maxLines = 1,
  });

  final TextSpan text;
  final TextStyle? style;
  final int maxLines;

  @override
  State<HyperLinkWidget> createState() => _HyperLinkWidgetState();
}

class _HyperLinkWidgetState extends State<HyperLinkWidget> {
  String hover = '0';

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: widget.style,
        children:
            widget.text.children
                ?.map(
                  (e) => TextSpan(
                    text: (e as TextSpan).text,
                    style:
                        e.recognizer != null
                            ? widget.style?.copyWith(
                              decoration:
                                  hover == e.text!
                                      ? TextDecoration.underline
                                      : null,
                            )
                            : null,
                    recognizer: e.recognizer,
                    onEnter: (_) {
                      hover = e.text!;
                      setState(() {});
                    },
                    onExit: (_) {
                      hover = '0';
                      setState(() {});
                    },
                  ),
                )
                .toList(),
      ),
    );
  }
}

/// Easy to use text widget, which converts inlined urls into clickable links.
/// Allows custom styling.
class LinkText extends StatefulWidget {
  /// Creates a [LinkText] widget, used for inlined urls.
  const LinkText(
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
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  final _gestureRecognizers = <TapGestureRecognizer>[];
  final _regex = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%.,_\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\,+.~#?&//=]*)',
  );
  final _shortenedRegex = RegExp(r'(.*)\?');

  @override
  void dispose() {
    for (final recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    super.dispose();
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

    final links = _regex.allMatches(widget.text);

    if (links.isEmpty) {
      return Text(
        widget.text,
        style: textStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
      );
    }

    final textParts = widget.text.split(_regex);
    final textSpans = <TextSpan>[];

    int i = 0;
    for (final part in textParts) {
      textSpans.add(TextSpan(text: part, style: textStyle));

      if (i < links.length) {
        final link = links.elementAt(i).group(0) ?? '';
        String? shortenedLink;

        final recognizer =
            TapGestureRecognizer()..onTap = () => _launchUrl(link);

        if (widget.shouldTrimParams) {
          shortenedLink = _shortenedRegex.firstMatch(link)?.group(1);
        }

        _gestureRecognizers.add(recognizer);
        textSpans.add(
          TextSpan(
            text: shortenedLink ?? link,
            style: linkStyle,
            recognizer: recognizer,
          ),
        );

        i++;
      }
    }

    return Text.rich(
      TextSpan(children: textSpans),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
    );
  }
}
