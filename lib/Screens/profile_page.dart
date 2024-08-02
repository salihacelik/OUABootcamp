import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ouabootcamp/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = currentName;
  String username = currentUserName;
  String email = currentMail;
  String profileImage = "https://via.placeholder.com/150"; // Placeholder image

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        name = userDoc.get('name');
        username = userDoc.get('username');
        email = userDoc.get('email');
        _nameController.text = name;
        _usernameController.text = username;
        _emailController.text = email;
      });
    }
  }

  void _editProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        name = _nameController.text;
        username = _usernameController.text;
        email = _emailController.text;
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
        'username': username,
        'email': email,
      });

      // Update global state if needed
      // e.g., update `currentUserName` and `currentName`
    }
  }

  void _pickImage() async {
    // Implement image picker logic here
    // You can use image_picker package to pick image from gallery or camera
    // For example:
    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     profileImage = pickedFile.path;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'İsim',
            ),
            _buildTextField(
              controller: _usernameController,
              label: 'Kullanıcı Adı',
            ),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              enabled: false,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _editProfile,
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
            enabled: enabled,
          ),
        ),
        if (enabled)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle edit action if needed
            },
          ),
      ],
    );
  }
}
