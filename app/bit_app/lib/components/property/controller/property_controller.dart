import 'package:bit_app/components/property/property.dart';
import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:multiple_result/multiple_result.dart';

class PropertyController extends GetxController
    with StateMixin<List<PropertyData>> {
  PropertyRepository repo = PropertyRepository();

  final RxBool performingDelete = false.obs;
  final RxBool performingUpdate = false.obs;

  ModuleFilter appointmentFilters = ModuleFilter(
      orderField: OrderField(
          displayName: 'Creación',
          value: PossibleOrders.DESC,
          APIName: 'createdAt'),
      fields: [],
      requestPageInfo:
          RequestPageInfo(page: INITIAL_PAGE, pageSize: ITEMS_PER_PAGE));

  final availableFieldFilters = [
    FilterField.STRING(displayName: 'Pais', APIName: 'country'),
    FilterField.STRING(displayName: 'Ciudad', APIName: 'city'),
    FilterField.STRING(
        displayName: 'Metros² desde', APIName: 'squareFootageFrom'),
    FilterField.STRING(
        displayName: 'Metros² hasta', APIName: 'squareFootageTo'),
    FilterField.OPTION(
      APIName: 'type',
      displayName: 'Tipo de Propiedad',
      hintText: 'Seleccione un tipo',
      options: [
        FilterFieldOptionItem(displayName: 'Casa', value: 'HOUSE'),
        FilterFieldOptionItem(displayName: 'Oficina', value: 'OFFICE'),
        FilterFieldOptionItem(displayName: 'Otro', value: 'OTHER'),
      ],
    )
  ];

  final availableOrderFilters = [
    DEFAULT_ORDER_FILTER,
    OrderField(
        displayName: 'Metros²',
        APIName: 'square_footage',
        value: PossibleOrders.DESC)
  ];

  @override
  void onInit() async {
    super.onInit();

    change([], status: RxStatus.empty());
    await getList();
  }

  bool get isListEmpty => state?.isEmpty ?? true;

  Future<SE?> getList({ModuleFilter? argFilters}) async {
    change(state, status: RxStatus.loading());
    SE? error;

    Result<SS<PropertyData>, SE> result =
        await repo.filter(filters: argFilters ?? appointmentFilters);

    result.when((success) {
      success.multiple.isEmpty
          ? change(success.multiple, status: RxStatus.empty())
          : change(success.multiple, status: RxStatus.success());

      appointmentFilters.responsePageInfo = success.pageInfo!;
    }, (e) {
      error = e;
      change(state, status: RxStatus.error(e.detail));
    });

    return error;
  }

  Future<SE?> deleteProperty({required String id}) async {
    SE? error;
    performingDelete.value = true;

    Result<SS<void>, SE> result = await repo.delete(id: id);

    result.when((success) {
      int index = state!.indexWhere((property) => property.id == id);
      getList();
    }, (e) {
      error = e;
    });
    performingDelete.value = false;
    change(state, status: RxStatus.success());
    return error;
  }

  // Future<SE?> updateAppointmentReceive(String id) async {
  //   SE? error;

  //   performingUpdate.value = true;

  //   Result<SS<AppointmentBase>, SE> result =
  //       await repo.updateAppointmentReceive(appointmentId: id);

  //   result.when((success) {
  //     int index = state!.indexWhere((ap) => ap.id == id);
  //     state!.removeAt(index);
  //     state!.insert(index, success.single!.toListItem());
  //   }, (e) {
  //     error = e;
  //   });

  //   change(state, status: RxStatus.success());
  //   performingUpdate.value = false;

  //   return error;
  // }

  // Future<Result<SS<AppointmentBase>, SE>> getAppointment(String id) async {
  //   return await repo.getAppointment(id: id);
  // }

  // // NOTE: this method is a MetaController candidate
  // Future<AppointmentBase?> searchAppointmentIfExists(String id) async {
  //   AppointmentBase? appointment =
  //       state?.firstWhereOrNull((ap) => ap.id.toString() == id);
  //   if (appointment != null) {
  //     return appointment;
  //   }
  //   var result = await repo.getAppointment(id: id);

  //   result.when((success) {
  //     appointment = success.single!.toListItem();
  //     state!.add(success.single!.toListItem());
  //     change(state, status: RxStatus.success());
  //   }, (e) {});
  //   return appointment;
  // }

  // AppointmentBase? searchAppointmentInList(String id) {
  //   return state?.firstWhere((u) => u.id == id);
  // }

  // Future<Result<SS<ComercialCase?>, SE>> findComercialCase(
  //     {required String customerFullName, required String licensePlate}) async {
  //   initializingMechanicalRevision.value = true;

  //   final result =
  //       await AppointmentInterface.findComercialCaseForMechanicRevision(
  //           customerFullName: customerFullName, licensePlate: licensePlate);

  //   initializingMechanicalRevision.value = false;

  //   return result;
  // }

  void addCreatedPropertyToList(PropertyData property) {
    state!.insert(0, property);
    change(state, status: RxStatus.success());
  }

  void replacePropertyInList(PropertyData property) {
    int foundIndexProp = state!.indexWhere((p) => p.id == property.id);

    state!.removeAt(foundIndexProp);
    state!.insert(foundIndexProp, property);
    change(state, status: RxStatus.success());
  }
}
