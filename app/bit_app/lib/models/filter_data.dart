// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:bit_app/models/server_response.dart';
import 'package:bit_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';

enum PossibleOrders { ASC, DESC }

enum FilterFieldsTypes { BOOLEAN, STRING, DATE, NUMBER, OPTION }

class OrderField {
  String displayName;
  String APIName;
  PossibleOrders value;
  bool enabled;

  OrderField({
    required this.displayName,
    required this.value,
    required this.APIName,
    this.enabled = false,
  });

  factory OrderField.emptyInstance() {
    return OrderField(displayName: '', value: PossibleOrders.DESC, APIName: '');
  }
  @override
  String toString() {
    return '$displayName (${value.name})';
  }
}

class FilterField {
  String displayName;
  String secondDisplayName; // Used for filters like 'enabled' / 'disable'
  String? hintText;
  String?
      title; // Used when displayName and secondDisplayName are already used like boolean fields
  TextEditingController? textController; // Used on STRING filter types
  String APIName;
  FilterFieldsTypes dataType;
  dynamic value;
  bool enabled;
  List<FilterFieldOptionItem>? options;
  Future<Result<List, SE>> Function()? loadItems;

  // Avoid using default constructor
  FilterField({
    required this.displayName,
    required this.dataType,
    this.value,
    required this.APIName,
    this.textController,
    this.enabled = false,
    this.secondDisplayName = '',
    this.hintText,
    this.options,
    this.loadItems,
    this.title,
  });

  factory FilterField.STRING({
    required String displayName,
    required String APIName,
    String value = '',
    bool enabled = false,
    String? hintText,
    TextEditingController? textController,
  }) {
    textController ??= TextEditingController(text: value);
    return FilterField(
      displayName: displayName,
      dataType: FilterFieldsTypes.STRING,
      APIName: APIName,
      value: value,
      textController: textController,
      enabled: enabled,
      hintText: hintText,
    );
  }

  factory FilterField.BOOLEAN({
    required String displayName,
    required String secondDisplayName,
    required String APIName,
    required String title,
    bool value = false,
    bool enabled = false,
  }) =>
      FilterField(
          displayName: displayName,
          secondDisplayName: secondDisplayName,
          dataType: FilterFieldsTypes.BOOLEAN,
          APIName: APIName,
          enabled: enabled,
          title: title,
          value: value);

  factory FilterField.DATE({
    required String displayName,
    required String APIName,
    DateTime? value,
    bool enabled = false,
    TextEditingController? textController,
  }) {
    textController ??= TextEditingController(text: '');

    return FilterField(
        displayName: displayName,
        dataType: FilterFieldsTypes.DATE,
        APIName: APIName,
        value: value ?? DateTime.now(),
        enabled: enabled,
        textController: textController);
  }

  factory FilterField.OPTION({
    required String APIName,
    required String displayName,
    required List<FilterFieldOptionItem> options,
    bool enabled = false,
    String? hintText,
  }) {
    return FilterField(
      displayName: displayName,
      dataType: FilterFieldsTypes.OPTION,
      APIName: APIName,
      enabled: enabled,
      options: options,
      hintText: hintText,
    );
  }
  @override
  String toString() {
    switch (dataType) {
      case FilterFieldsTypes.BOOLEAN:
        return value ? ' $displayName (Verdadero)' : ' $displayName (Falso)';
      case FilterFieldsTypes.DATE:
        return ' $displayName (${DateFormat('dd/MM/yyyy').format(value as DateTime)})';
      case FilterFieldsTypes.STRING:
        return ' $displayName (${value.toString()})';
      case FilterFieldsTypes.OPTION:
        return ' $displayName';
      default:
        return ' $displayName (${value.toString()})';
    }
  }
}

/// This class is used to build the list of options in an option type filter
class FilterFieldOptionItem {
  final String displayName;
  final String value;

  FilterFieldOptionItem({required this.displayName, required this.value});

  @override
  String toString() {
    return displayName;
  }

  static List<FilterFieldOptionItem> fromList(List<dynamic> list) {
    return list
        .map((i) => FilterFieldOptionItem(
            displayName: i.toString(),
            value: i is String || i is num ? i : i.id))
        .toList();
  }
}

///
class ModuleFilter {
  OrderField? orderField;
  List<FilterField> fields;
  RequestPageInfo requestPageInfo;
  ResponsePageInfo? responsePageInfo =
      ResponsePageInfo(total: 0, page: INITIAL_PAGE, pageSize: ITEMS_PER_PAGE);

