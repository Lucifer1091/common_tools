import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

const _displayTileWidth = 300.0;
const _imageAssetPath = 'assets/img/image.png';

class MyCustomPage extends StatelessWidget {
  const MyCustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'custom',
      desc:
          'Utility widgets from the custom and display directories, with route-level demos where navigation behavior matters.',
      children: [
        ExampleModule(
          title: 'Playgrounds',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: (context) => const _CustomPlaygroundLinks(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Inline Demos',
          children: [
            ExampleItem(
              desc: 'Limit Text Scale',
              builder: (context) => const _LimitTextScaleDemo(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Display Effects',
          children: [
            ExampleItem(desc: 'Gradient Widget', builder: _buildGradientText),
            ExampleItem(
              desc: 'Gradient Container',
              builder: _buildGradientContainer,
            ),
            ExampleItem(desc: 'Gradient Border', builder: _buildGradientBorder),
            ExampleItem(desc: 'Dotted Border', builder: _buildDottedBorder),
            ExampleItem(desc: 'Clip Shadow', builder: _buildClipShadow),
            ExampleItem(desc: 'Border Beam', builder: _buildBorderBeam),
            ExampleItem(desc: 'Blur', builder: _buildBlur),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientText(BuildContext context) {
    return GradientWidget(
      gradient: const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF8B5CF6), Color(0xFFF43F5E)],
      ),
      child: Text(
        'Signal Boost',
        style: context.headlineLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildGradientContainer(BuildContext context) {
    return GradientBorder(
      gradient: const LinearGradient(
        colors: [Color(0xFF34D399), Color(0xFF22D3EE)],
      ),
      borderRadius: 999,
      strokeWidth: 2,
      padding: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            'Gradient Container',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBorder(BuildContext context) {
    return GradientBorder(
      gradient: const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF8B5CF6), Color(0xFFF43F5E)],
      ),
      borderRadius: 999,
      strokeWidth: 3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          borderRadius: MyBorderRadius.round,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: context.colorScheme.foreground,
            ),
            const SizedBox(width: 10),
            Text(
              'Gradient Border',
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDottedBorder(BuildContext context) {
    return MyDottedBorder(
      color: context.colorScheme.primary,
      radius: 18,
      dotsWidth: 8,
      gap: 5,
      strokeWidth: 2,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 32,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              MyFaker.generateLoremIpsumWords(20),
              style: context.bodyMedium.copyWith(
                color: context.colorScheme.secondaryForeground,
              ),
            ),
          ),
        ],
      ).sizedBox(width: 280),
    );
  }

  Widget _buildClipShadow(BuildContext context) {
    return MyClipShadow(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.14),
          blurRadius: 18,
          offset: const Offset(0, 12),
        ),
      ],
      clipper: const _TicketClipper(),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECFCCB), Color(0xFFBBF7D0)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ClipShadow',
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF14532D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'The shadow follows the custom ticket-style path.',
              style: context.bodyMedium.copyWith(
                color: const Color(0xFF166534),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBorderBeam(BuildContext context) {
    return MyBorderBeam(
      colorFrom: Colors.blue,
      colorTo: Colors.purple,
      staticBorderColor: context.colorScheme.border,
      borderWidth: 2,
      duration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(20),
      padding: EdgeInsets.all(5),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 32,
              color: context.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Border beam keeps a moving accent around the panel.',
                style: context.bodyMedium.copyWith(
                  color: context.colorScheme.secondaryForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlur(BuildContext context) {
    return _BackdropFrame(
      label: 'Blur',
      child: Center(
        child: MyBlur(
          width: 210,
          blur: 10,
          elevation: 2,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withValues(alpha: 0.16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glass panel',
                style: context.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'BackdropFilter only applies inside this card.',
                style: context.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomPlaygroundLinks extends StatelessWidget {
  const _CustomPlaygroundLinks();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyCellGroup(
        bordered: true,
        theme: MyCellGroupTheme.card,
        style: MyCellStyle.style(
          context,
        ).copyWith(cardPadding: EdgeInsets.zero),
        cells: [
          MyCell(
            title: 'DoublePressBackWidget',
            description: 'Requires a route to demonstrate back handling.',
            arrow: true,
            onTap: (_) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _DoublePressBackDemoPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DoublePressBackDemoPage extends StatelessWidget {
  const _DoublePressBackDemoPage();

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: 'Press back again to leave this demo',
      child: ExamplePage(
        title: 'DoublePressBackWidget',
        desc:
            'Use the app-bar back button or system back. The first press shows a prompt, and the second press within two seconds exits.',
        exampleCodeGroup: 'custom',
        children: [
          ExampleModule(
            title: 'Live Example',
            children: [
              ExampleItem(
                center: false,
                padding: EdgeInsets.only(top: 16),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _DemoSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This whole route is wrapped with DoublePressBackWidget.',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'First back press shows a SnackBar. The next one within two seconds allows the route to close.',
                            style: context.bodyMedium.copyWith(
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LimitTextScaleDemo extends StatelessWidget {
  const _LimitTextScaleDemo();

  @override
  Widget build(BuildContext context) {
    final scaledData = MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(1.8));

    Widget panel({
      required BuildContext context,
      required String title,
      required Widget child,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colorScheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.secondaryForeground,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MediaQuery(
        data: scaledData,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            panel(
              context: context,
              title: 'Uncapped - 1.8x',
              child: Text(
                'This copy uses the full inherited text scale factor.',
                style: context.bodyMedium.copyWith(
                  color: context.colorScheme.foreground,
                ),
              ),
            ),
            const SizedBox(width: 12),
            panel(
              context: context,
              title: 'Capped - 1.2x',
              child: LimitTextScaleWidget(
                maxTextScaleFactor: 1.2,
                child: Text(
                  'This copy is clamped by LimitTextScaleWidget.',
                  style: context.bodyMedium.copyWith(
                    color: context.colorScheme.foreground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropFrame extends StatelessWidget {
  const _BackdropFrame({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _displayTileWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(_imageAssetPath, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: context.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 16)
      ..quadraticBezierTo(0, 0, 16, 0)
      ..lineTo(size.width - 28, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - 28, size.height)
      ..lineTo(16, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 16)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DemoSurface extends StatelessWidget {
  const _DemoSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
