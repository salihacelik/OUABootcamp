import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Başlangıç Ekranı'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToLogin(context),
          child: Text('Not Tutmaya Başla'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Burada giriş işlemlerini gerçekleştirebilirsiniz
    print('Username: $username, Password: $password');
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _navigateToRegister,
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Burada kayıt işlemlerini gerçekleştirebilirsiniz
    print('First Name: $firstName, Last Name: $lastName, Username: $username, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Soyad'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
