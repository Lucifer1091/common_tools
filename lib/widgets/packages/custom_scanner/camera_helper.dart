import 'package:back_office/exports/index.dart';

enum ScanType { text, camera, multiple }

class Camera {
  static Future<String?> scan({
    bool qrCode = false,
    bool repeatScan = false,
    bool useFullScreen = false,
    void Function(String value)? onDetect,
    List<BarcodeFormat>? formats,
  }) async {
    void detected(String? barcode) {
      if (barcode != null && barcode.trim().isNotEmpty) {
        onDetect?.call(barcode.trim());
        Get.close((1));
      }
    }

    if (UniversalPlatform.isDesktop) {
      SnackBars.error(message: 'Scanner not supported on this platform.');
      return null;
    }

    // if (UniversalPlatform.isWeb &&
    //     defaultTargetPlatform == TargetPlatform.android) {
    //   if (!useFullScreen) {
    //     // Required for unique routing
    //     String type = qrCode ? 'QrScan_' : 'BarcodeScan_';
    //     String routeName = '/$type${UniqueKey().hashCode}';
    //
    //     return await Get.to<String?>(
    //       routeName: repeatScan ? null : routeName,
    //       () => getBarcodeWidget(arguments: detected),
    //     );
    //   } else {
    //     return await Dialogs.fullscreen(
    //       content: getBarcodeWidget(arguments: detected),
    //     );
    //   }
    // }

    if (!useFullScreen) {
      // Required for unique routing
      String type = qrCode ? 'QrScan_' : 'BarcodeScan_';
      String routeName = '/$type${UniqueKey().hashCode}';

      return await Get.to<String?>(
        routeName: repeatScan ? null : routeName,
        () => BarcodeAndQRScanner(
          scanQrCode: qrCode,
          formats: formats,
          onDetect: (barcode, camera) {
            if (barcode.barcodes.isNotEmpty) {
              String? scanned = barcode.barcodes.first.rawValue?.trim();

              if (scanned?.isNotEmpty ?? false) {
                if (onDetect != null) {
                  detected(scanned);
                } else {
                  Get.back<String?>(result: scanned!);
                }

                camera.stop();
                camera.dispose();
              }
            }
          },
        ),
      );
    } else {
      return await Dialogs.fullscreen(
        content: BarcodeAndQRScanner(
          scanQrCode: qrCode,
          formats: formats,
          onDetect: (barcode, camera) {
            if (barcode.barcodes.isNotEmpty) {
              String? scanned = barcode.barcodes.first.rawValue?.trim();

              if (scanned?.isNotEmpty ?? false) {
                if (onDetect != null) {
                  detected(scanned);
                } else {
                  Get.back<String?>(result: scanned!);
                }

                camera.stop();
                camera.dispose();
              }
            }
          },
        ),
      );
    }
  }
}
