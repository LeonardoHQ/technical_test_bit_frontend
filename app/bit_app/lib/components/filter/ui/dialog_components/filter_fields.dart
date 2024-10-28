// ignore_for_file: must_be_immutable

import 'package:bit_app/components/filter/filter.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const orders = ['Ascendente', 'Descendente'];

class FilterSearchButton extends StatelessWidget {
  final filterController = Get.find<FilterController>();
  FilterSearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        filterController.setSearchBarChips();
        filterController.getModuleEntityWithFilters(context);
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 70, 195, 255),
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20))),
      icon: const Icon(
        size: 25,
        Icons.search,
        color: Colors.white,
      ),
      label: const Text(
        'Filtrar',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class OrderFieldWidget extends StatelessWidget {
  final OrderField orderField;
  final FilterController filterController;

  const OrderFieldWidget(
      {super.key, required this.orderField, required this.filterController});

  @override
  Widget build(BuildContext context) {
    // Im sorry for using GetBuilder THERE IS NO OTHER (nice) WAY OF DOING THIS SHIT
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterFieldTitle(
            title: orderField.displayName, enabled: orderField.enabled),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: orderField.enabled
                    ? const Color.fromARGB(255, 10, 175, 254)
                    : Colors.grey,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15, right: 10, top: 10, bottom: 8),
                fillColor: Colors.white,
                prefixIcon:
                    (orderField.enabled && orderField.APIName != 'createdAt')
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              filterController.unsetDialogSelectedOrderField(
                                  orderField.APIName);
                            },
                          )
                        : null,
                filled: true,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: (orderField.enabled)
                            ? const Color.fromARGB(255, 37, 161, 219)
                            : Colors.grey,
                        width: 0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: (orderField.enabled)
                          ? const Color.fromARGB(255, 37, 161, 219)
                          : Colors.grey,
                      width: 0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              value: orderField.value == PossibleOrders.ASC
                  ? orders.first
                  : orders.last,
              items: _mapInto(orders),
              onChanged: (value) {
                if (value != null) {
                  filterController.setSelectedDialogOrderField(
                      orderField.APIName, value);
                }
              }),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _mapInto(List<String> orders) => orders
      .map(
        (o) => DropdownMenuItem(
          value: o,
          child: Text(
            o,
            style: TextStyle(
                fontSize: 15,
                color: orderField.enabled
                    ? const Color.fromARGB(255, 37, 161, 219)
                    : Colors.grey),
          ),
        ),
      )
      .toList();
}

class FilterTextField extends StatelessWidget {
  final FilterField fieldFilter;
  final FilterController filterController;

  const FilterTextField(
      {super.key, required this.fieldFilter, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterFieldTitle(
              title: fieldFilter.displayName, enabled: fieldFilter.enabled),
          TextField(
            controller: fieldFilter.textController,
            decoration: InputDecoration(
              filled: true,
              suffixIcon: fieldFilter.enabled
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        filterController.unsetDialogSelectedFieldFilter(
                            fieldFilter.APIName);
                      },
                    )
                  : null,
              fillColor: fieldFilter.enabled ? Colors.white : Colors.grey[100],
              contentPadding: const EdgeInsets.all(5),
              hintText: fieldFilter.hintText,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: fieldFilter.enabled
                          ? const Color.fromARGB(255, 10, 175, 254)
                          : Colors.grey,
                      width: 1)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 10, 175, 254), width: 1),
              ),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            onChanged: (value) {
              filterController.setTextDialogFieldFilter(fieldFilter.APIName);
            },
          ),
        ],
      ),
    );
  }
}

class FilterDateField extends StatelessWidget {
  final FilterField fieldFilter;
  final FilterController filterController;

