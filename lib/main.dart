import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ouabootcamp/Auth/auth_screens.dart';
import 'package:ouabootcamp/Screens/home_screen.dart';
import 'package:ouabootcamp/screens/add_note_page.dart';
import 'screens/note_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var currentName = null;
var currentUserName = null;
var currentMail = null;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  Future<Map<String, String>> _getUserDetails(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return {
      'name': userDoc['name'],
      'username': userDoc['username'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          currentMail = snapshot.data!.email!;

          return FutureBuilder<Map<String, String>>(
            future: _getUserDetails(snapshot.data!.uid),
            builder: (context, userDetailsSnapshot) {
              if (userDetailsSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (userDetailsSnapshot.hasData) {
                currentName = userDetailsSnapshot.data!['name']!;
                currentUserName = userDetailsSnapshot.data!['username']!;
                return NoteHomePage();
              } else {
                return const LoginScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
