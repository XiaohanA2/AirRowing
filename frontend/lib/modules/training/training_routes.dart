/**
 * @Description:
 * @Author: Chenn
 * @Date: 3/1/24
 **/

import 'package:get/get.dart';
import 'training_page.dart';
import 'c2/c2_page.dart';
import 'data_analysis/data_analysis_page.dart';
import 'gesture_analysis/gesture_analysis_page.dart';
import 'training_plan/training_plan_page.dart';
import 'gesture_analysis/pose_detector/pose_detector_page.dart';

class TrainingRoutes {
  static const String TRAINING = '/training';
  static const String C2 = '/training/c2';
  static const String DATA_ANALYSIS = '/training/data_analysis';
  static const String GESTURE_ANALYSIS = '/training/gesture_analysis';
  static const String TRAINING_PLAN = '/training/training_plan';
  static const String POSE_DETECTOR = '/training/gesture_analysis/pose_detector';


  static final List<GetPage> routes = [
    GetPage(
      name: TRAINING,
      page: () => TrainingPage(),
    ),
    GetPage(
        name: C2,
        page: () => C2Page()
    ),
    GetPage(
        name: DATA_ANALYSIS,
        page: () => Data_analysisPage()
    ),
    GetPage(
        name: GESTURE_ANALYSIS,
        page: () => Gesture_analysisPage()
    ),
    GetPage(
        name: TRAINING_PLAN,
        page: () => Training_planPage()
    ),
    GetPage(
        name: POSE_DETECTOR,
        page: () => Pose_detectorPage()
    )
  ];
}