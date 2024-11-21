import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../club_state.dart';
import 'event_logic.dart';
import 'event_state.dart';

class EventPage extends StatelessWidget {
  final int type;
  final Training training;

  const EventPage({Key? key, required this.training, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(EventLogic());
    final state = Get.find<EventLogic>().state;

    Color buttonColor;
    String buttonText;

    if (!training.isSignin && !training.isDdl) {
      buttonColor = Colors.blue;
      buttonText = '点击报名';
    } else if (training.isSignin && !training.isDdl) {
      buttonColor = Colors.blue;
      buttonText = '取消报名';
    } else if (!training.isSignin && training.isDdl) {
      buttonColor = Colors.grey;
      buttonText = '报名截止';
    } else {
      buttonColor = Colors.grey;
      buttonText = '已报名';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 1 ? '比赛详情' : '训练详情',
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
      body: FutureBuilder(
        future: logic.initializeData(type, training.trainingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载数据时出错'));
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEventInfo(training, buttonColor, buttonText),
                  _buildParticipantsList(state.trainingDetailList),
                  _buildBoatArrangement(state.trainingDetailList),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEventInfo(Training training, Color buttonColor, String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.asset(
                            training.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            training.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '报名人数：${training.memberCount}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '${training.location} - ${training.date}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for button press
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList(List<TrainingDetail> trainingDetailList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '已报名人员',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: trainingDetailList.map((detail) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(detail.userSRC),
                      ),
                      SizedBox(height: 5),
                      Text(detail.userName),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoatArrangement(List<TrainingDetail> trainingDetailList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '组艇情况',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              trainingDetailList.isEmpty?Text("暂无组艇情况"):Table(
                border: TableBorder.all(color: Colors.grey),
                children: _buildTableRows(trainingDetailList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows(List<TrainingDetail> trainingList) {
    Map<int, List<TrainingDetail>> typeMap = {};
    for (var training in trainingList) {
      if (!typeMap.containsKey(training.type)) {
        typeMap[training.type] = [];
      }
      typeMap[training.type]!.add(training);
    }

    Map<int, String> typeNames = {
      1: 'M1',
      2: 'M2',
      3: 'M4',
      4: 'M6',
      5: 'M8',
      6: 'Mn'
    };

    int maxLength = 0;
    for (var typeList in typeMap.values) {
      if (typeList.length > maxLength) {
        maxLength = typeList.length;
      }
    }

    List<TableRow> rows = [];
    List<Widget> firstRowCells = [];
    for (var type in typeMap.keys) {
      firstRowCells.add(
        Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              typeNames[type] ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    rows.add(TableRow(children: firstRowCells));

    for (int i = 0; i < maxLength; i++) {
      List<Widget> cells = [];
      for (var typeList in typeMap.values) {
        if (i < typeList.length) {
          cells.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(typeList[i].userName),
            ),
          );
        } else {
          cells.add(Container());
        }
      }
      rows.add(TableRow(children: cells));
    }

    return rows;
  }
}
