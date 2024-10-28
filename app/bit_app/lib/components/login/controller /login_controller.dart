import 'package:bit_app/components/login/login.dart';
import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/http_client.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginController extends GetxController {
  final identificationController = TextEditingController();
  final passController = TextEditingController();

  RxBool showPassword = true.obs;
  Future<SE?> login() async {
    SE? serverError;
    Result<SS<LoguedUserData>, SE> result = await LoginRepo.login(
        identificacion: identificationController.text,
        password: passController.text);

    result.when((success) {
      HttpAuthedClient().setCurrentUser = success.single!;
      HttpAuthedClient().setAuthCredentials(success.single!.token);
    }, (error) => serverError = error);
    return serverError;
  }

  void switchShowPass() {
    showPassword.value = !showPassword.value;
  }

  Future<void> logout() async {}
  //   TAuthedClient().setAuthCredentials('');
  //   TAuthedClient().clearCurrentUser();

  //   final storage = SecureStorageService();
  //   await storage.deleteAll();
  // }

  // Future<void> storeUserCredentials() async {
  //   final token = TAuthedClient().currentUser.token;
  //   final storage = SecureStorageService();

  //   final data = TAuthedClient().currentUser.toJson();

  //   if (token != '') {
  //     await storage.write(
  //       'sessionData',
  //       jsonEncode(data),
  //     );
  //   }
  // }
}
