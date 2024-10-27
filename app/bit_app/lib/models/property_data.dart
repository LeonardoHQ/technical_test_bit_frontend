class PropertyData {
  String id;
  String name;
  String address;
  String country;
  String city;
  String postalCode;
  String type;
  double squareFootage;

  PropertyData({
    required this.id,
    required this.name,
    required this.address,
    required this.country,
    required this.city,
    required this.postalCode,
    required this.type,
    required this.squareFootage,
  });

  factory PropertyData.fromJson(Map<String, dynamic> data) {
    return PropertyData(
      id: data['id'].toString(),
      name: data['name'],
      address: data['address'],
      country: data['country'],
      city: data['city'],
      postalCode: data['postalCode'],
      type: reverseTranslateType(data["type"]),
      squareFootage: data['squareFootage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'country': country,
      'city': city,
      'postalCode': postalCode,
      'type': translateType(),
      'squareFootage': squareFootage,
    };
  }

  String translateType() {
    switch (type) {
      case 'Casa':
        return 'HOUSE';
      case 'Oficina':
        return 'OFFICE';
      case 'Otro':
        return 'OTHER';
      default:
        return '';
    }
  }

  factory PropertyData.emptyInstance() {
    return PropertyData(
      id: '',
      name: '',
      address: '',
      country: '',
      city: '',
      postalCode: '',
      type: '',
      squareFootage: 0,
    );
  }
}

String reverseTranslateType(String type) {
  switch (type) {
    case 'HOUSE':
      return 'Casa';
    case 'OFFICE':
      return 'Oficina';
    case 'OTHER':
      return 'Otro';
    default:
      return '';
  }
}
