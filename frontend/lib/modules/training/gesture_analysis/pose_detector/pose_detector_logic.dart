import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'pose_detector_state.dart';
import 'pose_painter.dart';

class PoseDetectorLogic extends GetxController {
  final PoseDetectorState state = PoseDetectorState();
  late final PoseDetector _poseDetector;
  double maxShoulderHip = 0;
  late PoseLandmark previousWrist;
  late FlutterTts _flutterTts;

  late final List<PoseLandmark> poseLandmarks;

  @override
  void onInit() {
    super.onInit();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
    _flutterTts = FlutterTts();
    _flutterTts.awaitSpeakCompletion(true);
  }

  Future _speak(String? content) async {
    await _flutterTts.setVolume(0.5);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1);

    if (content != null) {
      if (content.isNotEmpty) {
        await _flutterTts.speak(content);
      }
    }
  }

  @override
  void onClose() {
    state.canProcess.value = false;
    _poseDetector.close();
    super.onClose();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!state.canProcess.value || state.isBusy.value) return;

    state.isBusy.value = true;
    state.text.value = '';
    final poses = await _poseDetector.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        state.cameraLensDirection.value,
      );
      state.customPaint.value = CustomPaint(painter: painter);
      // 应该是在这里放判断
      for (var pose in poses) {
        if (!noReset(pose) ||
            !leanForwardFirst(pose) ||
            // !slideSeatNotFullyForward(pose) ||
            !pressingStroke(pose) ||
            !upperBodyMoveFirst(pose) ||
            !hunching(pose) ||
            !positionOfElbowAndShoulder(pose) ||
            // !noEarlLayback(pose) ||
            !handsHeight(pose) ||
            !notEnoughLayback(pose) ||
            // !armsBendTooEarly(pose) ||
            !rushSlideSeat(pose)) {
          if (Platform.isAndroid) {
            _speak("Wrong pose!");
          }
        }
      }
    } else {
      state.text.value = 'Poses found: ${poses.length}\n\n';
      state.customPaint.value = null;
    }

    state.isBusy.value = false;
    update(); // This triggers the GetBuilder to rebuild the widgets
  }

  double degreeCompute(PoseLandmark poseLandmark1, PoseLandmark poseLandmark2,
      PoseLandmark poseLandmark3) {
    Vector2 vec1 = Vector2(
        poseLandmark1.x - poseLandmark2.x, poseLandmark1.y - poseLandmark2.y);
    Vector2 vec2 = Vector2(
        poseLandmark3.x - poseLandmark2.x, poseLandmark3.y - poseLandmark2.y);
    final radian = vec1.angleTo(vec2);

    return degrees(radian);
  }

  bool noReset(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 < 160 && degree2 > 90) {
      return false;
    }
    return true;
  }

  bool leanForwardFirst(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftWrist]!,
        pose.landmarks[PoseLandmarkType.leftElbow]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 < 90 && degree2 < 170) {
      return false;
    }
    return true;
  }

  bool slideSeatNotFullyForward(Pose pose) {
    // TODO
    Vector2 horizon = Vector2(1, 0);
    Vector2 vec1 = Vector2(
        pose.landmarks[PoseLandmarkType.leftAnkle]!.x -
            pose.landmarks[PoseLandmarkType.leftKnee]!.x,
        pose.landmarks[PoseLandmarkType.leftAnkle]!.y -
            pose.landmarks[PoseLandmarkType.leftKnee]!.y);
    final radian = vec1.angleTo(horizon);
    if (degrees(radian) < 90) {
      return false;
    }
    return true;
  }

  bool pressingStroke(Pose pose) {
    final wristY = pose.landmarks[PoseLandmarkType.leftWrist]!.y;
    final shoulderY = pose.landmarks[PoseLandmarkType.leftShoulder]!.y;
    final hipY = pose.landmarks[PoseLandmarkType.leftHip]!.y;

    if (wristY - (shoulderY - hipY) * 1 / 3 - hipY < 0.000001) {
      return false;
    }
    return true;
  }

  bool upperBodyMoveFirst(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 < 90 && degree2 >= 90) {
      return false;
    }
    return true;
  }

  bool rushSlideSeat(Pose pose) {
    // TODO:
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftWrist]!,
        pose.landmarks[PoseLandmarkType.leftElbow]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 < 160 && degree2 > 160) {
      return false;
    }
    return true;
  }

  bool armsBendTooEarly(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftWrist]!,
        pose.landmarks[PoseLandmarkType.leftElbow]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 < 160 && degree2 > 160) {
      return false;
    }
    return true;
  }

  bool notEnoughLayback(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 > 170 && degree2 < 100) {
      return false;
    }
    return true;
  }

  bool handsHeight(Pose pose) {
    // TODO: frame about
    double degree = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftShoulder]!,
        pose.landmarks[PoseLandmarkType.leftWrist]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    if (degree == 180) {
      final Vector2 vector = Vector2(
          pose.landmarks[PoseLandmarkType.leftShoulder]!.x -
              pose.landmarks[PoseLandmarkType.leftHip]!.x,
          pose.landmarks[PoseLandmarkType.leftShoulder]!.y -
              pose.landmarks[PoseLandmarkType.leftHip]!.y);
      final Vector2 dis = Vector2(
          pose.landmarks[PoseLandmarkType.leftShoulder]!.x -
              pose.landmarks[PoseLandmarkType.leftWrist]!.x,
          pose.landmarks[PoseLandmarkType.leftShoulder]!.y -
              pose.landmarks[PoseLandmarkType.leftWrist]!.y);
      if (dis.length < vector.length * 3 / 5 &&
          dis.length > vector.length * 1 / 2) {
        return true;
      }
    }
    return false;
  }

  bool noEarlLayback(Pose pose) {
    double degree1 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!);
    double degree2 = degreeCompute(
        pose.landmarks[PoseLandmarkType.leftKnee]!,
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftShoulder]!);
    if (degree1 > 100 && degree2 < 90) {
      return false;
    }
    return true;
  }

  bool positionOfElbowAndShoulder(Pose pose) {
    // TODO: frame about
    if (pose.landmarks[PoseLandmarkType.leftElbow]!.y !=
        pose.landmarks[PoseLandmarkType.leftShoulder]!.y) {
      return false;
    }
    return true;
  }

  // bool recoveryNotHorizontalOrDriveHorizontal(Pose pose) {
  //   return true;
  // }

  bool hunching(Pose pose) {
    double dis = Vector2(
            pose.landmarks[PoseLandmarkType.leftShoulder]!.x -
                pose.landmarks[PoseLandmarkType.leftHip]!.x,
            pose.landmarks[PoseLandmarkType.leftShoulder]!.y -
                pose.landmarks[PoseLandmarkType.leftHip]!.y)
        .length;
    if (dis > maxShoulderHip) {
      maxShoulderHip = dis;
    } else if (dis < maxShoulderHip) {
      return false;
    }
    return true;
  }
// static bool recoveryTime(Pose pose) {
//   return true;
// }
}
