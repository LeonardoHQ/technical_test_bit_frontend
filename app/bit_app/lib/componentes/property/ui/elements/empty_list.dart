import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    'Sin resultados con los filtros seleccionados',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 9, 111, 160)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
