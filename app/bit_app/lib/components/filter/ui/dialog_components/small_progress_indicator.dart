import 'package:flutter/material.dart';

class SmallProgressIndicator extends StatelessWidget {
  final EdgeInsets padding;
  final Color? color;

  const SmallProgressIndicator({
    super.key,
    this.padding = EdgeInsets.zero,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      ),
    );
  }
}
