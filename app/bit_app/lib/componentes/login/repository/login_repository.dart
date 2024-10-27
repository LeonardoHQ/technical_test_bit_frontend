import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/app_logger.dart';
import 'package:bit_app/utils/constants.dart';
import 'package:bit_app/utils/http_client.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:dio/dio.dart';

class LoginRepo {
  static Future<Result<SS<LoguedUserData>, SE>> login(
      {required String identificacion, required String password}) async {
    try {
      Response response = await HttpAuthedClient().post(
          '${BackendEndpoints.authPath}/login',
          data: {'identification': identificacion, 'password': password});

      if (response.statusCode == null || response.statusCode != 200) {
        String? error = response.data['message'];
        throw Exception(error ?? response.statusCode);
      }

      final loguedUser = LoguedUserData.fromJson(response.data);
      AppLogger.log.i('Login successful!');
      return Success(SS(single: loguedUser));
    } on DioException catch (e) {
      AppLogger.log
          .e('Got DIOEXCEPTION ${e.type.name} on login: ${e.toString()}');
      return Error(SE(
          detail:
              'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
    } catch (e) {
      AppLogger.log.e('Error in login: ${e.toString()}');
      return Error(SE(detail: e.toString().split('Exception:').last));
    }
  }
}
