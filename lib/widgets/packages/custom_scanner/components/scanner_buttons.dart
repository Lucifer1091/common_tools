import '../../../../exports/index.dart';

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
        if (!kIsWeb && (!state.isInitialized || !state.isRunning)) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            CustomAppBarButton(
              icon: const Icon(
                CupertinoIcons.zoom_out,
                color: AppColors.blackShade1,
              ),
              buttonColor: AppColors.blueShade3,
              onPressed: () async {
                setState(() {
                  _zoomFactor -= scale;
                  if (_zoomFactor < 0) _zoomFactor = 0;
                });
                await widget.controller.setZoomScale(_zoomFactor);
              },
            ),
            const SpaceW12(),
            CustomAppBarButton(
              icon: const Icon(
                CupertinoIcons.zoom_in,
                color: AppColors.blackShade1,
              ),
              buttonColor: AppColors.blueShade3,
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

        return CustomAppBarButton(
          icon: Icon(icon, color: AppColors.blackShade1),
          buttonColor: AppColors.blueShade3,
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
            return CustomAppBarButton(
              icon: const Icon(
                Icons.flash_auto_rounded,
                color: AppColors.blackShade1,
              ),
              buttonColor: AppColors.blueShade3,
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.off:
            return CustomAppBarButton(
              icon: const Icon(
                Icons.flash_off_rounded,
                color: AppColors.blackShade1,
              ),
              buttonColor: AppColors.blueShade3,
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.on:
            return CustomAppBarButton(
              icon: const Icon(
                Icons.flash_on_rounded,
                color: AppColors.blackShade1,
              ),
              buttonColor: AppColors.blueShade3,
              onPressed: () async => await controller.toggleTorch(),
            );
          case TorchState.unavailable:
            return const CustomAppBarButton(
              icon: Icon(Icons.no_flash_rounded, color: AppColors.blackShade1),
              buttonColor: AppColors.blueShade3,
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
          return CustomAppBarButton(
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.blackShade1,
            ),
            buttonColor: AppColors.blueShade3,
            onPressed: () async => await controller.start(),
          );
        }

        return CustomAppBarButton(
          icon: const Icon(Icons.stop_rounded, color: AppColors.blackShade1),
          buttonColor: AppColors.blueShade3,
          onPressed: () async => await controller.stop(),
        );
      },
    );
  }
}
