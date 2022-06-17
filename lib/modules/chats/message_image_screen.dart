import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageImageScreen extends StatelessWidget {
  final String image;

  const MessageImageScreen({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      body: Center(
        child: Image(
          height: double.infinity,
          width: double.infinity,
          image: NetworkImage(image),
        ),
      ),
    );
  }
}
