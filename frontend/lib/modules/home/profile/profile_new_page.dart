/**
 * @description: profile_new_page.dart
 * @author: yangyiqun
 * @date: 3/23/24
 */

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('9:41'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              // Handle more button press
            },
          )
        ],
      ),
      body: ListView(
        children: [
          ProfileHeader(),
          StatisticSection(),
          ActivityList(),
          AchievementSection(),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile_pic.jpg'),
          ),
          SizedBox(height: 8),
          Text(
            '姓名',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Every stroke counts!'),
          Text('回放大学世联行赛艇会'),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              // Handle button press
            },
            child: Text('个人主页'),
          ),
        ],
      ),
    );
  }
}

class StatisticSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticCard(title: '身高', value: '189 cm'),
            StatisticCard(title: '体重', value: '77 kg'),
            StatisticCard(title: '训练次数', value: '27 次'),
            StatisticCard(title: '训练时长', value: '1890 分钟'),
          ],
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;

  const StatisticCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ActivityList extends StatelessWidget {
  // This is a placeholder for actual data
  final List<Map<String, dynamic>> activities = [
    {'date': '23/10/09', 'distance': '1000m', 'time': '42:29.5'},
    // Add more activity entries here
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          var activity = activities[index];
          return ListTile(
            leading: Icon(Icons.directions_boat),
            title: Text(activity['date']),
            subtitle: Text('${activity['distance']} - ${activity['time']}'),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class AchievementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          AchievementBadge(
            imagePath: 'assets/swim_badge.png',
            label: '你可以遮盖五公里的大长腿',
          ),
          // Add more badges here
        ],
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final String imagePath;
  final String label;

  const AchievementBadge({Key? key, required this.imagePath, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagePath, width: 50, height: 50),
        Text(label),
      ],
    );
  }
}
