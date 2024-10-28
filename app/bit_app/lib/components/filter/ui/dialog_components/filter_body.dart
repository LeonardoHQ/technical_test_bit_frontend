// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:bit_app/components/filter/filter.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FilterBody extends StatelessWidget {
  FilterBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<FilterController>(
                id: 'dialogOrderFieldList',
                builder: (fc) => FilterSectionBody(
                    sectionIcon: Icons.height,
                    sectionName: 'Filtros de orden',
                    children: _buildAvailableOrderFields(fc))),
            GetBuilder<FilterController>(
                id: 'dialogFilterFieldList',
                builder: (fc) {
                  return FilterSectionBody(
                    sectionIcon: Icons.filter_list,
                    sectionName: 'Filtros por campos',
                    children: _buildAvailableFilterFields(fc),
                  );
                }),
          ]),
    );
  }

  List<Widget> _buildAvailableOrderFields(FilterController fc) {
    List<Widget> availableFields = [];
    final controller = Get.find<FilterController>();
    for (var orderField in fc.availableOrderFilters) {
      availableFields.add(SizedBox(
          height: 80,
          width: 250,
          child: OrderFieldWidget(
            orderField: orderField,
            filterController: controller,
          )));
    }
    return availableFields;
  }

  List<Widget> _buildAvailableFilterFields(FilterController fc) {
    List<Widget> availableFields = [];

    final controller = Get.find<FilterController>();

    for (var aff in fc.availableFieldFilters) {
      switch (aff.dataType) {
        case FilterFieldsTypes.STRING:
          availableFields.add(FilterTextField(
            fieldFilter: aff,
            filterController: controller,
          ));
          break;
        case FilterFieldsTypes.DATE:
          availableFields.add(
              FilterDateField(fieldFilter: aff, filterController: controller));
          break;
        case FilterFieldsTypes.BOOLEAN:
          availableFields.add(FilterBooleanField(
              fieldFilter: aff, filterController: controller));
          break;
        case FilterFieldsTypes.OPTION:
          availableFields.add(FilterSelectField(
              fieldFilter: aff, filterController: controller));
          break;
        default:
          throw Exception(
              'FilterBody._buildAvailableFilterFields: Unknown filter type ${aff.dataType}');
      }
    }
    return availableFields;
  }
}

class FilterSectionBody extends StatelessWidget {
  final String sectionName;
  final IconData sectionIcon;
  final List<Widget> children;

  const FilterSectionBody(
      {super.key,
      required this.sectionName,
      required this.sectionIcon,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        children: [
          Icon(
            sectionIcon,
            size: 30,
            color: const Color.fromARGB(255, 10, 175, 254),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              sectionName,
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 10, 175, 254)),
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Wrap(spacing: 15, runSpacing: 5, children: children),
      )
    ]);
  }
}
