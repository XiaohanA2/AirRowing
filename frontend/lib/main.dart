import 'package:air_rowing/main_frame.dart';
import 'package:air_rowing/modules/club/club_routes.dart';
import 'package:air_rowing/modules/login/login_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/home/home_routes.dart';
import 'modules/club/club_routes.dart';
import 'modules/community/community_routes.dart';
import 'modules/training/training_routes.dart';
import 'modules/login/login_page.dart';
import 'modules/login/open_routes.dart';
import 'config/color_scheme.dart';
import 'modules/home/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:air_rowing/modules/home/profile/profile_logic.dart';
import 'api/base_api_client.dart';

void main() async{
  BaseApiClient.addInterceptors();
  try {
    await dotenv.load();
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(LoginLogic());
    Get.put(ProfileLogic());
    final List<GetPage> allRoutes = []
      ..addAll(HomeRoutes.routes)
      ..addAll(ClubRoutes.routes)
      ..addAll(OpenRoutes.routes)
      ..addAll(TrainingRoutes.routes)
      ..addAll(CommunityRoutes.routes);

    return GetMaterialApp(
      // 使用GetMaterialApp代替MaterialApp
      title: 'Airrowing',
      home: LoginPage(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        // 此处全局设置字体，需要在pubspec中注册
        // fontFamily: 'Schyler',
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      getPages: allRoutes,
    );
  }
}
