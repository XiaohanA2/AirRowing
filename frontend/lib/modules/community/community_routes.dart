/**
 * @Description
 * @Author: Jixian
 * @Date:
 */

import 'package:get/get.dart';

import 'community_page.dart';
import 'detailed_post/detailed_post_page.dart';
import 'edit_info/edit_info_page.dart';
import 'personal_home/personal_home_page.dart';
import 'video_post/video_post_page.dart';
import 'create_post/create_post_page.dart';


class CommunityRoutes {
  static final List<GetPage> routes = [
    GetPage(
      name: '/community',
      page: () => CommunityPage(),
    ),
    GetPage(
        name: '/community/detailed_post',
        page: () => Detailed_postPage()
    ),
    GetPage(
        name: '/community/video_post',
        page: () => Video_postPage()
    ),
    GetPage(
        name: '/community/personal_home',
        page: () => PersonalHomePage()
    ),
    GetPage(
        name: '/community/edit_info',
        page: () => EditInfoPage()
    ),
    GetPage(
        name: '/community/create_post',
        page: () => CreatePostPage()
    ),
  ];
}