// ignore_for_file: non_constant_identifier_names

import 'package:bit_app/components/property/property.dart';
import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterController extends GetxController {
  // Module related things
  final currentModuleName = ''.obs;
  final currentModuleRoute = ''.obs;

  /// The fields that the user manipulates and alters to select the filters
  var userSelectedOrderField = OrderField(
          displayName: 'Creación',
          APIName: 'createdAt',
          value: PossibleOrders.DESC)
      .obs;
  var userSelectedFieldFilters = <FilterField>[].obs;

  /// Module available filters. Used to build UI available filters in the dialog
  var availableFieldFilters = <FilterField>[].obs;
  var availableOrderFilters = <OrderField>[].obs;

  var loadingFilterFieldOptions = false.obs;
  var errorLoadingFilterFieldOptions = SE(detail: '').obs;
  var alreadyLoadedFilterFieldOptions = false.obs;

  FilterController();

  @override
  void onInit() {
    super.onInit();
    clearAll();

    errorLoadingFilterFieldOptions.listen((e) async {
      if (e.detail != '') {
        await Future.delayed(const Duration(seconds: 5));
        errorLoadingFilterFieldOptions.value = SE(detail: '');
      }
    });
  }

  bool isAnyFilterActive() {
    for (var orderField in availableOrderFilters) {
      if (orderField.APIName != DEFAULT_ORDER_FILTER.APIName &&
          orderField.enabled) {
        return true;
      }
    }

    for (var aff in availableFieldFilters) {
      if (aff.enabled) {
        return true;
      }
    }
    return false;
  }

  /// Clears all things related to filters (bar + dialog)
  void clearAll() {
    currentModuleName.value = '';
    currentModuleRoute.value = '';
    userSelectedOrderField = OrderField(
            displayName: 'Creación',
            APIName: 'createdAt',
            value: PossibleOrders.DESC)
        .obs;
    userSelectedFieldFilters.value = [];

    availableFieldFilters.value = [];
    availableOrderFilters.value = [];
    userSelectedOrderField.value = DEFAULT_ORDER_FILTER;
    alreadyLoadedFilterFieldOptions.value = false;
    loadingFilterFieldOptions.value = false;
    errorLoadingFilterFieldOptions.value = SE(detail: '');
  }

  bool showFieldLabel() {
    for (var f in availableFieldFilters) {
      if (f.enabled) {
        return true;
      }
    }
    return false;
  }

  /// Loads UI filters for every module
  void loadModuleFilterDataInDialog(
      {required List<FilterField> moduleFieldFilters,
      required List<OrderField> moduleOrderFilters,
      required String moduleName,
      required String routeName}) {
    clearAll();

    currentModuleName.value = moduleName;
    currentModuleRoute.value = routeName;

    availableFieldFilters.value = moduleFieldFilters;
    availableOrderFilters.value = moduleOrderFilters;

    availableFieldFilters.refresh();
    availableOrderFilters.refresh();
  }

  void setSelectedDialogOrderField(String APIName, String value) {
    for (var aof in availableOrderFilters) {
      if (aof.APIName == APIName) {
        aof.enabled = true;
        aof.value =
            value == 'Ascendente' ? PossibleOrders.ASC : PossibleOrders.DESC;
        continue;
      }
      aof.enabled = false;
    }

    // Only ONE order field is allowed
    update(['dialogOrderFieldList']);
  }

  void setSearchBarChips() {
    // Reset filter fields
    userSelectedFieldFilters.clear();

    // Order filter
    for (var aof in availableOrderFilters) {
      if (aof.enabled) {
        userSelectedOrderField.value = aof;
        break;
      }
    }

    // Field filters
    for (var aff in availableFieldFilters) {
      if (aff.enabled) {
        userSelectedFieldFilters.add(aff);
      }
    }
  }

  // Actually executes the getList with the user's selected filters
  void getModuleEntityWithFilters(BuildContext context) async {
    // if (currentModuleRoute.value == '' || currentModuleName.value == '') {
    //   return;
    // }
    var moduleFilter = ModuleFilter(
        orderField: userSelectedOrderField.value,
        fields: userSelectedFieldFilters,
        requestPageInfo:
            RequestPageInfo(page: INITIAL_PAGE, pageSize: ITEMS_PER_PAGE));
    // getEntityList(argFilters: moduleFilter);
    PropertyController controller = Get.find();
    await controller.getList(argFilters: moduleFilter);
  }

  /// Activates user's interacted text field and disabled not used ones.
  void setTextDialogFieldFilter(String APIName) {
    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName && aff.textController!.text != '') {
        aff.value = aff.textController!.text;
        aff.enabled = true;
        continue;
      }

      if (aff.APIName == APIName && aff.textController!.text == '') {
        aff.enabled = false;
        aff.value = '';
        continue;
      }

      if (aff.dataType == FilterFieldsTypes.STRING &&
          (aff.value == '' || aff.value == null)) {
        aff.enabled = false;
      }
    }
    update(['dialogFilterFieldList']);
  }

  /// Activates user's interacted boolean fields
  void setBooleanDialogFilter(String APIName, bool value) {
    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName) {
        aff.value = value;
        aff.enabled = true;
      }
    }
    update(['dialogFilterFieldList']);
  }

  /// Activates user's interacted select fields
  void setOptionDialogFilterValue(String APIName, FilterFieldOptionItem item) {
    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName) {
        aff.value = item.value;
        aff.enabled = true;
      }
    }
    update(['dialogFilterFieldList']);
  }

  /// Activates user's interacted date fields
  void setDateDialogFilter(String APIName, DateTime value) {
    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName) {
        aff.value = value;
        aff.enabled = true;
        aff.textController!.text = DateFormat('dd/MM/yyyy').format(value);
      }
    }
    update(['dialogFilterFieldList']);
  }

  // unselects order field and sets the default (createdAt)
  void unsetDialogSelectedOrderField(String APIName) {
    for (var aof in availableOrderFilters) {
      if (aof.APIName == APIName) {
        aof.enabled = false;
        continue;
      }

      if (aof.APIName == 'createdAt') {
        aof.enabled = true;
        aof.value = PossibleOrders.DESC;
        continue;
      }
    }
    update(['dialogOrderFieldList']);
  }

  void unsetDialogSelectedFieldFilter(String APIName) {
    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName) {
        aff.enabled = false;

        switch (aff.dataType) {
          case FilterFieldsTypes.STRING:
            aff.value = '';
            aff.textController?.clear();
            break;
          case FilterFieldsTypes.BOOLEAN:
            aff.value = null;
            break;
          case FilterFieldsTypes.DATE:
            aff.value = null;
            aff.textController!.text = '';
            break;
          case FilterFieldsTypes.OPTION:
            aff.value = null;
            break;
          default:
        }
        break;
      }
    }
    update(['dialogFilterFieldList']);
  }

  /// remove items from bar
  void removeItemFromSearchBar(String APIName, BuildContext context) {
    userSelectedFieldFilters.removeWhere((ff) => ff.APIName == APIName);

    for (var aff in availableFieldFilters) {
      if (aff.APIName == APIName) {
        aff.enabled = false;
        aff.value = null; // probbaly breaking things!

        if (aff.textController != null) {
          aff.textController!.text = '';
        }
        update(['dialogFilterFieldList']);
      }
    }

    // Update the entity list with refreshed filters
    getModuleEntityWithFilters(context);
  }

  /// Loads the options for the filter field by executing loadItems() method in
  /// the FilterField passed by parameter
  Future<FilterField> loadFilterOptionFieldOptions(
      FilterField fieldFilter) async {
    loadingFilterFieldOptions.value = true;
    if (fieldFilter.options!.isNotEmpty) return fieldFilter;

    final result = await fieldFilter.loadItems!();

    result.when((success) {
      fieldFilter.options = FilterFieldOptionItem.fromList(success);
    }, (e) {
      errorLoadingFilterFieldOptions.value = e;
    });
    alreadyLoadedFilterFieldOptions.value = true;
    loadingFilterFieldOptions.value = false;

    return fieldFilter;
  }
}

/// Returns a list that contains the current used order field plus the available ones.
List<OrderField> getCurrentUsedAndAvailableFilters(
    List<OrderField> availableFilters, OrderField? selectedFilter) {
  // No selected filter, return the available filters
  // setting createdAt as the default enabled one
  if (selectedFilter == null) {
    for (var f in availableFilters) {
      if (f.APIName == 'createdAt') {
        f.enabled = true;
      }
      f.enabled = false;
    }
    return availableFilters;
  }

  // Selected filter. Make sure is the only one enabled
  final List<OrderField> filters = [];
  selectedFilter.enabled = true;

  for (var af in availableFilters) {
    if (af.APIName == selectedFilter.APIName) {
      filters.add(selectedFilter);
    } else {
      af.enabled = false;
      filters.add(af);
    }
  }
  return filters;
}
