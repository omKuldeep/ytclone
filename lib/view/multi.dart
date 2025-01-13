import 'package:flutter/material.dart';

class MultiSelectListView extends StatefulWidget {
  const MultiSelectListView({super.key});

  @override
  _MultiSelectListViewState createState() => _MultiSelectListViewState();
}

class _MultiSelectListViewState extends State<MultiSelectListView> {
  List<String> emails = List.generate(20, (index) => "Email $index");
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Selection ListView (Gmail Style)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                emails.removeWhere(
                        (email) => selectedIndexes.contains(emails.indexOf(email)));
                selectedIndexes.clear();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          final email = emails[index];
          return ListTile(
            title: Text(email),
            onLongPress: () {
              setState(() {
                if (selectedIndexes.contains(index)) {
                  selectedIndexes.remove(index);
                } else {
                  selectedIndexes.add(index);
                }
              });
            },
            selected: selectedIndexes.contains(index),
            selectedTileColor: Colors.blue.withOpacity(0.5),
          );
        },
      ),
    );
  }
}