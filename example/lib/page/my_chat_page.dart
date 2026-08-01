import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyChatPage extends StatelessWidget {
  const MyChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc: 'Used to display conversational message groups and reactions.',
      exampleCodeGroup: 'chat',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Grouped messages',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildGroupedMessages,
            ),
            ExampleItem(
              desc: 'Message reactions',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildMessageReactions,
            ),
          ],
        ),
        ExampleModule(
          title: 'Interactive Playground',
          children: const [
            ExampleItem(
              desc: 'Bubble options',
              center: false,
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildChatPlayground,
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildChatPlayground(BuildContext context) {
    return const _ChatPlaygroundExample();
  }

  Widget _buildGroupedMessages(BuildContext context) {
    return _ChatLane(
      children: [
        MyChatGroup(
          color: context.colorScheme.primary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.primaryForeground,
          ),
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.end,
          ),
          alignment: AxisAlignmentDirectional.end,
          children: [
            MyChatBubble(
              child: Text(
                'John, did you remember what time you took the call with Mrs. Smith?',
              ),
            ),
            MyChatBubble(child: Text('Reply ASAP')),
          ],
        ),
        MyChatGroup(
          color: context.colorScheme.secondary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
          ),
          avatarPrefix: const MyAvatar(
            type: MyAvatarType.initials,
            initials: 'JO',
            size: MyAvatarSize.small,
          ),
          alignment: AxisAlignmentDirectional.start,
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.start,
            tailAlignment: () => AxisAlignmentDirectional.end,
          ),
          children: const [
            MyChatBubble(child: Text('Around 6 or 7?')),
            MyChatBubble(child: Text('New phone who dis?')),
          ],
        ),
        MyChatBubble(
          color: context.colorScheme.primary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.primaryForeground,
          ),
          alignment: AxisAlignmentDirectional.end,
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.end,
          ),
          child: const Text('SIX SEVENNN \u{1F924}\u{1F92A}'),
        ),
        MyChatGroup(
          color: context.colorScheme.secondary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
          ),
          avatarPrefix: const MyAvatar(
            type: MyAvatarType.initials,
            initials: 'JO',
            size: MyAvatarSize.small,
          ),
          alignment: AxisAlignmentDirectional.start,
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.start,
            tailAlignment: () => AxisAlignmentDirectional.end,
          ),
          children: const [
            MyChatBubble(child: Text('?')),
            MyChatBubble(child: Text('Seriously who is this')),
            MyChatBubble(child: Text('gonna have to block you')),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageReactions(BuildContext context) {
    return _ChatLane(
      children: [
        MyChatGroup(
          color: context.colorScheme.primary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.primaryForeground,
          ),
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.end,
          ),
          alignment: AxisAlignmentDirectional.end,
          children: const [
            MyChatBubble(
              child: Text(
                'John, did you remember what time you took the call with Mrs. Smith?',
              ),
            ),
            MyChatBubble(child: Text('Reply ASAP')),
          ],
        ),
        MyChatGroup(
          color: context.colorScheme.secondary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
          ),
          avatarPrefix: const MyAvatar(
            type: MyAvatarType.initials,
            initials: 'JO',
            size: MyAvatarSize.small,
          ),
          alignment: AxisAlignmentDirectional.start,
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.start,
            tailAlignment: () => AxisAlignmentDirectional.end,
          ),
          children: const [
            MyChatBubble(child: Text('Around 6 or 7?')),
            MyChatBubble(child: Text('New phone who dis?')),
          ],
        ),
        MyChatReaction(
          alignment: AxisAlignmentDirectional.end,
          reaction: MyChatReactionContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: const [Text('\u{2753}')],
            ),
          ),
          child: MyChatBubble(
            color: context.colorScheme.primary,
            textStyle: context.bodyMedium.copyWith(
              color: context.colorScheme.primaryForeground,
            ),
            alignment: AxisAlignmentDirectional.end,
            type: MyChatBubbleType.tail.copyWith(
              position: () => AxisDirectional.end,
            ),
            child: const Text('SIX SEVENNN \u{1F924}\u{1F92A}'),
          ),
        ),
        MyChatGroup(
          color: context.colorScheme.secondary,
          textStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.secondaryForeground,
          ),
          avatarPrefix: const MyAvatar(
            type: MyAvatarType.initials,
            initials: 'JO',
            size: MyAvatarSize.small,
          ),
          alignment: AxisAlignmentDirectional.start,
          type: MyChatBubbleType.tail.copyWith(
            position: () => AxisDirectional.start,
            tailAlignment: () => AxisAlignmentDirectional.end,
          ),
          children: [
            const MyChatBubble(child: Text('?')),
            const MyChatBubble(child: Text('Seriously who is this')),
            MyChatReaction(
              reaction: MyChatReactionContainer(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Text('\u{1F92A}'),
                    const Text('\u{1F44D}'),
                    MyText(
                      '+2',
                      fontSize: 12,
                      textColor: context.colorScheme.mutedForeground,
                    ),
                  ],
                ),
              ),
              child: const MyChatBubble(child: Text('gonna have to block you')),
            ),
          ],
        ),
      ],
    );
  }
}

