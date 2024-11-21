import 'package:get/get.dart';

class MyClubState {
  MyClubState() {
    ///Initialize variables
  }



  var memberList = <Member>[].obs;

  
  var attendanceMemberList = <AttendanceMember>[].obs;

}


class Member {
  String avatar;
  String name;
  String department;
  String enterDate;
  bool role;

  Member({
    required this.avatar,
    required this.name,
    required this.department,
    required this.enterDate,
    required this.role,
  });
}


class AttendanceMember{
  String avatar;
  String name;
  int attendanceCount;
    AttendanceMember({
      required this.avatar,
      required this.name,
      required this.attendanceCount,
  });
}


