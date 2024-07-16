import 'package:flutter/material.dart';
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

  void _editNote(int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage(note: notes[index])),
    );
    if (editedNote != null) {
      setState(() {
        notes[index] = editedNote;
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      recycleBinNotes.add(notes[index]);
      notes.removeAt(index);
    });
  }

  void _restoreNoteFromBin(int index) {
    setState(() {
      notes.add(recycleBinNotes[index]);
      recycleBinNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
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
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                notes[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _editNote(index),
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
                          _deleteNote(index);
                        },
                        child: Text('Sil'),
                      ),
                    ],
                  ),
                );
              },
            ),
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
