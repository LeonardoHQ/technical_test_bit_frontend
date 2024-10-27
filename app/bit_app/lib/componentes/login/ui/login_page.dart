// ignore_for_file: use_build_context_synchronously

import 'package:bit_app/componentes/login/login.dart';
import 'package:bit_app/componentes/property/property.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Login(
          controller: controller,
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 200,
            color: const Color.fromARGB(255, 10, 175, 254),
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: const Center(
                  child: Text(
                "APP BIT",
                style: TextStyle(color: Colors.white, fontSize: 50),
              )),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginUsernameEmailField(controller: controller),
              const SizedBox(height: 20),
              LoginPasswordField(controller: controller),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 300),
          child: ElevatedButton(
              onPressed: () => login(context),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  backgroundColor: const Color.fromARGB(255, 10, 175, 254),
                  fixedSize: const Size(230, 55)),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
        ),
      ],
    );
  }

  void login(BuildContext context) async {
    SE? result = await controller.login();
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.detail),
        backgroundColor: Colors.red,
      ));
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PropertyListPage()));
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // We start from the upper left corner
    path.lineTo(0.0, size.height - 40);

    // Define multiple control points for the wave
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 70);
    var secondEndPoint = Offset(size.width, size.height - 40);

    // Draw the first curve of the wave
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Draw the second curve of the wave
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Draw line from the end of the wave to the upper right corner.
    path.lineTo(size.width, 0);

    // Close the path to complete the form
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
