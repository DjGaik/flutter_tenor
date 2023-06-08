import 'package:flutter/material.dart';

class SingleGifCard extends StatelessWidget {
  final String imageUrl;

  const SingleGifCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      appBar: AppBar(
        title: const Text('Tenor картинка'),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
