import 'package:bit_app/components/login/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const BITApp());
}

class BITApp extends StatelessWidget {
  const BITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BIT APP Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 37, 204, 255)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
