import 'package:bit_app/components/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPasswordField extends StatelessWidget {
  final LoginController controller;

  const LoginPasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Obx(
        () => TextFormField(
          controller: controller.passController,
          autofillHints: const [
            AutofillHints.password,
          ],
          obscureText: controller.showPassword.value,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 231, 244, 255),
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    controller.switchShowPass();
                  },
                  tooltip: (controller.showPassword.isTrue)
                      ? 'Mostrar contraseña'
                      : 'Ocultar constraseña',
                  icon: (controller.showPassword.isTrue)
                      ? const Icon(
                          Icons.remove_red_eye,
                          color: Color.fromARGB(255, 10, 175, 254),
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Color.fromARGB(255, 10, 175, 254),
                        )),
            ),
            filled: true,
            labelText: 'Contraseña',
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(64))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(64))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(64))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(64))),
          ),
          validator: (value) {
            if (value == null || value == '') {
              return 'Ingrese una contraseña válida';
            }
            return null;
          },
        ),
      ),
    );
  }
}
