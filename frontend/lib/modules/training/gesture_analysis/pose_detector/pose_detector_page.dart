import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pose_detector_logic.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:camera/camera.dart';

import 'detector_view.dart';

class Pose_detectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.put(PoseDetectorLogic());
    final state = Get.find<PoseDetectorLogic>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Detector'),
      ),
      body: GetBuilder<PoseDetectorLogic>(
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Assume DetectorView is a widget that needs a camera feed
              DetectorView(
                title: 'Pose Detector',
                customPaint: state.customPaint.value,
                text: state.text.value,
                onImage: logic.processImage,
                initialCameraLensDirection: state.cameraLensDirection.value,
                onCameraLensDirectionChanged: (newDirection) => state.cameraLensDirection.value = newDirection,
              ),
              if (state.text.value != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    color: Colors.white,
                    child: Text(state.text.value ?? ''),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
