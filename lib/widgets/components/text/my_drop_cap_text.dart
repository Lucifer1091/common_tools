import 'dart:math';
import 'package:flutter/material.dart';
import '../../../index.dart';

/// Drop cap modes for [MyDropCapText].
enum MyDropCapMode {
  /// Default: drop cap inside the paragraph.
  inside,

  /// Drop cap upwards, aligned to the last line of the first row.
  upwards,

  /// Drop cap aside, not affecting the paragraph flow.
  aside,

  /// Baseline mode. Does not support dropCapPadding, indentation, dropCapPosition and custom dropCap.
  /// Try using DropCapMode.upwards with dropCapPadding and forceNoDescent=true for similar effect.
  baseline,
}

/// Drop cap position for [MyDropCapText].
enum MyDropCapPosition { start, end }

/// A widget for rendering a drop cap (large initial letter or widget) in a paragraph of text.
///
/// Supports custom drop cap widget, markdown parsing, indentation, and multiple layout modes.
class MyDropCapText extends StatelessWidget {
  /// Creates a drop cap text widget.
  ///
  /// [data] is required. See parameters for customization.
  const MyDropCapText(
    this.data, {
    super.key,
    this.mode = MyDropCapMode.inside,
    this.style,
    this.dropCapStyle,
    this.textAlign = TextAlign.start,
    this.dropCap,
    this.dropCapPadding = EdgeInsets.zero,
    this.indentation = Offset.zero,
    this.dropCapChars = 1,
    this.forceNoDescent = false,
    this.parseInlineMarkdown = false,
    this.textDirection = TextDirection.ltr,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.position,
  });

  /// The full text to display.
  final String data;

  /// The drop cap layout mode.
  final MyDropCapMode mode;

  /// The text style for the main paragraph.
  final TextStyle? style;

  /// The text style for the drop cap.
  final TextStyle? dropCapStyle;

  /// The alignment of the paragraph text.
  final TextAlign textAlign;

  /// Custom drop cap widget. If provided, overrides [dropCapChars].
  final MyDropCap? dropCap;

  /// Padding around the drop cap.
  final EdgeInsets dropCapPadding;

  /// Indentation for the paragraph after the drop cap.
  final Offset indentation;

  /// Number of characters to use as the drop cap (ignored if [dropCap] is provided).
  final int dropCapChars;

  /// Forces the drop cap to ignore font descent for tighter layout.
  final bool forceNoDescent;

  /// Enables parsing of inline markdown in the paragraph.
  final bool parseInlineMarkdown;

  /// The text direction.
  final TextDirection textDirection;

  /// The drop cap position (start or end).
  final MyDropCapPosition? position;

  /// Maximum number of lines for the paragraph.
  final int? maxLines;

  /// Overflow behavior for the paragraph.
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyLarge = context.bodyLarge;

    TextStyle textStyle = TextStyle(
      color: bodyLarge.color ?? context.colorScheme.foreground,
      fontSize: 14,
      height: 1,
      fontFamily: bodyLarge.fontFamily,
    ).merge(style);

    if (data.isEmpty) return MyText(data, style: textStyle);

    final double textStyleFontSize = textStyle.fontSize!;

    final TextStyle capStyle = TextStyle(
      color: textStyle.color,
      fontSize: textStyleFontSize * 5.5,
      fontFamily: textStyle.fontFamily,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      height: 1,
    ).merge(dropCapStyle);

    textStyle = textStyle.copyWith(
      fontSize: MediaQuery.textScalerOf(context).scale(textStyleFontSize),
    );

    double capWidth, capHeight;
    final int dropCapChars = dropCap != null ? 0 : this.dropCapChars;
    CrossAxisAlignment sideCrossAxisAlignment = CrossAxisAlignment.start;
    final _MarkdownParser? mdData =
        parseInlineMarkdown ? _MarkdownParser(data) : null;
    final String dropCapStr = (mdData?.plainText ?? data).substring(
      0,
      dropCapChars,
    );

    if (mode == MyDropCapMode.baseline && dropCap == null) {
      return _buildBaseline(context, textStyle, capStyle);
    }

