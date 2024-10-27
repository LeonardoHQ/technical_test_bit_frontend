import 'package:bit_app/models/filter_data.dart';

class BackendEndpoints {
  static const String userPath = '/user';

  static const String authPath = '/auth';

  static const String propertyPath = '/property';
}

const int ITEMS_PER_PAGE = 15;
const int INITIAL_PAGE = 1;

final DEFAULT_ORDER_FILTER = OrderField(
  displayName: 'Creación',
  APIName: 'createdAt',
  value: PossibleOrders.DESC,
);