enum _ChatPlaygroundType { plain, tail, sharpCorner }

class _ChatPlaygroundExample extends StatefulWidget {
  const _ChatPlaygroundExample();

  @override
  State<_ChatPlaygroundExample> createState() => _ChatPlaygroundExampleState();
}

class _ChatPlaygroundExampleState extends State<_ChatPlaygroundExample> {
  static const _typeOptions = <({String label, _ChatPlaygroundType value})>[
    (label: 'Plain', value: _ChatPlaygroundType.plain),
    (label: 'Tail', value: _ChatPlaygroundType.tail),
    (label: 'Sharp Corner', value: _ChatPlaygroundType.sharpCorner),
  ];

  static const _positionOptions = <({String label, AxisDirectional value})>[
    (label: 'Start', value: AxisDirectional.start),
    (label: 'End', value: AxisDirectional.end),
    (label: 'Up', value: AxisDirectional.up),
    (label: 'Down', value: AxisDirectional.down),
  ];

  static const _alignmentOptions =
      <({String label, AxisAlignmentDirectional value})>[
        (label: 'Start', value: AxisAlignmentDirectional.start),
        (label: 'Center', value: AxisAlignmentDirectional.center),
        (label: 'End', value: AxisAlignmentDirectional.end),
      ];

  static const _tailBehaviorOptions = <({String label, MyTailBehavior value})>[
    (label: 'First', value: MyTailBehavior.first),
    (label: 'Middle', value: MyTailBehavior.middle),
    (label: 'Last', value: MyTailBehavior.last),
  ];

  AxisDirectional selfPosition = AxisDirectional.end;
  AxisDirectional otherPosition = AxisDirectional.start;
  AxisAlignmentDirectional selfAlignment = AxisAlignmentDirectional.end;
  AxisAlignmentDirectional otherAlignment = AxisAlignmentDirectional.start;
  AxisAlignmentDirectional selfTailAlignment = AxisAlignmentDirectional.end;
  AxisAlignmentDirectional otherTailAlignment = AxisAlignmentDirectional.end;
  MyTailBehavior selfBehavior = MyTailBehavior.last;
  MyTailBehavior otherBehavior = MyTailBehavior.last;
  _ChatPlaygroundType type = _ChatPlaygroundType.tail;

  MyChatBubbleType get selfType {
    return switch (type) {
      _ChatPlaygroundType.tail => MyChatBubbleType.tail.copyWith(
        position: () => selfPosition,
        tailAlignment: () => selfTailAlignment,
        tailBehavior: () => selfBehavior,
      ),
      _ChatPlaygroundType.sharpCorner => MyChatBubbleType.sharpCorner.copyWith(
        tailBehavior: () => selfBehavior,
      ),
      _ChatPlaygroundType.plain => MyChatBubbleType.plain,
    };
  }

  MyChatBubbleType get otherType {
    return switch (type) {
      _ChatPlaygroundType.tail => MyChatBubbleType.tail.copyWith(
        position: () => otherPosition,
        tailAlignment: () => otherTailAlignment,
        tailBehavior: () => otherBehavior,
      ),
      _ChatPlaygroundType.sharpCorner => MyChatBubbleType.sharpCorner.copyWith(
        tailBehavior: () => otherBehavior,
      ),
      _ChatPlaygroundType.plain => MyChatBubbleType.plain,
    };
  }

