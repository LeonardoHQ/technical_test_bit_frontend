import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/app_logger.dart';
import 'package:dio/dio.dart';

const String baseUrl = 'http://149.50.131.189:8000/v1_0';

var options = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  headers: {},
  validateStatus: (status) {
    return true;
  },
);

/// Main authed client. It performs authed requests
/// to the server and maintains the current logued user on memory
class HttpAuthedClient {
  static final HttpAuthedClient _instance = HttpAuthedClient._internal();
  factory HttpAuthedClient() => _instance;
  HttpAuthedClient._internal();

  var client = Dio(options);
  LoguedUserData _currentUser = LoguedUserData.emptyInstance();

  void setAuthCredentials(String token) {
    client.options.headers.addAll({'Authorization': 'Bearer $token'});
    AppLogger.log.i('Auth credentials set');
  }

  Future<Response<T>> post<T>(String url,
      {required Map<String, dynamic> data}) async {
    return await client.post(url, data: data);
  }

  set setCurrentUser(LoguedUserData loguedUser) {
    _currentUser = loguedUser;
    AppLogger.log.i('Current user set');
  }

  void clearCurrentUser() {
    _currentUser = LoguedUserData.emptyInstance();

    AppLogger.log.i('Current user cleared');
  }

  LoguedUserData get currentUser => _currentUser;

  bool isUserLogued() => (currentUser.token == '') ? false : true;
}

/// Will be usefull when the system has public access modules.
/// Main NOT authed client. It performs NOT authed requests to the server
class HttpClient {}
