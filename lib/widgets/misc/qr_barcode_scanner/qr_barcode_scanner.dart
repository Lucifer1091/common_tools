import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../index.dart';

class BarcodeAndQRScanner extends StatefulWidget {
  const BarcodeAndQRScanner({
    required this.onDetect,
    super.key,
    this.controller,
    this.scanQrCode = false,
    this.torchEnabled = false,
    this.cameraFace = CameraFacing.back,
    this.onAddCodeTap,
    this.onBackTap,
  });

  final bool scanQrCode;
  final bool torchEnabled;
  final CameraFacing cameraFace;
  final void Function(BarcodeCapture barcode) onDetect;
  final VoidCallback? onBackTap;
  final VoidCallback? onAddCodeTap;
  final MobileScannerController? controller;

  @override
  State<BarcodeAndQRScanner> createState() => _BarcodeAndQRScannerState();
}

class _BarcodeAndQRScannerState extends State<BarcodeAndQRScanner>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController controller;
  late double width, height;

  late AnimationController _animationController;

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1);
    } else {
      _animationController.forward(from: 0);
    }
  }

  @override
  void initState() {
    if (!PlatformChecker.isWeb) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      _animationController
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animateScanAnimation(true);
          } else if (status == AnimationStatus.dismissed) {
            animateScanAnimation(false);
          }
        })
        ..forward(from: 0);
    }
    controller = widget.controller ?? initController;

    super.initState();
  }

  MobileScannerController get initController {
    if (widget.scanQrCode) {
      width = 400;
      height = 400;

      return MobileScannerController(
        torchEnabled: widget.torchEnabled,
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: [BarcodeFormat.qrCode],
        facing: widget.cameraFace,
        // useNewCameraSelector: true,
      );
    } else {
      width = 400;
      height = 300;
      return MobileScannerController(
        torchEnabled: widget.torchEnabled,
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: [
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.code128,
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.code39,
          BarcodeFormat.code93,
          BarcodeFormat.ean8,
          BarcodeFormat.ean13,
          BarcodeFormat.pdf417,
        ],
        facing: widget.cameraFace,
        // useNewCameraSelector: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final scanWindow = Rect.fromCenter(
    //   center: MediaQuery.of(context).size.center(Offset.zero),
    //   width: width,
    //   height: height,
    // );

    final mustRotate =
        !PlatformChecker.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;

    final cameraBox = MobileScanner(
      controller: controller,
      onDetect: widget.onDetect,
      // scanWindow: PlatformChecker.isWeb ? null : scanWindow,
      // scanWindowUpdateThreshold: PlatformChecker.isWeb ? 200.0 : 0.0,
      overlayBuilder:
          PlatformChecker.isWeb || !context.isCompact
              ? null
              : (context, constraints) {
                return ScannerAnimation(
                  stopped: false,
                  width: width * .80,
                  height: constraints.maxHeight,
                  animation: _animationController,
                );
              },
      errorBuilder: (_, error, child) {
        return ScannerErrorWidget(error: error, isRotated: mustRotate);
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFF040404).withValues(alpha: 0.58),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, state, child) {
          final bool isStarted = state.isInitialized || state.isRunning;

          return Stack(
            children: [
              if (PlatformChecker.isWeb) ...[
                cameraBox,
              ] else ...[
                RotatedBox(quarterTurns: mustRotate ? 3 : 0, child: cameraBox),
              ],
              if (!PlatformChecker.isWeb && isStarted) ...[
                BlurCutout.backDropFilter(width: width, height: height),
                ScanAreaShape.build(width: width, height: height),
              ],
              _buildAppBar(context).repaintBoundary,
              if (widget.onAddCodeTap != null && isStarted) _buildFooter(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width,
                child: Row(
                  children: [
                    _buildORDivider(),
                    Text(
                      'OR',
                      style: context.labelSmall?.copyWith(color: Colors.white),
                    ),
                    _buildORDivider(),
                  ],
                ),
              ),
              const Space.h30(),
              TextButton(
                onPressed: widget.onAddCodeTap,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_2_rounded),
                    Space.w16(),
                    Text('Add Code Manually'),
                  ],
                ),
              ),
              const Space.h30(),
            ],
          ).repaintBoundary,
    );
  }

  Widget _buildORDivider() {
    return Container(
      color: Colors.white,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24),
    ).expanded();
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Responsive.value(
          context,
          compact: context.height * 0.08,
          large: context.height * 0.03,
        ),
      ),
      child: Row(
        children: [
          const Space.w24(),
          ScannerButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 21,
              color: Color(0xFF414249),
            ),
            buttonColor: const Color(0xFFF0F9FF),
            onPressed: () {
              if (widget.onBackTap != null) {
                widget.onBackTap?.call();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          const Spacer(),
          ZoomButtons(controller: controller),
          const Space.w12(),
          ToggleFlashlightButton(controller: controller),
          const Space.w12(),
          SwitchCameraButton(controller: controller),
          const Space.w12(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    unawaited(controller.stop());
    unawaited(controller.dispose());
    super.dispose();
  }
}