  void _reset() {
    setState(() {
      selfPosition = AxisDirectional.end;
      otherPosition = AxisDirectional.start;
      selfAlignment = AxisAlignmentDirectional.end;
      otherAlignment = AxisAlignmentDirectional.start;
      selfTailAlignment = AxisAlignmentDirectional.end;
      otherTailAlignment = AxisAlignmentDirectional.end;
      selfBehavior = MyTailBehavior.last;
      otherBehavior = MyTailBehavior.last;
      type = _ChatPlaygroundType.tail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selfTextStyle = context.bodyMedium.copyWith(
      color: context.colorScheme.primaryForeground,
    );
    final otherTextStyle = context.bodyMedium.copyWith(
      color: context.colorScheme.secondaryForeground,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        _ChatLane(
          children: [
            MyChatGroup(
              color: context.colorScheme.primary,
              textStyle: selfTextStyle,
              type: selfType,
              alignment: selfAlignment,
              children: const [
                MyChatBubble(
                  child: Text(
                    'John, did you remember what time you took the call with Mrs. Smith?',
                  ),
                ),
                MyChatBubble(child: Text('Reply ASAP')),
              ],
            ),
            MyChatGroup(
              color: context.colorScheme.secondary,
              textStyle: otherTextStyle,
              avatarPrefix: const MyAvatar(
                type: MyAvatarType.initials,
                initials: 'JO',
                size: MyAvatarSize.small,
              ),
              type: otherType,
              alignment: otherAlignment,
              children: const [
                MyChatBubble(child: Text('Around 6 or 7?')),
                MyChatBubble(child: Text('New phone who dis?')),
              ],
            ),
            MyChatBubble(
              color: context.colorScheme.primary,
              textStyle: selfTextStyle,
              type: selfType,
              alignment: selfAlignment,
              child: const Text('SIX SEVENNN \u{1F924}\u{1F92A}'),
            ),
            MyChatGroup(
              color: context.colorScheme.secondary,
              textStyle: otherTextStyle,
              avatarPrefix: const MyAvatar(
                type: MyAvatarType.initials,
                initials: 'JO',
                size: MyAvatarSize.small,
              ),
              type: otherType,
              alignment: otherAlignment,
              children: const [
                MyChatBubble(child: Text('?')),
                MyChatBubble(child: Text('Seriously who is this')),
                MyChatBubble(child: Text('gonna have to block you')),
              ],
            ),
          ],
        ),
        const Gap(8),
        _ChatPlaygroundControls(
          children: [
            _select<_ChatPlaygroundType>(
              context: context,
              label: 'Bubble Type',
              value: type,
              options: _typeOptions,
              onChanged: (value) => setState(() => type = value),
            ),
            _select<AxisDirectional>(
              context: context,
              label: 'Self Position',
              value: selfPosition,
              options: _positionOptions,
              onChanged: (value) => setState(() => selfPosition = value),
            ),
            _select<AxisDirectional>(
              context: context,
              label: 'Other Position',
              value: otherPosition,
              options: _positionOptions,
              onChanged: (value) => setState(() => otherPosition = value),
            ),
            _select<AxisAlignmentDirectional>(
              context: context,
              label: 'Self Alignment',
              value: selfAlignment,
              options: _alignmentOptions,
              onChanged: (value) => setState(() => selfAlignment = value),
            ),
            _select<AxisAlignmentDirectional>(
              context: context,
              label: 'Other Alignment',
              value: otherAlignment,
              options: _alignmentOptions,
              onChanged: (value) => setState(() => otherAlignment = value),
            ),
            _select<AxisAlignmentDirectional>(
              context: context,
              label: 'Self Tail Align',
              value: selfTailAlignment,
              options: _alignmentOptions,
              onChanged: (value) => setState(() => selfTailAlignment = value),
            ),
            _select<AxisAlignmentDirectional>(
              context: context,
              label: 'Other Tail Align',
              value: otherTailAlignment,
              options: _alignmentOptions,
              onChanged: (value) => setState(() => otherTailAlignment = value),
            ),
            _select<MyTailBehavior>(
              context: context,
              label: 'Self Behavior',
              value: selfBehavior,
              options: _tailBehaviorOptions,
              onChanged: (value) => setState(() => selfBehavior = value),
            ),
            _select<MyTailBehavior>(
              context: context,
              label: 'Other Behavior',
              value: otherBehavior,
              options: _tailBehaviorOptions,
              onChanged: (value) => setState(() => otherBehavior = value),
            ),
            _ChatPlaygroundResetButton(onTap: _reset),
          ],
        ),
      ],
    );
  }

  Widget _select<T>({
    required BuildContext context,
    required String label,
    required T value,
    required List<({String label, T value})> options,
    required ValueChanged<T> onChanged,
  }) {
    String labelFor(T value) {
      return options.firstWhere((option) => option.value == value).label;
    }

    return _ChatPlaygroundField(
      label: label,
      child: MySelect<T>(
        initialValue: value,
        minWidth: 168,
        maxWidth: 220,
        options: [
          for (final option in options)
            MyOption<T>(value: option.value, child: Text(option.label)),
        ],
        selectedOptionBuilder: (context, value) => Text(labelFor(value)),
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class _ChatPlaygroundControls extends StatelessWidget {
  const _ChatPlaygroundControls({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 12, runSpacing: 12, children: children);
  }
}

class _ChatPlaygroundField extends StatelessWidget {
  const _ChatPlaygroundField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          MyText(
            label,
            fontSize: 12,
            textColor: context.colorScheme.mutedForeground,
          ),
          child,
        ],
      ),
    );
  }
}

class _ChatPlaygroundResetButton extends StatelessWidget {
  const _ChatPlaygroundResetButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          const SizedBox(height: 18),
          MyButton(
            text: 'Reset',
            type: MyButtonType.outline,
            size: MyButtonSize.medium,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ChatLane extends StatelessWidget {
  const _ChatLane({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: children,
      ),
    );
  }
}
