import 'package:flutter/material.dart';

final class ErrorFace extends StatelessWidget {
  final String text;

  const ErrorFace({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      color: Colors.black,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
