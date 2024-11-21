import 'dart:convert';

import 'package:air_rowing/generated/json/base/json_field.dart';
import 'package:get/get.dart';
class ProfileState {
  var userDetailedInfo = <UserDetailedInfo>[].obs;
  var boatTrainingEntity = <BoatTrainingEntity>[].obs;
  var userProfile = UserProfile(
    id: 0,
    username: 'Yyq',
    nickname: '',
    remark: '',
    deptId: 0,
    deptName: '',
    postIds: [],
    email: '',
    mobile: '0',
    sex: 0,
    avatar: '',
    status: 0,
    loginIp: '',
    loginDate: DateTime.now(),
    createTime: DateTime.now(),
  ).obs;
  var userProfileData = UserProfileData(
    id: 0,
    realName: 'default',
    nickname: 'default',
    country: 'default',
    mobile: 'default',
    email: 'default@example.com',
    areaId: 0,
    sex: 0,
    birthday: DateTime.now(),
    height: 0,
    weight: 0,
    followingNumber: 0,
    followerNumber: 0,
    signature: 'default',
    rowSince: DateTime.now(),
    favoriteBoat: 0,
    currentTarget: 'default',
    status: 0,
    loginIp: 'default',
    loginDate: DateTime.now(),
    mark: 'default',
    point: 0,
    tagIds: 'default',
    levelId: 0,
    experience: 0,
    groupId: 0,
    createTime: DateTime.now(),
    deleted: false,
    twokRecord: 0,
    registerIp: 'default',
  ).obs;
}

@JsonSerializable()
class UserDetailedInfo {
  final int userId;
  final String userNickname;
  final String userRealName;
  final String userCountry;
  final String userPortraitUrl;
  final String userEmail;
  final String userPassword;
  final String userPhoneNumber;
  final String userClub;
  final String userAddress;
  final String userGender;
  final int userAge;
  final int userHeight;
  final int userWeight;
  final int userFollowerNumber;
  final int userFollowingNumber;
  final String userSignature;
  final int userRowSince;
  final String user2000mRecord;
  final String userFavoriteBoat;
  final String userIdol;
  final String userCurrentTarget;
  final String userUnforgettableExperience;
  final String userRowReason;
  final bool userIsBanned;
  final bool userIsOnline;
  final DateTime userLastLoginTime;
  final DateTime userRegistrationDate;

