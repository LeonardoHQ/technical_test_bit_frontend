import 'package:flutter/material.dart';

class FilterHeader extends StatelessWidget {
  final String headerText;
  final IconData headerIcon;
  final Color iconAndTextColor;
  const FilterHeader(
      {super.key,
      required this.headerIcon,
      required this.iconAndTextColor,
      required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: TextStyle(fontSize: 22, color: iconAndTextColor),
    );
  }
}
