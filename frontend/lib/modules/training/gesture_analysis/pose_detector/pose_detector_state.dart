
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoseDetectorState {
  Rx<CustomPaint?> customPaint = Rx<CustomPaint?>(null);
  Rx<String?> text = Rx<String?>(null);
  var cameraLensDirection = CameraLensDirection.back.obs;
  var isBusy = false.obs;
  var canProcess = true.obs;
}
