/**
 * @Description:
 * @Author: Chenn
 * @Date: 2/21/24
 **/

import 'package:get/get.dart';
import 'attendance/attendance_page.dart';
import 'club_page.dart';
import 'event/event_page.dart';
import 'message/message_page.dart';
import 'myClub/myClub_page.dart';
import 'allClub/all_club_page.dart';

class ClubRoutes {
  static final List<GetPage> routes = [
    GetPage(
      name: '/club',
      page: () => ClubPage(),
    ),

    GetPage(
        name: '/club/myClub',
        page: () => MyClubPage()
    ),

    GetPage(
        name: '/club/allClub',
        page: () => AllClubPage()
    ),

    GetPage(
        name: '/club/attendance',
        page: () => AttendancePage()
    ),

    GetPage(
        name: '/club/message',
        page: () => MessagePage()
    ),

  ];
}