  UserDetailedInfo({
    required this.userId,
    required this.userNickname,
    required this.userRealName,
    required this.userCountry,
    required this.userPortraitUrl,
    required this.userEmail,
    required this.userPassword,
    required this.userPhoneNumber,
    required this.userClub,
    required this.userAddress,
    required this.userGender,
    required this.userAge,
    required this.userHeight,
    required this.userWeight,
    required this.userFollowerNumber,
    required this.userFollowingNumber,
    required this.userSignature,
    required this.userRowSince,
    required this.user2000mRecord,
    required this.userFavoriteBoat,
    required this.userIdol,
    required this.userCurrentTarget,
    required this.userUnforgettableExperience,
    required this.userRowReason,
    required this.userIsBanned,
    required this.userIsOnline,
    required this.userLastLoginTime,
    required this.userRegistrationDate,
  });


// 可以添加方法，如 toJson, fromJson 等，便于与JSON数据的转换。
  factory UserDetailedInfo.fromJson(Map<String, dynamic> json) {
    return UserDetailedInfo(
      userId: json['user_id'],
      userNickname: json['user_nickname'],
      userRealName: json['user_real_name'],
      userCountry: json['user_country'],
      userPortraitUrl: json['user_portrait_url'],
      userEmail: json['user_email'],
      userPassword: json['user_password'],
      userPhoneNumber: json['user_phone_number'],
      userClub: json['user_club'],
      userAddress: json['user_address'],
      userGender: json['user_gender'],
      userAge: json['user_age'],
      userHeight: json['user_height'],
      userWeight: json['user_weight'],
      userFollowerNumber: json['user_follower_number'],
      userFollowingNumber: json['user_following_number'],
      userSignature: json['user_signature'],
      userRowSince: json['user_row_since'],
      user2000mRecord: json['user_2000m_record'],
      userFavoriteBoat: json['user_favorite_boat'],
      userIdol: json['user_idol'],
      userCurrentTarget: json['user_current_target'],
      userUnforgettableExperience: json['user_unforgettable_experience'],
      userRowReason: json['user_row_reason'],
      userIsBanned: json['user_is_banned'],
      userIsOnline: json['user_is_online'],
      userLastLoginTime: DateTime.parse(json['user_last_login_time']),
      userRegistrationDate: DateTime.parse(json['user_registration_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_nickname': userNickname,
      'user_real_name': userRealName,
      'user_country': userCountry,
      'user_portrait_url': userPortraitUrl,
      'user_email': userEmail,
      'user_password': userPassword,
      'user_phone_number': userPhoneNumber,
      'user_club': userClub,
      'user_address': userAddress,
      'user_gender': userGender,
      'user_age': userAge,
      'user_height': userHeight,
      'user_weight': userWeight,
      'user_follower_number': userFollowerNumber,
      'user_following_number': userFollowingNumber,
      'user_signature': userSignature,
      'user_row_since': userRowSince,
      'user_2000m_record': user2000mRecord,
      'user_favorite_boat': userFavoriteBoat,
      'user_idol': userIdol,
      'user_current_target': userCurrentTarget,
      'user_unforgettable_experience': userUnforgettableExperience,
      'user_row_reason': userRowReason,
      'user_is_banned': userIsBanned,
      'user_is_online': userIsOnline,
      'user_last_login_time': userLastLoginTime.toIso8601String(),
      'user_registration_date': userRegistrationDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

@JsonSerializable()
class UserProfile {
  final int id;
  final String username;
  final String nickname;
  final String remark;
  final int deptId;
  final String deptName;
  final List<dynamic> postIds;
  final String email;
  final String mobile;
  final int sex;
  final String avatar;
  final int status;
  final String loginIp;
  final DateTime loginDate;
  final DateTime createTime;

  UserProfile({
    required this.id,
    required this.username,
    required this.nickname,
    required this.remark,
    required this.deptId,
    required this.deptName,
    required this.postIds,
    required this.email,
    required this.mobile,
    required this.sex,
    required this.avatar,
    required this.status,
    required this.loginIp,
    required this.loginDate,
    required this.createTime,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      nickname: json['nickname'],
      remark: json['remark'],
      deptId: json['deptId'],
      deptName: json['deptName'],
      postIds: json['postIds'],
      email: json['email'],
      mobile: json['mobile'],
      sex: json['sex'],
      avatar: json['avatar'] as String,
      status: json['status'],
      loginIp: json['loginIp'],
      loginDate: DateTime.parse(json['loginDate']),
      createTime: DateTime.parse(json['createTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'remark': remark,
      'deptId': deptId,
      'deptName': deptName,
      'postIds': postIds,
      'email': email,
      'mobile': mobile,
      'sex': sex,
      'avatar': avatar,
      'status': status,
      'loginIp': loginIp,
      'loginDate': loginDate.toIso8601String(),
      'createTime': createTime.toIso8601String(),
    };
  }
}

@JsonSerializable()
class BoatTrainingEntity {
  final int userId;
  final int id;
  final String trainingTime;
  final int totalDistance;
  Map<String, dynamic> totalTime; // Changed to a map to directly store the nested structure
  final int totalPace;
  final int heartRate;
  final int strokeRate;
  final String note;
  final String boatType;
  final String content;
  final String place;

  BoatTrainingEntity({
    required this.userId,
    required this.id,
    required this.trainingTime,
    required this.totalDistance,
    required this.totalTime,
    required this.totalPace,
    required this.heartRate,
    required this.strokeRate,
    required this.note,
    required this.boatType,
    required this.content,
    required this.place,
  });

  factory BoatTrainingEntity.fromJson(Map<String, dynamic> json) {
    return BoatTrainingEntity(
      userId: json['userId'],
      id: json['id'],
      trainingTime: json['trainingTime'],
      totalDistance: json['totalDistance'],
      totalTime: json['totalTime'] as Map<String, dynamic>, // Directly storing the map
      totalPace: json['totalPace'],
      heartRate: json['heartRate'],
      strokeRate: json['strokeRate'],
      note: json['note'],
      boatType: json['boatType']as String? ?? '',
      content: json['content']as String? ?? '',
      place: json['place']as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'trainingTime': trainingTime,
      'totalDistance': totalDistance,
      'totalTime': totalTime, // Directly using the map
      'totalPace': totalPace,
      'heartRate': heartRate,
      'strokeRate': strokeRate,
      'note': note,
      'boatType': boatType,
      'content': content,
      'place': place,
    };
  }
}

@JsonSerializable()
class UserProfileData {
  final int id;
  final String realName;
  final String nickname;
  final String country;
  final String mobile;
  final String email;
  final int areaId;
  final int sex;
  final DateTime birthday;
  final double height;
  final double weight;
  final int followingNumber;
  final int followerNumber;
  final String signature;
  final DateTime rowSince;
  final int favoriteBoat;
  final String currentTarget;
  final int status;
  final String loginIp;
  final DateTime loginDate;
  final String mark;
  final int point;
  final String tagIds;
  final int levelId;
  final int experience;
  final int groupId;
  final DateTime createTime;
  final bool deleted;
  final double twokRecord;
  final String registerIp;

  UserProfileData({
    required this.id,
    required this.realName,
    required this.nickname,
    required this.country,
    required this.mobile,
    required this.email,
    required this.areaId,
    required this.sex,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.followingNumber,
    required this.followerNumber,
    required this.signature,
    required this.rowSince,
    required this.favoriteBoat,
    required this.currentTarget,
    required this.status,
    required this.loginIp,
    required this.loginDate,
    required this.mark,
    required this.point,
    required this.tagIds,
    required this.levelId,
    required this.experience,
    required this.groupId,
    required this.createTime,
    required this.deleted,
    required this.twokRecord,
    required this.registerIp,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is List) {
        return DateTime(value[0], value[1], value[2]);
      } else {
        throw Exception("Unsupported date format: $value");
      }
    }

    return UserProfileData(
      id: json['id'],
      realName: json['realName'],
      nickname: json['nickname'],
      country: json['country'],
      mobile: json['mobile'],
      email: json['email'],
      areaId: json['areaId'],
      sex: json['sex'],
      birthday: parseDate(json['birthday']),
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      followingNumber: json['followingNumber'],
      followerNumber: json['followerNumber'],
      signature: json['signature'],
      rowSince: parseDate(json['rowSince']),
      favoriteBoat: json['favoriteBoat'],
      currentTarget: json['currentTarget'],
      status: json['status'],
      loginIp: json['loginIp'],
      loginDate: parseDate(json['loginDate']),
      mark: json['mark'],
      point: json['point'],
      tagIds: json['tagIds'],
      levelId: json['levelId'],
      experience: json['experience'],
      groupId: json['groupId'],
      createTime: parseDate(json['createTime']),
      deleted: json['deleted'],
      twokRecord: json['twokRecord'].toDouble(),
      registerIp: json['registerIp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'realName': realName,
      'nickname': nickname,
      'country': country,
      'mobile': mobile,
      'email': email,
      'areaId': areaId,
      'sex': sex,
      'birthday': birthday.toIso8601String(),
      'height': height,
      'weight': weight,
      'followingNumber': followingNumber,
      'followerNumber': followerNumber,
      'signature': signature,
      'rowSince': rowSince.toIso8601String(),
      'favoriteBoat': favoriteBoat,
      'currentTarget': currentTarget,
      'status': status,
      'loginIp': loginIp,
      'loginDate': loginDate.toIso8601String(),
      'mark': mark,
      'point': point,
      'tagIds': tagIds,
      'levelId': levelId,
      'experience': experience,
      'groupId': groupId,
      'createTime': createTime.toIso8601String(),
      'deleted': deleted,
      'twokRecord': twokRecord,
      'registerIp': registerIp,
    };
  }
}




