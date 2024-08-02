import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ouabootcamp/Screens/note_home_page.dart';
import 'package:ouabootcamp/main.dart';
import '../Screens/home_screen.dart'; // Varsayılan olarak eklenmiş bir yer adı.
import '../Auth/google_sign_in_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Signed in: ${userCredential.user!.uid}');

      // Kullanıcı bilgilerini al
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      currentName = userDoc['name'];
      currentUserName = userDoc['username'];
      currentMail = userDoc['email'];

      /*
      // Bilgileri yazdır
      print(currentName);
      print(currentUserName);
      print(currentMail);
      */
      if (mounted) {
        // HomeScreen'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  NoteHomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Login failed: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Login failed. Please check your email and password.';
        });
      }
    }
  }

  void _loginWithGoogle() async {
    final googleSignInProvider = GoogleSignInProvider();
    final user = await googleSignInProvider.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoteHomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Google login failed. Please try again.';
      });
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _login,
                //icon: const FaIcon(FontAwesomeIcons.paperPlane, color: Colors.black),
                label: const Text('Giriş Yap'),

              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                label: const Text('Google ile Giriş Yap'),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.red, // Google rengi
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _navigateToRegister(context),
                child: const Text('Kayıt Ol'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Registered user: ${userCredential.user!.uid}');
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
      });

      setState(() {
        _errorMessage = 'Registration successful!';
      });
    } on FirebaseAuthException catch(e) {
      print('Registration failed: $e');
      setState(() {
        _errorMessage = 'Registration failed: $e';
      });
    }
  }
  void _registerWithGoogle() async {
    final googleSignInProvider = GoogleSignInProvider();
    final user = await googleSignInProvider.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoteHomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Google login failed. Please try again.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Kayıt Ol'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _registerWithGoogle,
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
              label: const Text('Google ile Devam Et'),
              style: ElevatedButton.styleFrom(
                //primary: Colors.red, // Google rengi
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: _errorMessage == 'Registration successful!' ? Colors.green : Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