  ModuleFilter({
    required this.orderField,
    required this.fields,
    required this.requestPageInfo,
    this.responsePageInfo,
  });

  /// Transforms all its data into query compatible params to be sent to the server
  Map<String, dynamic> toServerQueryParams() {
    Map<String, dynamic> apiFilters = {};
    if (orderField != null) {
      apiFilters['sortField'] = orderField!.APIName;
      apiFilters['sort'] = orderField!.value.name;
    }
    apiFilters['page'] = requestPageInfo.page;
    apiFilters['pageSize'] = requestPageInfo.pageSize;

    for (var field in fields) {
      if (!field.enabled) continue;

      // Ugly fix for this demo
      if (field.APIName == 'squareFootageFrom' ||
          field.APIName == 'squareFootageTo') {
        apiFilters[field.APIName] = double.tryParse(field.value);
        continue;
      }
      apiFilters[field.APIName] = field.value;
    }

    return apiFilters;
  }

  /// Transforms all its data into query compatible params to be used in system navigation
  Map<String, String> toSystemQueryParams() {
    Map<String, String> queryParams = {};
    if (orderField != null) {
      queryParams['sortField'] = orderField!.APIName;
      queryParams['sort'] = orderField!.value.name;
    }
    queryParams['page'] = requestPageInfo.page.toString();
    queryParams['pageSize'] = requestPageInfo.pageSize.toString();

    for (var field in fields) {
      if (field.enabled) {
        queryParams[field.APIName] = field.value.toString();
      }
    }

    return queryParams;
  }

  static ModuleFilter buildFiltersFromQuery(
      {required Map<String, String> queryParams,
      required List<FilterField> moduleFieldFilters,
      required List<OrderField> moduleOrderFilters}) {
    OrderField? validOrderField;
    RequestPageInfo validPageInfo;
    Map<String, dynamic> paginationParams =
        extractPaginationParams(queryParams);

    // Field filters build
    queryParams.forEach((key, value) async {
      for (var ff in moduleFieldFilters) {
        if (ff.APIName == key) {
          switch (ff.dataType) {
            case FilterFieldsTypes.BOOLEAN:
              var convertedValue = bool.tryParse(value, caseSensitive: false);
              if (convertedValue != null) {
                ff.value = convertedValue;
                ff.enabled = true;
              }
              break;

            case FilterFieldsTypes.DATE:
              var convertedValue = DateTime.tryParse(value);
              if (convertedValue != null) {
                ff.value = convertedValue;
                ff.enabled = true;
              }
              break;

            case FilterFieldsTypes.STRING:
              if (value != '') {
                ff.value = value;
                ff.textController = TextEditingController(text: value);
                ff.enabled = true;
              }
              break;
            case FilterFieldsTypes.OPTION:
              ff.value = value;
              ff.enabled = true;

              break;
            default:
              throw Exception('No valid data type found');
          }
        }
      }
    });

    // Order field build
    for (var orderField in moduleOrderFilters) {
      if (orderField.APIName == paginationParams['sortfield']) {
        if (validOrderValue(paginationParams['sort'])) {
          validOrderField = OrderField(
              displayName: orderField.displayName,
              value: paginationParams['sort'] == 'ASC'
                  ? PossibleOrders.ASC
                  : PossibleOrders.DESC,
              enabled: true,
              APIName: orderField.APIName);
          break; // Only one order filter is allowed
        }
      }
    }

    // Page info build
    validPageInfo = RequestPageInfo(
      page: paginationParams['page'],
      pageSize: paginationParams['pageSize'],
    );

    return ModuleFilter(
        orderField: validOrderField,
        fields: moduleFieldFilters,
        requestPageInfo: validPageInfo,
        responsePageInfo: ResponsePageInfo(
            total: 0, page: INITIAL_PAGE, pageSize: ITEMS_PER_PAGE));
  }

  static Map<String, dynamic> extractPaginationParams(
      Map<String, String> queryParams) {
    return {
      'sort': queryParams.containsKey('sort') ? queryParams['sort'] : null,
      'sortfield': queryParams.containsKey('sortField')
          ? queryParams['sortField']
          : null,
      'page': queryParams.containsKey('page')
          ? int.parse(queryParams['page']!)
          : INITIAL_PAGE,
      'pageSize': queryParams.containsKey('pageSize')
          ? int.parse(queryParams['pageSize']!)
          : ITEMS_PER_PAGE,
    };
  }

  static bool validOrderValue(String? value) =>
      value?.toUpperCase() == 'ASC' || value?.toUpperCase() == 'DESC';
}
