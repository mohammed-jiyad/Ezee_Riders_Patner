
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.text, required this.date, required this.isSentbyme});
  final String text;
  final DateTime date;
  final bool isSentbyme;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}