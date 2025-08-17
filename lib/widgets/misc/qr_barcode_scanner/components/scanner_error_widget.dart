import '../../../layout/spaces.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorWidget extends StatelessWidget {
  final MobileScannerException error;
  final bool isRotated;

  const ScannerErrorWidget({
    super.key,
    required this.error,
    required this.isRotated,
  });

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied.';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device.';
      default:
        errorMessage = 'Generic Error.';
        break;
    }

    return ColoredBox(
      color: Colors.red.withValues(alpha: 0.5),
      child: Center(
        child: RotatedBox(
          quarterTurns: isRotated ? 1 : 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Icon(Icons.error, color: Colors.white, size: 40),
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const Space.h8(),
              Text(
                error.errorDetails?.message ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
