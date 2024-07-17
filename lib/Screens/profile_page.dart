import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Ad";
  String surname = "Soyad";
  String email = "email@example.com";
  String profileImage = "https://via.placeholder.com/150"; // Placeholder image

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _surnameController.text = surname;
    _emailController.text = email;
  }

  void _editProfile() {
    setState(() {
      name = _nameController.text;
      surname = _surnameController.text;
      email = _emailController.text;
    });
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
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Soyad'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
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
}

