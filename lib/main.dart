import 'package:flutter/material.dart';
import 'Auth/auth_screens.dart';

void main() async {

  //await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Başlangıç Ekranı'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToLogin(context),
          child: const Text('Not Tutmaya Başla'),
        ),
      ),
    );
  }

}
