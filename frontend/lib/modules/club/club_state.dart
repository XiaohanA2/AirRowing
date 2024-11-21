import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClubState {
  ClubState() {
    ///Initialize variables
  }

  var clubId = 0.obs; // 新增 clubId 变量
  var clubInfo = ClubDetail().obs;

  var trainingList = <Training>[].obs;

  var competitionList = <Training>[].obs;

  var trainingIsLoading = false.obs;

  var competitionIsLoading = false.obs;

  var myClubIsLoading = false.obs;

}


class Training{
  int trainingId;
  String url;
  String title;
  String location;
  String date;
  String endDate;
  int memberCount;
  bool isDdl;
  bool isSignin;

  Training({
    required this.trainingId,
    required this.url,
    required this.title,
    required this.location,
    required this.date,
    required this.endDate,
    required this.memberCount,
    required this.isDdl,
    required this.isSignin,
  });

}


class Club {
  int clubID;
  String name;
  String avatar;
  String address;
  String foundingDate;
  int memberCount;
  int enterState;//   0-未加入，1-已加入，2-审核中

  Club({
    required this.clubID,
    required this.name,
    required this.avatar,
    required this.address,
    required this.foundingDate,
    required this.memberCount,
    required this.enterState,
  });
}

class ClubDetail{

  String clubSrc;
  String name;
  String description;
  String coachSrc;
  String coachName;
  String coachDes;

  ClubDetail({
    this.clubSrc = "assets/club/logo.png",
    this.name = "",
    this.description = "",
    this.coachSrc = "assets/club/logo.png",
    this.coachName = "",
    this.coachDes = "",
  });

}