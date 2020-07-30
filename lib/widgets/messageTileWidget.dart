import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  MessageTile(this.message);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
