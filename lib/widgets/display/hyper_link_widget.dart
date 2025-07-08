import 'package:flutter/material.dart';

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
