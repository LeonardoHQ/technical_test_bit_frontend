import 'package:bit_app/components/property/property.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_result/multiple_result.dart';

class PropertyFormController extends GetxController {
  Rx<PropertyData> property;
  final propertyListController = Get.find<PropertyController>();

  PropertyFormController({required this.property});

  var repo = PropertyRepository();

  var performingSave = false.obs;

  late TextEditingController nameC = TextEditingController();
  late TextEditingController addressC = TextEditingController();
  late TextEditingController countryC = TextEditingController();
  late TextEditingController cityC = TextEditingController();
  late TextEditingController postalCodeC = TextEditingController();
  late TextEditingController squareFootageC = TextEditingController();
  late String selectedType = '';

  List<String> availableHouseTypes = ['Casa', 'Oficina', 'Otro'];

  @override
  void onInit() {
    super.onInit();
    if (property.value.id == '') {
      setCreationContext();
      return;
    }
    setEditingContext();
  }

  void setCreationContext() {
    nameC = TextEditingController();
    addressC = TextEditingController();
    countryC = TextEditingController();
    cityC = TextEditingController();
    postalCodeC = TextEditingController();
    squareFootageC = TextEditingController();
    selectedType = '';
  }

  void setEditingContext() {
    nameC = TextEditingController(text: property.value.name);
    addressC = TextEditingController(text: property.value.address);
    countryC = TextEditingController(text: property.value.country);
    cityC = TextEditingController(text: property.value.city);
    postalCodeC = TextEditingController(text: property.value.postalCode);
    squareFootageC =
        TextEditingController(text: property.value.squareFootage.toString());
    selectedType = property.value.type;
  }

  Future<SE?> create() async {
    performingSave.value = true;
    SE? error;

    PropertyData property = PropertyData(
      id: '',
      name: nameC.text,
      address: addressC.text,
      country: countryC.text,
      city: cityC.text,
      postalCode: postalCodeC.text,
      squareFootage: double.parse(squareFootageC.text),
      type: selectedType,
    );

    Result<SS<PropertyData>, SE> result = await repo.create(property: property);

    result.when((success) {
      propertyListController.addCreatedPropertyToList(success.single!);
    }, (e) {
      error = e;
    });

    performingSave.value = false;

    return error;
  }

  Future<SE?> updateProperty() async {
    performingSave.value = true;
    SE? error;

    PropertyData property = PropertyData(
      id: this.property.value.id,
      name: nameC.text,
      address: addressC.text,
      country: countryC.text,
      city: cityC.text,
      postalCode: postalCodeC.text,
      squareFootage: double.parse(squareFootageC.text),
      type: selectedType,
    );

    Result<SS<PropertyData>, SE> result = await repo.update(property: property);

    result.when((success) {
      propertyListController.replacePropertyInList(success.single!);
    }, (e) {
      error = e;
    });

    performingSave.value = false;

    return error;
  }

  String? setDefaultDropdownValue() {
    if (property.value.id == '') {
      return null;
    }
    return translateType(property.value.type);
  }

  String translateType(String type) {
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

  void selectType(String? value) {
    selectedType = value!;
    update(['dropDownBuilder']);
  }
}
