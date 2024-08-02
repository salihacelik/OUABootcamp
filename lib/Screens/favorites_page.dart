import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> favoriteNotes;
  final Function(int) onRestore;

  FavoritesPage({required this.favoriteNotes, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoriler'),
      ),
      body: ListView.builder(
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                favoriteNotes[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

            ),
          );
        },
      ),
    );
  }
}
