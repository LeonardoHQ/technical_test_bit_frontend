import 'package:bit_app/models/property_data.dart';

class UserData {
  String uuid;
  String username;
  String name;
  String lastName;
  String email;
  bool enabled;
  DateTime createdAt;
  DateTime? lastLogin;
  List<PropertyData> properties;

  UserData({
    required this.uuid,
    required this.username,
    required this.name,
    required this.lastName,
    required this.email,
    required this.enabled,
    required this.createdAt,
    required this.properties,
    this.lastLogin,
  });

  factory UserData.fromJson(Map<String, dynamic> data) {
    List<PropertyData> properties = [];
    if (data['createdProperties'] != null) {
      for (var propData in data['createdProperties']) {
        properties.add(PropertyData.fromJson(propData));
      }
    }

    return UserData(
      uuid: data['uuid'],
      username: data['username'],
      name: data['name'],
      lastName: data['lastName'],
      email: data['email'],
      enabled: data['enabled'],
      createdAt: DateTime.parse(data['createdAt']),
      lastLogin:
          data['lastLogin'] != null ? DateTime.parse(data['lastLogin']) : null,
      properties: properties,
    );
  }

  factory UserData.emptyInstance() => UserData(
        uuid: '',
        username: '',
        name: '',
        lastName: '',
        email: '',
        enabled: false,
        createdAt: DateTime.now(),
        properties: [],
      );

  @override
  String toString() => '$name $lastName';
}

class LoguedUserData extends UserData {
  String token;

  LoguedUserData({
    required this.token,
    required super.uuid,
    required super.username,
    required super.name,
    required super.lastName,
    required super.email,
    required super.enabled,
    required super.createdAt,
    required super.properties,
    super.lastLogin,
  });

  factory LoguedUserData.emptyInstance() => LoguedUserData(
        token: '',
        uuid: '',
        username: '',
        name: '',
        lastName: '',
        email: '',
        enabled: false,
        createdAt: DateTime.now(),
        properties: [],
      );

  factory LoguedUserData.fromJson(Map<String, dynamic> data) {
    List<PropertyData> properties = [];
    if (data['user']['createdProperties'] != null) {
      for (var propData in data['user']['createdProperties']) {
        properties.add(PropertyData.fromJson(propData));
      }
    }

    return LoguedUserData(
      token: data['token'],
      uuid: data['user']['uuid'],
      username: data['user']['username'],
      name: data['user']['name'],
      lastName: data['user']['lastName'],
      email: data['user']['email'],
      enabled: data['user']['enabled'],
      createdAt: DateTime.parse(data['user']['createdAt']),
      lastLogin: data['user']['lastLogin'] != null
          ? DateTime.parse(data['user']['lastLogin'])
          : null,
      properties: properties,
    );
  }
}
