import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouabootcamp/Screens/add_note_page.dart';


class Note {
  final String id;
  final String text;

  Note({
    required this.id,
    required this.text,
  });
}

class FavoritesPage extends StatefulWidget  {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}
class _FavoritesPageState extends State<FavoritesPage> {
  List<Note> favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteNotes();
  }

  Future<void> _editNote(String noteId, String noteText) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(
          noteId: noteId,
          note: noteText,
        ),
      ),
    );
    _fetchFavoriteNotes();

    setState(() {});
  }

  Future<void> _fetchFavoriteNotes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('written_notes')
        .where('userID', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .get();

    setState(() {
      favoriteNotes = querySnapshot.docs.map((doc) {
        return Note(
          id: doc.id,
          text: doc['note'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoriler'),
      ),
      body: ListView.builder(
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          Note note = favoriteNotes[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                note.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                _editNote(note.id, note.text);
              },
            ),
          );
        },
      ),
    );
  }


}
