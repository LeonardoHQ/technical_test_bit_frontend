import 'package:bit_app/utils/http_client.dart';
import 'package:flutter/material.dart';

class LogedAccount extends StatelessWidget {
  final bool dense;
  final bool invertedColors;
  const LogedAccount(
      {super.key, this.dense = false, this.invertedColors = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: SizedBox(
            width: dense ? 35 : 50,
            height: dense ? 35 : 50,
            child: Icon(
              Icons.person,
              size: dense ? 35 : 50,
              color: invertedColors
                  ? Colors.white
                  : const Color.fromARGB(255, 37, 161, 219),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              HttpAuthedClient().currentUser.toString(),
              style: TextStyle(
                  color: invertedColors
                      ? Colors.white
                      : const Color.fromARGB(255, 37, 161, 219),
                  fontSize: dense ? 18 : 22),
            ),
          ],
        ),
      ],
    );
  }
}
