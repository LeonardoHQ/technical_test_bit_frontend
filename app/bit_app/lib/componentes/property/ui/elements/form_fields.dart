import 'package:bit_app/componentes/property/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnlyTextFormField extends StatelessWidget {
  OnlyTextFormField({
    super.key,
    required this.textController,
    required this.inputFormatter,
    required this.validator,
    this.readOnly = false,
    this.maxLength,
    this.icon,
    this.hintText,
    this.maxLines,
  });

  final TextEditingController textController;
  List<TextInputFormatter> inputFormatter = [];
  final bool readOnly;
  final int? maxLength;
  final String? Function(String?) validator;
  final Widget? icon;
  final String? hintText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 150,
          child: TextFormField(
            maxLength: maxLength,
            readOnly: readOnly,
            maxLines: maxLines,
            controller: textController,
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              fillColor: (readOnly)
                  ? const Color.fromARGB(255, 221, 221, 221)
                  : const Color.fromARGB(255, 231, 244, 255),
              contentPadding: const EdgeInsets.all(20),
              filled: true,
              labelText: hintText,
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
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
            validator: validator,
          ),
        )
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  CustomDropdownField({
    super.key,
    required this.items,
    required this.hint,
    this.disableHint,
    this.icon,
    this.value,
    this.menuMaxHeight,
    this.readOnly = false,
  });

  final formController = Get.find<PropertyFormController>();
  final String hint;
  final String? disableHint;
  final String? value;
  final List<String> items;
  final Widget? icon;
  final double? menuMaxHeight;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertyFormController>(
        id: "dropDownBuilder",
        builder: (controller) {
          if (readOnly == true) {
            return LimitedBox(
              maxWidth: 150,
              child: TextFormField(
                initialValue: value,
                readOnly: readOnly,
                decoration: InputDecoration(
                  fillColor: (readOnly)
                      ? const Color.fromARGB(255, 221, 221, 221)
                      : const Color.fromARGB(255, 231, 244, 255),
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  labelText: 'Tipo de propiedad',
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
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color: const Color.fromARGB(255, 54, 158, 244),
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  focusColor: const Color.fromARGB(255, 231, 244, 255),
                  hint: Text(
                    hint,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128)),
                  ),
                  disabledHint: disableHint != null ? Text(disableHint!) : null,
                  menuMaxHeight: menuMaxHeight,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectType(value);
                      return;
                    }
                  },
                  items: controller.availableHouseTypes
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          ))
                      .toList(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: items.isEmpty
                        ? null
                        : const Color.fromARGB(255, 37, 161, 219),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  value: controller.selectedType == ''
                      ? null
                      : controller.selectedType,
                ),
              ),
            ),
          );
        });
  }
}
