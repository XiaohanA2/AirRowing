import 'package:get/get.dart';

import '../community_state.dart';

class PersonalHomeState {
  PersonalHomeState() {
    ///Initialize variables
  }

  // 存储个人所有帖子
  var selfPosts = <Post>[].obs;
  var likedPosts = <Post>[].obs;
  var favoritedPosts = <Post>[].obs;

  PersonalInfo personalInfo = PersonalInfo(
    userNickname: "",
    userAvatar: "",
    userAge: 0,
    userLocation: "",
    userSignature: "",
  );
}

class PersonalInfo {
  final String userNickname;
  final String userAvatar;
  final int userAge;
  final String userLocation;
  final String userSignature;

  // 构造函数
  PersonalInfo({
    required this.userNickname,
    required this.userAvatar,
    required this.userAge,
    required this.userLocation,
    required this.userSignature,
    // required this.userNickname,
  });
}
