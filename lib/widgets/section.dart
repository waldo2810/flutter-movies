import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget children;

  const Section(this.title, this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8, left: 12),
          child: Text(title, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.bold))
        )
      ]
    );
  }
}
