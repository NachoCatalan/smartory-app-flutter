import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraNotifier extends AsyncNotifier<CameraController> {
  @override
  Future<CameraController> build() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception('No se encontraron cámaras disponibles');
    }
    final controller = CameraController(
      cameras.first,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    await controller.initialize();

    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  }
}

final cameraProvider =
    AsyncNotifierProvider.autoDispose<CameraNotifier, CameraController>(
      CameraNotifier.new,
    );
