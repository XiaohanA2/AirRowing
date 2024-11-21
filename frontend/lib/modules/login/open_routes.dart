import 'package:get/get.dart';
import 'package:air_rowing/modules/home/home_page.dart';
import 'login_page.dart';
import 'code/code_page.dart';
/**
 * @description: open_routes
 * @author: yangyiqun
 * @date: 2/26/24
 */

class OpenRoutes {
  static const String LOGIN = '/login';
  static const String CODE = '/code';
  static const String HOME = '/home';
  static final List<GetPage> routes = [
    GetPage(
      name: LOGIN,
      page: () => LoginPage(),
      transition: Transition.fade
    ),
    GetPage(
      name: CODE,
      page: () => CodePage(),
    ),
    GetPage(
      name: HOME,
      page: () => HomePage(),
    ),
  ];
}