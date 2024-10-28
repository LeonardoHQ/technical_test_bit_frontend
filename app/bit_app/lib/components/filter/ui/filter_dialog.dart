import 'package:bit_app/components/filter/filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key, required this.filterController});
  final FilterController filterController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      scrollable: true,
      title: Center(
        child: FilterHeader(
          headerText: (filterController.currentModuleName.value != '')
              ? 'Filtrar ${filterController.currentModuleName.value}'
              : 'No hay filtros seleccionados',
          headerIcon: Icons.search,
          iconAndTextColor: const Color.fromARGB(255, 10, 175, 254),
        ),
      ),
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      contentPadding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
      content: SizedBox(
          height: 475,
          width: filterController.availableFieldFilters.length > 3 ? 790 : 565,
          child: Stack(
            children: [
              FilterBody(),
              Obx(() => Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: filterController.errorLoadingFilterFieldOptions
                                  .value.detail ==
                              ''
                          ? 0
                          : 300,
                      height: filterController.errorLoadingFilterFieldOptions
                                  .value.detail ==
                              ''
                          ? 0
                          : 70,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 253, 127, 117),
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: SelectableText(
                          filterController
                              .errorLoadingFilterFieldOptions.value.detail,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ))
            ],
          )),
      actions: [
        FilterSearchButton(),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
