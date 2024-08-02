import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final String? note;
  final String? noteId;
  AddNotePage({this.note, this.noteId});

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


  Future<void> _saveNote() async {
    String noteText = _noteController.text;
    if (noteText.isNotEmpty) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (widget.noteId == null) {
        // Yeni not ekleme
        await FirebaseFirestore.instance.collection('written_notes').add({
          'note': noteText,
          'userID': userId,
          'timestamp': FieldValue.serverTimestamp(),
          'isFavorite' : false,
        });
        print('Not eklendi: $noteText');
      } else {

        // Mevcut notu güncelleme
        await FirebaseFirestore.instance.collection('written_notes').doc(widget.noteId).update({
          'note': noteText,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Not güncellendi: ${widget.noteId}');
      }

      if(mounted) Navigator.pop(context);
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
            title: Text(widget.noteId == null ? 'Yeni Not' : 'Notu Düzenle'),
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
