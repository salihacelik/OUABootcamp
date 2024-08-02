import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ouabootcamp/Auth/auth_screens.dart';
import 'add_note_page.dart';
import 'recycle_bin_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'favorites_page.dart';
import 'categories_page.dart';

class NoteHomePage extends StatefulWidget {
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<String> notes = [];
  List<String> recycleBinNotes = [];
  List<String> favoriteNotes = [];

  late TextEditingController _noteController;
  String? _editingNoteId;

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage()),
    );
    if (newNote != null) {
      setState(() {
        notes.add(newNote);
      });
    }
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
    setState(() {});
  }

  /*
  Future<void> _editNote(String noteId, String noteText) async {
    setState(() {
      _editingNoteId = noteId;
      _noteController.text = noteText;
    });
  }*/
  /*void _editNote(int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage(note: notes[index])),
    );
    if (editedNote != null) {
      setState(() {
        notes[index] = editedNote;
      });
    }
  }*/
  Future<void> _deleteNote(String noteId) async {
    await FirebaseFirestore.instance.collection('written_notes').doc(noteId).delete();
    print('Not silindi: $noteId');
  }

  Future<void> _toggleFavorite(String noteId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference noteRef = FirebaseFirestore.instance.collection('written_notes').doc(noteId);

    try {
      DocumentSnapshot docSnapshot = await noteRef.get();

      if (docSnapshot.exists) {
        bool isFavorite = docSnapshot.get('isFavorite') ?? false;

        // Favori durumu değiştir
        await noteRef.update({
          'isFavorite': !isFavorite,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Favori durumu güncellendi: ${!isFavorite}');
      } else {
        print('Döküman bulunamadı');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  void _restoreNoteFromBin(int index) {
    setState(() {
      notes.add(recycleBinNotes[index]);
      recycleBinNotes.removeAt(index);
    });
  }
  void _restoreNoteFromFav(int index) {
    setState(() {
      notes.add(favoriteNotes[index]);
      favoriteNotes.removeAt(index);
    });
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notlarım'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menü'),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              title: Text('Notlarım'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Geri Dönüşüm Kutusu'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecycleBinPage(
                      recycleBinNotes: recycleBinNotes,
                      onRestore: _restoreNoteFromBin,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Ayarlar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Favoriler'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage(
                  favoriteNotes: favoriteNotes,
                  onRestore: _restoreNoteFromFav,))
                );
              },
            ),
            ListTile(
              title: Text('Kategoriler'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
            ),
            ListTile(
              title: Text('Çıkış Yap'),
              onTap: () => _signOut(context)
              ,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('written_notes')
            .where('userID', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz notunuz yok.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot noteDoc = snapshot.data!.docs[index];
              String noteId = noteDoc.id;
              String noteText = noteDoc['note'];
              bool isFavorite = noteDoc['isFavorite'];
              //notes.add(noteText);

              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                      title: Text('Sil?'),
                  content: Text('Bu notu silmek istiyor musunuz?'),
                  actions: [
                  TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('İptal'),
                  ),
                  TextButton(
                  onPressed: () {
                  Navigator.pop(context);
                  _deleteNote(noteId);
                  },
                  child: Text('Sil'),
                  ),
                  ],

                  ),);
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(noteText),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        _toggleFavorite(noteId);
                      },
                    ),
                    onTap: () {
                      _editNote(noteId, noteText);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Not Ekle',
        child: Icon(Icons.add),
      ),
    );
  }
}
