import 'package:bit_app/componentes/login/login.dart';
import 'package:flutter/material.dart';

class LoginUsernameEmailField extends StatelessWidget {
  final LoginController controller;

  const LoginUsernameEmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: controller.identificationController,
        autofillHints: const [AutofillHints.username, AutofillHints.email],
        decoration: const InputDecoration(
          fillColor: Color.fromARGB(255, 231, 244, 255),
          contentPadding: EdgeInsets.all(20),
          filled: true,
          labelText: 'Email o nombre usuario',
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(64))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(64))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(64))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(64))),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese un email o nombre usuario válido';
          }
          return null;
        },
      ),
    );
  }
}
