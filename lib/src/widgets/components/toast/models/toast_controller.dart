import 'package:flutter/material.dart';

@immutable
class ToastController {
  const ToastController({required this.id, required this.close});

  factory ToastController.empty() => ToastController(id: '', close: () {});

  final String id;
  final VoidCallback close;

  @override
  String toString() => 'ToastController(id: $id, closeToast: $close)';
}
