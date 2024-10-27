import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  AppLogger._internal();

  factory AppLogger() => _instance;

  static final log = Logger();
}
