import 'package:flutter/material.dart';

import 'td_collapse_panel.dart';
import 'td_collapse_salted_key.dart';
import 'td_inset_divider.dart';
import 'td_nonanimated_expand_icon.dart';

enum TDCollapseStyle { block, card }

/// Collapse panel list component, needs to be used with [TDCollapsePanel]
class TDCollapse extends StatefulWidget {
  const TDCollapse({
    required this.children,
    this.style = TDCollapseStyle.block,
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation = 0,
    super.key,
  }) : _allowOnlyOnePanelOpen = false,
       initialOpenPanelValue = null;

  const TDCollapse.accordion({
    required this.children,
    this.style = TDCollapseStyle.block,
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation = 0,
    this.initialOpenPanelValue,
    super.key,
  }) : _allowOnlyOnePanelOpen = true;

  /// Style of the folding panel list
  /// - [TDCollapseStyle.block] Full-bar style
  /// - [TDCollapseStyle.card] Card style
  final TDCollapseStyle style;

  final List<TDCollapsePanel> children;

  /// Callback function for the folding panel list;
  /// When calling back, the input parameters are the index of the currently
  /// clicked folding panel and the expanded status isExpanded
  final ExpansionPanelCallback? expansionCallback;

  final Duration animationDuration;

  final double elevation;

  /// The default expanded panel value of the folded panel list;
  /// This value takes effect when [TDCollapse.accordion] is used
  final Object? initialOpenPanelValue;

  final bool _allowOnlyOnePanelOpen;

  @override
  State createState() => _TDCollapseState();
}

class _TDCollapseState extends State<TDCollapse> {
  TDCollapsePanel? _currentOpenPanel;

  @override
  void initState() {
    super.initState();

    if (!widget._allowOnlyOnePanelOpen) return;

    assert(
      _allPanelsHaveValue(),
      'When allowing only one panel to be open, every panel must have a value.',
    );
    assert(
      _allPanelsHaveDistinctValues(),
      'When allowing only one panel to be open, every panel must have a distinct value.',
    );

    if (widget.initialOpenPanelValue != null) {
      _currentOpenPanel = _searchPanelByValue(widget.initialOpenPanelValue);
    }
  }

  @override
  void didUpdateWidget(TDCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = null;
      return;
    }

    assert(
      _allPanelsHaveValue(),
      'When allowing only one panel to be open, every panel must have a value.',
    );
    assert(
      _allPanelsHaveDistinctValues(),
      'When allowing only one panel to be open, every panel must have a distinct value.',
    );

    // when the widget is updated to accordion mode
    // we need to initialize the current open panel to defaultOpenPanelValue
    if (!oldWidget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = _searchPanelByValue(widget.initialOpenPanelValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <MergeableMaterialItem>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(_buildGap(context, index * 2 - 1));
      }

      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];

      final titleWidget = _buildTitleWidget(context, child, index);
      final expandIconWidget = _buildExpandIconWidget(context, child, index);

      final borderRadius =
          _isCardStyle() ? _createRadius(index) : BorderRadius.zero;

      items.add(
        MaterialSlice(
          key: TDCollapseSaltedKey<BuildContext, int>(context, index * 2),
          color: child.backgroundColor,
          child: Column(
            // to prevent collapse state change when parent rebuild
            key: TDCollapseSaltedKey<BuildContext, int>(context, index * 2),
            children: [
              MergeSemantics(
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: () => _handlePressed(index, _isChildExpanded(index)),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: widget.animationDuration,
                          curve: Curves.fastOutSlowIn,
                          margin: EdgeInsets.zero,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: kMinInteractiveDimension,
                            ),
                            child: titleWidget,
                          ),
                        ),
                      ),
                      expandIconWidget,
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: Container(height: 0),
                secondChild: Column(
                  children: [
                    const TDInsetDivider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: child.body,
                    ),
                  ],
                ),
                firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(
                  0.4,
                  1,
                  curve: Curves.fastOutSlowIn,
                ),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState:
                    _isChildExpanded(index)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
              if (!isLastChild) const TDInsetDivider(),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && !isLastChild) {
        items.add(_buildGap(context, index * 2 + 1));
      }
    }

    // FIXME: Non-continuously expanded items will cause animation loss during expansion
    Widget collapse = MergeableMaterial(
      elevation: widget.elevation,
      children: items,
    );

    if (_isCardStyle()) {
      collapse = Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: collapse,
        ),
      );
    }

    return collapse;
  }

  MergeableMaterialItem _buildGap(BuildContext context, int value) {
    return MaterialGap(
      size: 0,
      key: TDCollapseSaltedKey<BuildContext, int>(context, value),
    );
  }

  BorderRadius _createRadius(int index) {
    final radius = Radius.circular(9);

    final isFirst = index == 0;
    if (isFirst) {
      return BorderRadius.only(topLeft: radius, topRight: radius);
    }

    final isLast = index == widget.children.length - 1;
    if (isLast) {
      return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
    }

    return BorderRadius.zero;
  }

  bool _isCardStyle() {
    return widget.style == TDCollapseStyle.card;
  }

  bool _isChildExpanded(int index) {
    final child = widget.children[index];

    if (widget._allowOnlyOnePanelOpen) {
      return _currentOpenPanel?.value == child.value;
    }

    return child.isExpanded;
  }

  void _handlePressed(int index, bool isExpanded) {
    widget.expansionCallback?.call(index, isExpanded);

    if (!widget._allowOnlyOnePanelOpen) return;

    // collapse the current open panel by calling its expansion callback to false
    for (
      var childIndex = 0;
      childIndex < widget.children.length;
      childIndex += 1
    ) {
      final curChild = widget.children[childIndex];
      if (widget.expansionCallback != null &&
          childIndex != index &&
          curChild.value == _currentOpenPanel?.value) {
        widget.expansionCallback!(childIndex, false);
      }
    }

    setState(() {
      _currentOpenPanel = isExpanded ? null : widget.children[index];
    });
  }

  Widget _buildTitleWidget(
    BuildContext context,
    TDCollapsePanel child,
    int index,
  ) {
    final titleWidget = child.headerBuilder(context, _isChildExpanded(index));
    return ListTile(title: titleWidget);
  }

  Widget _buildExpandIconWidget(
    BuildContext context,
    TDCollapsePanel child,
    int index,
  ) {
    final Widget expandedIcon = Container(
      key: TDCollapseSaltedKey<BuildContext, int>(context, index * 2),
      margin: EdgeInsetsDirectional.zero,
      child: TdNonAnimatedExpandIcon(
        isExpanded: _isChildExpanded(index),
        padding:
            child.expandIconTextBuilder != null
                ? const EdgeInsets.only(right: 16, top: 16, bottom: 16)
                : const EdgeInsets.all(16),
      ),
    );

    return Row(
      children: [
        if (child.expandIconTextBuilder != null)
          Text(
            child.expandIconTextBuilder!(context, _isChildExpanded(index)),
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.black.withValues(alpha: .4)),
          ),
        expandedIcon,
      ],
    );
  }

  bool _allPanelsHaveValue() {
    return widget.children.every((TDCollapsePanel child) {
      return child.value != null;
    });
  }

  bool _allPanelsHaveDistinctValues() {
    final valueSet = <Object?>{};
    return widget.children.every((TDCollapsePanel child) {
      if (!valueSet.add(child.value)) return false;

      return true;
    });
  }

  TDCollapsePanel? _searchPanelByValue(Object? value) {
    for (var index = 0; index < widget.children.length; index += 1) {
      final child = widget.children[index];
      if (child.value == value) return child;
    }
    return null;
  }
}
