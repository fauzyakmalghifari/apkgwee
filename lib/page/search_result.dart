import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search: $keyword"),
      ),
      body: Center(
        child: Text(
          "Result for \"$keyword\"",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