    // Custom DropCap widget
    if (dropCap != null) {
      capWidth = dropCap!.width;
      capHeight = dropCap!.height;
    } else {
      final TextPainter capPainter = TextPainter(
        text: MyTextSpan(text: dropCapStr, style: capStyle),
        textDirection: textDirection,
      )..layout();
      capWidth = capPainter.width;
      capHeight = capPainter.height;
      if (forceNoDescent) {
        final List<LineMetrics> ls = capPainter.computeLineMetrics();
        capHeight -=
            ls.isNotEmpty ? ls[0].descent * 0.95 : capPainter.height * 0.2;
      }
    }

    // Compute drop cap padding
    capWidth += dropCapPadding.left + dropCapPadding.right;
    capHeight += dropCapPadding.top + dropCapPadding.bottom;

    final _MarkdownParser? mdRest =
        parseInlineMarkdown ? mdData!.subchars(dropCapChars) : null;
    final String restData = data.substring(dropCapChars);

    final MyTextSpan textSpan = MyTextSpan(
      text: parseInlineMarkdown ? null : restData,
      children: parseInlineMarkdown ? mdRest!.toTextSpanList() : null,
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      textDirection: textDirection,
      text: textSpan,
      textAlign: textAlign,
    );
    final double lineHeight = textPainter.preferredLineHeight;

    int rows = ((capHeight - indentation.dy) / lineHeight).ceil();

    // Drop cap mode: upwards
    if (mode == MyDropCapMode.upwards) {
      rows = 1;
      sideCrossAxisAlignment = CrossAxisAlignment.end;
    }

    // Layout builder for responsive drop cap
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double boundsWidth = constraints.maxWidth - capWidth;
        if (boundsWidth < 1) boundsWidth = 1;

        int charIndexEnd = data.length;

        if (rows > 0) {
          textPainter.layout(maxWidth: boundsWidth);
          final double yPos = rows * lineHeight;
          final int charIndex =
              textPainter.getPositionForOffset(Offset(0, yPos)).offset;
          textPainter
            ..maxLines = rows
            ..layout(maxWidth: boundsWidth);
          if (textPainter.didExceedMaxLines) charIndexEnd = charIndex;
        } else {
          charIndexEnd = dropCapChars;
        }

