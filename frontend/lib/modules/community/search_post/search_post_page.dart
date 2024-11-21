import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // 显示在搜索栏右侧的操作按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // 清空搜索内容
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 显示在搜索栏左侧的返回按钮
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // 关闭搜索页面，并返回空字符串
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 显示搜索结果页面
    return Center(
      child: Text('搜索结果: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 显示搜索建议页面
    final List<String> suggestions = ['Apple', 'Banana', 'Orange']; // 示例搜索建议
    final List<String> filteredSuggestions = suggestions
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = filteredSuggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion; // 将搜索建议作为搜索内容
            showResults(context); // 显示搜索结果
          },
        );
      },
    );
  }
}
