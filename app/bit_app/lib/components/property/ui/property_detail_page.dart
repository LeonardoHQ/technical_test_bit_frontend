// ignore_for_file: use_build_context_synchronously

import 'package:bit_app/components/property/property.dart';
import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyForm extends StatefulWidget {
  final PropertyData property;
  final bool readOnly;
  final bool editing;
  const PropertyForm(
      {super.key,
      required this.property,
      this.readOnly = false,
      this.editing = false});

  @override
  PropertyFormState createState() => PropertyFormState();
}

class PropertyFormState extends State<PropertyForm> {
  final formKey = GlobalKey<FormState>();
  final PropertyController controller = Get.find<PropertyController>();
  late PropertyFormController formController;

  @override
  void initState() {
    super.initState();

    formController =
        Get.put(PropertyFormController(property: Rx(widget.property)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(setTitle()),
        backgroundColor: const Color.fromARGB(255, 10, 175, 254),
        foregroundColor: Colors.white,
      ),
      body: Form(
          key: formKey,
          child: _PropertyFormBody(
              formController: formController,
              formKey: formKey,
              readOnly: widget.readOnly,
              editing: widget.editing)),
    );
  }

  String setTitle() {
    if (widget.readOnly == true && widget.editing == false) {
      return 'Detalle de Propiedad';
    }

    if (widget.readOnly == false && widget.editing == true) {
      return 'Editar Propiedad';
    }
    return 'Crear Propiedad';
  }
}

class _PropertyFormBody extends StatelessWidget {
  final PropertyFormController formController;
  final GlobalKey<FormState> formKey;
  final bool readOnly;
  final bool editing;
  const _PropertyFormBody(
      {required this.formController,
      required this.formKey,
      required this.readOnly,
      required this.editing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 15,
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: OnlyTextFormField(
                    textController: formController.nameC,
                    readOnly: readOnly,
                    maxLines: 1,
                    hintText: 'Nombre *',
                    inputFormatter: letterInputFormattersNames,
                    validator: (value) => requiredValidation(value)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OnlyTextFormField(
                  textController: formController.addressC,
                  maxLines: 1,
                  readOnly: readOnly,
                  hintText: 'Dirección * ',
                  inputFormatter: letterInputFormattersNames,
                  validator: (value) => requiredValidation(value)),
            ),
            SizedBox(
              width: double.infinity,
              child: OnlyTextFormField(
                  readOnly: readOnly,
                  textController: formController.countryC,
                  maxLines: 1,
                  hintText: 'Pais *',
                  inputFormatter: letterInputFormattersNames,
                  validator: (value) => requiredValidation(value)),
            ),
            SizedBox(
              width: double.infinity,
              child: OnlyTextFormField(
                  textController: formController.cityC,
                  maxLines: 1,
                  hintText: 'Ciudad *',
                  readOnly: readOnly,
                  inputFormatter: letterInputFormattersNames,
                  validator: (value) => requiredValidation(value)),
            ),
            SizedBox(
                width: double.infinity,
                child: OnlyTextFormField(
                    textController: formController.postalCodeC,
                    maxLines: 1,
                    readOnly: readOnly,
                    hintText: 'Código Postal *',
                    inputFormatter: letterInputFormattersNames,
                    validator: (value) => requiredValidation(value))),
            SizedBox(
              width: double.infinity,
              child: OnlyTextFormField(
                  readOnly: readOnly,
                  textController: formController.squareFootageC,
                  maxLines: 1,
                  hintText: 'Metros cuadrados *',
                  inputFormatter: const [],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Este campo debe ser un número';
                    }
                    return null;
                  }),
            ),
            SizedBox(
                width: double.infinity,
                child: CustomDropdownField(
                  readOnly: readOnly,
                  menuMaxHeight: 350,
                  value: (readOnly == true)
                      ? formController.property.value.type
                      : formController.setDefaultDropdownValue(),
                  items: formController.availableHouseTypes,
                  hint: 'Tipo de Propiedad *',
                )),
            const Spacer(),
            Obx(() {
              if (readOnly == true && editing == false) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PropertyForm(
                                  property: formController.property.value,
                                  readOnly: false,
                                  editing: true,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 175, 254),
                    fixedSize: const Size(double.maxFinite, 45),
                  ),
                  child: formController.performingSave.value == true
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ))
                      : const Text(
                          'Editar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                );
              }

              if (readOnly == false && editing == true) {
                return ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      handleEdit(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 175, 254),
                    fixedSize: const Size(double.maxFinite, 45),
                  ),
                  child: formController.performingSave.value == true
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ))
                      : const Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                );
              }

              return ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    handleSave(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 175, 254),
                  fixedSize: const Size(double.maxFinite, 45),
                ),
                child: formController.performingSave.value == true
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ))
                    : const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String? requiredValidation(String? value) =>
      (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null;

  void handleSave(BuildContext context) async {
    if (formController.selectedType == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debe elegir un tipo de propiedad'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    SE? result = await formController.create();
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.detail),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Propiedad creada con éxito"),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pop();
    }
  }

  void handleEdit(BuildContext context) async {
    SE? result = await formController.updateProperty();
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.detail),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Propiedad actualizada con éxito"),
        backgroundColor: Colors.green,
      ));
      Get.to(() => PropertyListPage());
    }
  }
}
