import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final String? note;

  AddNotePage({this.note});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note);
  }

  void _saveNote() {
    String noteText = _noteController.text;
    if (noteText.isNotEmpty) {
      Navigator.pop(context, noteText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_noteController.text.isNotEmpty) {
          bool? result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Kaydet?'),
              content: Text('Notunuzu kaydetmek ister misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('İptal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Kaydet'),
                ),
              ],
            ),
          );
          if (result == true) {
            _saveNote();
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Not Ekle'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveNote,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _noteController,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: 'Notunuzu buraya yazın...',
            ),
          ),
        ),
      ),
    );
  }
}
