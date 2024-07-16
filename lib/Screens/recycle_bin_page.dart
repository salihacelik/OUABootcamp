import 'package:flutter/material.dart';

class RecycleBinPage extends StatelessWidget {
  final List<String> recycleBinNotes;
  final Function(int) onRestore;

  RecycleBinPage({required this.recycleBinNotes, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geri Dönüşüm Kutusu'),
      ),
      body: ListView.builder(
        itemCount: recycleBinNotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                recycleBinNotes[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Geri Getir?'),
                    content: Text('Bu notu geri getirmek istiyor musunuz?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onRestore(index);
                        },
                        child: Text('Geri Getir'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
