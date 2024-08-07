import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ouabootcamp/Auth/auth_screens.dart';
import 'package:ouabootcamp/Screens/note_home_page.dart';


import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToNotes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Ekran'),
        automaticallyImplyLeading: false, // Geri butonunu gizler
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hoşgeldiniz! '),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToNotes(context),
              child: const Text('Notlarım'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