        // Drop cap mode: aside
        if (mode == MyDropCapMode.aside) charIndexEnd = data.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              textDirection:
                  position == null || position == MyDropCapPosition.start
                      ? textDirection
                      : (textDirection == TextDirection.ltr
                          ? TextDirection.rtl
                          : TextDirection.ltr),
              crossAxisAlignment: sideCrossAxisAlignment,
              children: <Widget>[
                if (dropCap != null)
                  Padding(padding: dropCapPadding, child: dropCap)
                else
                  Container(
                    width: capWidth,
                    height: capHeight,
                    padding: dropCapPadding,
                    child: RichText(
                      textDirection: textDirection,
                      textAlign: textAlign,
                      text: MyTextSpan(text: dropCapStr, style: capStyle),
                    ),
                  ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(top: indentation.dy),
                    width: boundsWidth,
                    height:
                        mode != MyDropCapMode.aside
                            ? (lineHeight * min(maxLines ?? rows, rows)) +
                                indentation.dy
                            : null,
                    child: RichText(
                      overflow:
                          (maxLines == null ||
                                  (maxLines! > rows &&
                                      overflow == TextOverflow.fade))
                              ? TextOverflow.clip
                              : overflow,
                      maxLines: maxLines,
                      textDirection: textDirection,
                      textAlign: textAlign,
                      text: textSpan,
                    ),
                  ),
                ),
              ],
            ),
            if (maxLines == null || maxLines! > rows)
              Padding(
                padding: EdgeInsets.only(left: indentation.dx),
                child: RichText(
                  overflow: overflow,
                  maxLines:
                      maxLines != null && maxLines! > rows
                          ? maxLines! - rows
                          : null,
                  textAlign: textAlign,
                  textDirection: textDirection,
                  text: MyTextSpan(
                    text:
                        parseInlineMarkdown
                            ? null
                            : restData.substring(
                              min(charIndexEnd, restData.length),
                            ),
                    children:
                        parseInlineMarkdown
                            ? mdRest!.subchars(charIndexEnd).toTextSpanList()
                            : null,
                    style: textStyle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Builds drop cap text in baseline mode.
  RichText _buildBaseline(
    BuildContext context,
    TextStyle textStyle,
    TextStyle capStyle,
  ) {
    final _MarkdownParser mdData = _MarkdownParser(data);

    return RichText(
      textAlign: textAlign,
      text: MyTextSpan(
        style: textStyle,
        children: <MyTextSpan>[
          MyTextSpan(
            text: mdData.plainText.substring(0, dropCapChars),
            style: capStyle.merge(const TextStyle(height: 0)),
          ),
          MyTextSpan(
            children: mdData.subchars(dropCapChars).toTextSpanList(),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

/// A widget for rendering a custom drop cap (large initial letter or widget).
class MyDropCap extends StatelessWidget {
  /// Creates a custom drop cap widget.
  const MyDropCap({
    required this.child,
    required this.width,
    required this.height,
    super.key,
  });

  /// The drop cap widget.
  final Widget child;

  /// The width of the drop cap.
  final double width;

  /// The height of the drop cap.
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: child);
  }
}

// ...existing _MarkdownParser, _MarkdownSpan, _Markup classes...

class _MarkdownParser {
  _MarkdownParser(this.data) {
    plainText = '';
    spans = [_MarkdownSpan(text: '', markups: [], style: TextStyle())];

    bool bold = false;
    bool italic = false;
    bool underline = false;

    const String MARKUP_BOLD = '**';
    const String MARKUP_ITALIC = '_';
    const String MARKUP_UNDERLINE = '++';

    void addSpan(String markup, bool isOpening) {
      final List<_Markup> markups = [_Markup(markup, isOpening)];

      if (bold && markup != MARKUP_BOLD)
        markups.add(_Markup(MARKUP_BOLD, true));
      if (italic && markup != MARKUP_ITALIC) {
        markups.add(_Markup(MARKUP_ITALIC, true));
      }
      if (underline && markup != MARKUP_UNDERLINE) {
        markups.add(_Markup(MARKUP_UNDERLINE, true));
      }

      spans.add(
        _MarkdownSpan(
          text: '',
          markups: markups,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
            fontStyle: italic ? FontStyle.italic : null,
            decoration: underline ? TextDecoration.underline : null,
          ),
        ),
      );
    }

    bool checkMarkup(int i, String markup) {
      return data.substring(i, min(i + markup.length, data.length)) == markup;
    }

    for (int c = 0; c < data.length; c++) {
      if (checkMarkup(c, MARKUP_BOLD)) {
        bold = !bold;
        addSpan(MARKUP_BOLD, bold);
        c += MARKUP_BOLD.length - 1;
      } else if (checkMarkup(c, MARKUP_ITALIC)) {
        italic = !italic;
        addSpan(MARKUP_ITALIC, italic);
        c += MARKUP_ITALIC.length - 1;
      } else if (checkMarkup(c, MARKUP_UNDERLINE)) {
        underline = !underline;
        addSpan(MARKUP_UNDERLINE, underline);
        c += MARKUP_UNDERLINE.length - 1;
      } else {
        spans[spans.length - 1].text += data[c];
        plainText += data[c];
      }
    }
  }
  final String data;
  late List<_MarkdownSpan> spans;
  String plainText = '';

  List<TextSpan> toTextSpanList() {
    return spans.map((s) => s.toTextSpan()).toList();
  }

  _MarkdownParser subchars(int startIndex, [int? endIndex]) {
    final List<_MarkdownSpan> subspans = [];
    int skip = startIndex;
    for (int s = 0; s < spans.length; s++) {
      final _MarkdownSpan span = spans[s];
      if (skip <= 0) {
        subspans.add(span);
      } else if (span.text.length < skip) {
        skip -= span.text.length;
      } else {
        subspans.add(
          _MarkdownSpan(
            style: span.style,
            markups: span.markups,
            text: span.text.substring(skip, span.text.length),
          ),
        );
        skip = 0;
      }
    }

    return _MarkdownParser(
      subspans
          .asMap()
          .map((int index, _MarkdownSpan span) {
            final String markup =
                index > 0
                    ? (span.markups.isNotEmpty ? span.markups[0].code : '')
                    : span.markups.map((m) => m.isActive ? m.code : '').join();
            return MapEntry(index, '$markup${span.text}');
          })
          .values
          .toList()
          .join(),
    );
  }
}

class _MarkdownSpan {
  _MarkdownSpan({
    required this.text,
    required this.style,
    required this.markups,
  });

  final TextStyle style;
  final List<_Markup> markups;
  String text;

  TextSpan toTextSpan() => TextSpan(text: text, style: style);
}

class _Markup {
  _Markup(this.code, this.isActive);
  final String code;
  final bool isActive;
}