  const FilterDateField(
      {super.key, required this.fieldFilter, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterFieldTitle(
              title: fieldFilter.displayName, enabled: fieldFilter.enabled),
          TextField(
            controller: fieldFilter.textController,
            decoration: InputDecoration(
              suffixIcon: fieldFilter.enabled
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        filterController.unsetDialogSelectedFieldFilter(
                            fieldFilter.APIName);
                      },
                    )
                  : null,
              filled: true,
              fillColor: fieldFilter.enabled ? Colors.white : Colors.grey[100],
              contentPadding: const EdgeInsets.all(5),
              hintText: fieldFilter.hintText,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: fieldFilter.enabled
                          ? const Color.fromARGB(255, 10, 175, 254)
                          : Colors.grey,
                      width: 1)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 10, 175, 254), width: 1),
              ),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            readOnly: true,
            onTap: () async {
              await onDateTap(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> onDateTap(BuildContext context) async {
    final value = await showDatePicker(
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      context: context,
    );
    if (value != null) {
      filterController.setDateDialogFilter(fieldFilter.APIName, value);
    }
  }
}

class FilterBooleanField extends StatelessWidget {
  final FilterField fieldFilter;
  final FilterController filterController;

  const FilterBooleanField(
      {super.key, required this.fieldFilter, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterFieldTitle(
              title: fieldFilter.title ?? 'Estado',
              enabled: fieldFilter.enabled),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    booleanButton(
                        afirmative: true,
                        decoration: activeDecoration,
                        fieldName: fieldFilter.displayName),
                    booleanButton(
                        afirmative: false,
                        decoration: deactiveDecoration,
                        fieldName: fieldFilter.secondDisplayName),
                  ],
                ),
              ),
              if (fieldFilter.enabled)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      filterController
                          .unsetDialogSelectedFieldFilter(fieldFilter.APIName);
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Flexible booleanButton(
          {required BoxDecoration Function() decoration,
          required bool afirmative,
          required String fieldName}) =>
      Flexible(
        child: InkWell(
          onTap: () => filterController.setBooleanDialogFilter(
              fieldFilter.APIName, afirmative ? true : false),
          hoverColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Container(
            height: 46,
            decoration: decoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fieldName,
                  style: TextStyle(
                      color: setTextAndBadgeColor(
                          afirmative, fieldFilter.enabled, fieldFilter.value),
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14),
                  maxLines: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Badge(
                    backgroundColor: setTextAndBadgeColor(
                        afirmative, fieldFilter.enabled, fieldFilter.value),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Color setTextAndBadgeColor(bool afirmative, bool enabled, bool? value) {
    if (value == null) {
      return Colors.grey;
    }

    if (enabled == false) {
      return Colors.grey;
    }

    if (afirmative == true && fieldFilter.value == true) {
      return const Color.fromARGB(255, 1, 219, 82);
    }

    if (afirmative == false && fieldFilter.value == false) {
      return const Color.fromARGB(255, 202, 0, 0);
    }

    return Colors.grey;
  }

  BoxDecoration activeDecoration() => BoxDecoration(
      color: fieldFilter.enabled && fieldFilter.value == true
          ? const Color.fromARGB(255, 216, 255, 222)
          : const Color.fromARGB(255, 216, 255, 222),
      border: Border.all(
          color: fieldFilter.enabled && fieldFilter.value == true
              ? const Color.fromARGB(255, 1, 219, 82)
              : Colors.grey,
          width: 0.5),
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6), topLeft: Radius.circular(6)));

  BoxDecoration deactiveDecoration() => BoxDecoration(
      color: fieldFilter.enabled && fieldFilter.value == false
          ? const Color.fromARGB(255, 255, 242, 242)
          : const Color.fromARGB(255, 216, 255, 222),
      border: Border.all(
          color: fieldFilter.enabled && fieldFilter.value == false
              ? Colors.red
              : Colors.grey,
          width: 0.5),
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(6), topRight: Radius.circular(6)));
}

class FilterSelectField extends StatelessWidget {
  final FilterField fieldFilter;
  final FilterController filterController;

  const FilterSelectField(
      {super.key, required this.fieldFilter, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 320,
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterFieldTitle(
                title: fieldFilter.displayName, enabled: fieldFilter.enabled),
            fieldFilter.options!.isEmpty ||
                    filterController
                            .errorLoadingFilterFieldOptions.value.detail !=
                        '' ||
                    filterController.loadingFilterFieldOptions.value
                ? _buildMockDropdownContainer()
                : DropdownButtonFormField<FilterFieldOptionItem>(
                    items: fieldFilter.options!
                        .map((i) => DropdownMenuItem(
                            value: i, child: Text(i.toString())))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      filterController.setOptionDialogFilterValue(
                          fieldFilter.APIName, v);
                    },
                    padding: EdgeInsets.zero,
                    hint: fieldFilter.hintText != null
                        ? Text(fieldFilter.hintText!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey))
                        : null,
                    value: _setWidgetValue(),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      suffixIcon: fieldFilter.enabled
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                filterController.unsetDialogSelectedFieldFilter(
                                    fieldFilter.APIName);
                              },
                            )
                          : null,
                      filled: true,
                      contentPadding: const EdgeInsets.only(left: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: (fieldFilter.enabled)
                                  ? const Color.fromARGB(255, 37, 161, 219)
                                  : Colors.grey,
                              width: 0.8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (fieldFilter.enabled)
                                ? const Color.fromARGB(255, 37, 161, 219)
                                : Colors.grey,
                            width: 0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockDropdownContainer() {
    return GestureDetector(
      onTap: () async {
        await filterController.loadFilterOptionFieldOptions(fieldFilter);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        height: 50,
        width: 270,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 220,
              padding: const EdgeInsets.all(5.0),
              child: Text(
                _getTextBoxHintText(),
                style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey),
                maxLines: 3,
              ),
            ),
            if (filterController.loadingFilterFieldOptions.isTrue)
              const SmallProgressIndicator(
                padding: EdgeInsets.only(right: 10),
              ),
            if (filterController.loadingFilterFieldOptions.isFalse)
              const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  FilterFieldOptionItem? _setWidgetValue() {
    if (fieldFilter.value == null) return null;
    if (fieldFilter.options!.isEmpty) return null;
    return fieldFilter.options!.firstWhere((i) => i.value == fieldFilter.value);
  }

  String _getTextBoxHintText() {
    if (fieldFilter.options!.isEmpty &&
        filterController.alreadyLoadedFilterFieldOptions.isFalse) {
      return 'Presione para cargar datos';
    }

    if (fieldFilter.options!.isEmpty &&
        filterController.alreadyLoadedFilterFieldOptions.isTrue) {
      return 'No hay opciones disponibles';
    }
    return '';
  }
}

class _FilterFieldTitle extends StatelessWidget {
  final String title;
  final bool enabled;

  const _FilterFieldTitle({required this.title, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        overflow: TextOverflow.ellipsis,
        title,
        style: TextStyle(
            fontSize: 14,
            color: enabled
                ? const Color.fromARGB(255, 10, 175, 254)
                : Colors.grey),
      ),
    );
  }
}
