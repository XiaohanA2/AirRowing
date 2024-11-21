import 'package:air_rowing/modules/home/medal_wall/medal_wall_logic.dart';
import 'package:air_rowing/modules/home/medal_wall/medal_wall_page.dart';
import 'package:air_rowing/modules/home/training_record/training_record_page.dart';
import 'package:air_rowing/modules/home/training_detail/training_detail_page.dart';
import 'package:get/get.dart';

import 'home_page.dart';
import 'profile/profile_binding.dart';
import 'profile/profile_page.dart';
import 'settings/settings_page.dart'; // 假设这是个人主页模块的另一个页面
/**
 * @description: home_routes
 * @author: yangyiqun
 * @date: 1/29/24
 */

class HomeRoutes {
  static const String HOME = '/home';
  static const String PROFILE = '/home/profile';
  static const String SETTINGS = '/home/settings';
  static const String MEDAL_WALL = '/home/profile/medal_wall';
  static const String TRAINING_RECORD = '/home/profile/training_record';
  static const String TRAINING_DETAIL = '/home/profile/training_record/training_detail';
  static final List<GetPage> routes = [
    GetPage(
      name: PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(), // 假设你有一个ProfileBinding用于ProfileView
    ),
    GetPage(
      name: HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: SETTINGS,
      page: () => SettingsPage(),
    ),
    GetPage(
      name: MEDAL_WALL,
      page: () => MedalWallPage(),
    ),
    GetPage(
      name: TRAINING_RECORD,
      page: () => TrainingRecordPage(),
    ),
    GetPage(
      name: TRAINING_DETAIL,
      page: () => TrainingDetailPage(),
    )
  ];
}
