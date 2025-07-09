import '../../../../exports/index.dart';
import 'components/scanner_buttons.dart';
import 'components/scanner_error_widget.dart';
import 'components/scanner_overlays.dart';

class BarcodeAndQRScanner extends StatefulWidget {
  final bool scanQrCode;
  final bool torchEnabled;
  final CameraFacing cameraFace;
  final void Function(
    BarcodeCapture barcode,
    MobileScannerController controller,
  )
  onDetect;
  final VoidCallback? onBackTap;
  final VoidCallback? onAddCodeTap;
  final MobileScannerController? controller;
  final List<BarcodeFormat>? formats;

  const BarcodeAndQRScanner({
    super.key,
    this.controller,
    this.scanQrCode = false,
    this.torchEnabled = false,
    this.cameraFace = CameraFacing.back,
    required this.onDetect,
    this.onAddCodeTap,
    this.onBackTap,
    this.formats,
  });

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
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void initState() {
    if (!UniversalPlatform.isWeb) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animateScanAnimation(true);
        } else if (status == AnimationStatus.dismissed) {
          animateScanAnimation(false);
        }
      });
      _animationController.forward(from: 0.0);
    }
    controller = widget.controller ?? initController;

    super.initState();
  }

  MobileScannerController get initController {
    if (widget.scanQrCode) {
      width = Sizes.WIDTH_400;
      height = Sizes.HEIGHT_400;

      return MobileScannerController(
        torchEnabled: widget.torchEnabled,
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: [BarcodeFormat.qrCode],
        facing: widget.cameraFace,
        // useNewCameraSelector: true,
      );
    } else {
      width = Sizes.WIDTH_400;
      height = Sizes.HEIGHT_300;
      return MobileScannerController(
        torchEnabled: widget.torchEnabled,
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats:
            widget.formats ??
            [
              BarcodeFormat.upcA,
              BarcodeFormat.upcE,
              BarcodeFormat.code128,
              BarcodeFormat.code39,
              BarcodeFormat.code93,
              BarcodeFormat.ean8,
              BarcodeFormat.ean13,
              BarcodeFormat.pdf417,
              BarcodeFormat.codebar,
              BarcodeFormat.aztec,
              BarcodeFormat.dataMatrix,
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
        !UniversalPlatform.isWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape;

    final cameraBox = MobileScanner(
      controller: controller,
      onDetect: (barcode) => widget.onDetect(barcode, controller),
      // scanWindow: UniversalPlatform.isWeb ? null : scanWindow,
      // scanWindowUpdateThreshold: UniversalPlatform.isWeb ? 200.0 : 0.0,
      overlayBuilder:
          UniversalPlatform.isWeb || !Responsive.isMobileOrMobileLarge
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
          bool isStarted = state.isInitialized || state.isRunning;

          return Stack(
            children: [
              if (UniversalPlatform.isWeb) ...[
                cameraBox,
              ] else ...[
                RotatedBox(quarterTurns: mustRotate ? 3 : 0, child: cameraBox),
              ],
              if (!UniversalPlatform.isWeb && isStarted) ...[
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
      bottom: Sizes.PADDING_20,
      right: 0,
      left: 0,
      child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Responsive.width,
                child: Row(
                  children: [
                    _buildORDivider(),
                    Text(
                      'OR',
                      style: context.labelSmall.copyWith(color: Colors.white),
                    ),
                    _buildORDivider(),
                  ],
                ),
              ),
              const SpaceH30(),
              TextButton(
                onPressed: widget.onAddCodeTap,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(EneftyIcons.code_outline),
                    SpaceW16(),
                    Text('Add Code Manually'),
                  ],
                ),
              ),
              const SpaceH30(),
            ],
          ).repaintBoundary,
    );
  }

  Widget _buildORDivider() {
    return Container(
      color: Colors.white,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_24),
    ).expanded();
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Responsive.value(
          mobile: context.height * 0.08,
          tablet: context.height * 0.03,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpaceW24(),
          CustomAppBarButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 21,
              color: AppColors.blackShade1,
            ),
            buttonColor: AppColors.blueShade3,
            onPressed: () {
              stopCamera();
              if (widget.onBackTap != null) {
                widget.onBackTap?.call();
              } else {
                Get.close(1);
              }
            },
          ),
          const Spacer(),
          ZoomButtons(controller: controller),
          const SpaceW12(),
          ToggleFlashlightButton(controller: controller),
          const SpaceW12(),
          SwitchCameraButton(controller: controller),
          const SpaceW12(),
        ],
      ),
    );
  }

  void stopCamera() {
    controller.stop();
    controller.dispose();
  }

  @override
  void dispose() {
    _animationController.dispose();
    stopCamera();
    super.dispose();
  }
}
