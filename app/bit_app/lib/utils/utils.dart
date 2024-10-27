import 'package:flutter/services.dart';

/// Do not allow number nor spaces on username field
final letterInputFormattersNames = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zá-úÁ-ÚñÑ .,;:¡!¿?"-´]')),
];