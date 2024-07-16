import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoriler'),
      ),
      body: Center(
        child: Text('Favori notlar burada görünecek'),
      ),
    );
  }
}
