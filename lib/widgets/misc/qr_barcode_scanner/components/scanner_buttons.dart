import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../index.dart';
import '../../../layout/spaces.dart';

class ScannerButton extends StatelessWidget {
  const ScannerButton({
    super.key,
    this.tooltip,
    this.icon,
    this.onPressed,
    this.buttonColor,
    this.iconColor,
    this.borderColor,
    this.child,
    this.width = 40,
    this.height = 40,
  });

  final String? tooltip;
  final Icon? icon;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? iconColor;
  final Color? borderColor;
  final Widget? child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(5),
            // border: Border.all(color: borderColor ?? AppColors.greyShade1),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4 + 1),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
            onPressed: onPressed,
            child: child ?? icon,
          ),
        ),
      ),
    );
  }
}

class ZoomButtons extends StatefulWidget {
  const ZoomButtons({super.key, required this.controller});

  final MobileScannerController controller;

  @override
  State<ZoomButtons> createState() => _ZoomButtonsState();
}

class _ZoomButtonsState extends State<ZoomButtons> {
  double _zoomFactor = 0.0;
  final double scale = 0.2;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, state, child) {
        if (!PlatformChecker.isWeb &&
            (!state.isInitialized || !state.isRunning)) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            ScannerButton(
              icon: const Icon(
                CupertinoIcons.zoom_out,
                color: Color(0xFF414249),
              ),
              buttonColor: const Color(0xFFF0F9FF),
              onPressed: () async {
                setState(() {
                  _zoomFactor -= scale;
                  if (_zoomFactor < 0) _zoomFactor = 0;
                });
                await widget.controller.setZoomScale(_zoomFactor);
              },
            ),
            const Space.w12(),
            ScannerButton(
              icon: const Icon(
                CupertinoIcons.zoom_in,
                color: Color(0xFF414249),
              ),
              buttonColor: const Color(0xFFF0F9FF),
              onPressed: () async {
                setState(() {
                  _zoomFactor += scale;
                  if (_zoomFactor > 1) _zoomFactor = 1;
                });
                await widget.controller.setZoomScale(_zoomFactor);
              },
            ),
          ],
        );
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final IconData icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = CupertinoIcons.switch_camera_solid;
          case CameraFacing.back:
            icon = CupertinoIcons.switch_camera;
        }

        return ScannerButton(
          icon: Icon(icon, color: const Color(0xFF414249)),
          buttonColor: const Color(0xFFF0F9FF),
          onPressed: () async => await controller.switchCamera(),
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return ScannerButton(
              icon: const Icon(
                Icons.flash_auto_rounded,
                color: Color(0xFF414249),
              ),
              buttonColor: const Color(0xFFF0F9FF),
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.off:
            return ScannerButton(
              icon: const Icon(
                Icons.flash_off_rounded,
                color: Color(0xFF414249),
              ),
              buttonColor: const Color(0xFFF0F9FF),
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.on:
            return ScannerButton(
              icon: const Icon(
                Icons.flash_on_rounded,
                color: Color(0xFF414249),
              ),
              buttonColor: const Color(0xFFF0F9FF),
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.unavailable:
            return const ScannerButton(
              icon: Icon(Icons.no_flash_rounded, color: Color(0xFF414249)),
              buttonColor: Color(0xFFF0F9FF),
            );
        }
      },
    );
  }
}

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return ScannerButton(
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF414249),
            ),
            buttonColor: const Color(0xFFF0F9FF),
            onPressed: () async => await controller.start(),
          );
        }

        return ScannerButton(
          icon: const Icon(Icons.stop_rounded, color: Color(0xFF414249)),
          buttonColor: const Color(0xFFF0F9FF),
          onPressed: () async => await controller.stop(),
        );
      },
    );
  }
}
