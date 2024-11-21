import 'package:air_rowing/modules/club/clubDetail/club_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../club_state.dart';


class AllClubDetailPage extends StatelessWidget {
  final int clubId;
  final ClubDetail club;
  const AllClubDetailPage({super.key, required this.club, required this.clubId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '俱乐部详情',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body:  ClubDetailPage(club: club,clubId: clubId,)

    );
  }
}
