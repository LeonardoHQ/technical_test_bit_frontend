import 'package:bit_app/models/models.dart';
import 'package:bit_app/utils/app_logger.dart';
import 'package:bit_app/utils/constants.dart';
import 'package:bit_app/utils/http_client.dart';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';

class PropertyRepository {
  Future<Result<SS<PropertyData>, SE>> create(
      {required PropertyData property}) async {
    try {
      Response response = await HttpAuthedClient()
          .client
          .post(BackendEndpoints.propertyPath, data: property.toJson());
      if (response.statusCode == null || response.statusCode != 200) {
        String? error = response.data is Map
            ? response.data['message']
            : response.statusCode.toString();
        throw Exception(error);
      }

      AppLogger.log.i('Success create property ${response.data}');
      return Success(SS(single: PropertyData.fromJson(response.data)));
    } on DioException catch (e) {
      AppLogger.log.e(
          'Got DIOEXCEPTION ${e.type.name} on create property: ${e.toString()}');
      return Error(SE(
          detail:
              'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
    } catch (e) {
      AppLogger.log.e('Error on create property: ${e.toString()}');
      return Error(SE(detail: e.toString().split('Exception:').last));
    }
  }

  Future<Result<SS<PropertyData>, SE>> update(
      {required PropertyData property}) async {
    try {
      Response response = await HttpAuthedClient().client.patch(
          '${BackendEndpoints.propertyPath}/${property.id}',
          data: property.toJson());
      if (response.statusCode == null || response.statusCode != 200) {
        String? error = response.data is Map
            ? response.data['message']
            : response.statusCode.toString();
        throw Exception(error);
      }
      AppLogger.log.i('Success update property ${response.data}');
      return Success(SS(single: PropertyData.fromJson(response.data)));
    } on DioException catch (e) {
      AppLogger.log.e(
          'Got DIOEXCEPTION ${e.type.name} on update property: ${e.toString()}');
      return Error(SE(
          detail:
              'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
    } catch (e) {
      AppLogger.log.e('Error on update property: ${e.toString()}');
      return Error(SE(detail: e.toString().split('Exception:').last));
    }
  }

  Future<Result<SS<void>, SE>> delete({required String id}) async {
    try {
      Response response = await HttpAuthedClient()
          .client
          .delete('${BackendEndpoints.propertyPath}/$id');

      if (response.statusCode == null || response.statusCode != 200) {
        String? error = response.data['message'];
        throw Exception(error ?? response.statusCode);
      }

      return Success(SS(single: null));
    } on DioException catch (e) {
      AppLogger.log.e(
          'Got DIOEXCEPTION ${e.type.name} on delete property: ${e.toString()}');
      return Error(SE(
          detail:
              'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
    } catch (e) {
      return Error(SE(detail: e.toString().split('Exception:').last));
    }
  }

  // Future<Result<SS<AppointmentBase>, SE>> updateAppointmentCancel(
  //     {required String id, required String cancelObservation}) async {
  //   try {
  //     Response response = await HttpAuthedClient().client.patch(
  //         '${BackendEndpoints.propertyPath}/cancel/$id',
  //         data: {'cancelObservations': cancelObservation});
  //     if (response.statusCode == null || response.statusCode != 200) {
  //       String? error = response.data is Map
  //           ? response.data['message']
  //           : response.statusCode.toString();
  //       throw Exception(error);
  //     }
  //     AppLogger.log.i('Success updateAppointmentCancel ${response.data}');
  //     return Success(SS(single: AppointmentBase.fromJson(response.data)));
  //   } on DioException catch (e) {
  //     AppLogger.log.e(
  //         'Got DIOEXCEPTION ${e.type.name} on updateAppointmentCancel: ${e.toString()}');
  //     return Error(SE(
  //         detail:
  //             'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
  //   } catch (e) {
  //     AppLogger.log.e('Error on updateAppointmentCancel: ${e.toString()}');
  //     return Error(SE(detail: e.toString().split('Exception:').last));
  //   }
  // }

  // Future<Result<SS<AppointmentBase>, SE>> getAppointment(
  //     {required String id}) async {
  //   try {
  //     Response response =
  //         await HttpAuthedClient().client.get('${BackendEndpoints.propertyPath}/$id');
  //     if (response.statusCode == null || response.statusCode != 200) {
  //       String? error = response.data is Map
  //           ? response.data['message']
  //           : response.statusCode.toString();
  //       throw Exception(error);
  //     }
  //     AppLogger.log.i('Success getAppointment ${response.data}');
  //     return Success(SS(single: AppointmentBase.fromJson(response.data)));
  //   } on DioException catch (e) {
  //     AppLogger.log.e(
  //         'Got DIOEXCEPTION ${e.type.name} on getAppointment: ${e.toString()}');
  //     return Error(SE(
  //         detail:
  //             'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
  //   } catch (e) {
  //     AppLogger.log.e('Error on getAppointment: ${e.toString()}');
  //     return Error(SE(detail: e.toString().split('Exception:').last));
  //   }
  // }

  Future<Result<SS<PropertyData>, SE>> filter(
      {required ModuleFilter filters}) async {
    try {
      List<PropertyData> properties = [];
      Response response = await HttpAuthedClient().client.get(
          BackendEndpoints.propertyPath,
          queryParameters: filters.toServerQueryParams());
      if (response.statusCode == null || response.statusCode != 200) {
        String? error = response.data is Map
            ? response.data['message']
            : response.statusCode.toString();
        throw Exception(error);
      }

      for (var json in response.data['items']) {
        properties.add(PropertyData.fromJson(json));
      }

      ResponsePageInfo pageInfo =
          ResponsePageInfo(page: 1, total: 10, pageSize: 10);

      // AppLogger.log.i('Success filter properties ${response.data}');

      return Success(SS(multiple: properties, pageInfo: pageInfo));
    } on DioException catch (e) {
      AppLogger.log.e(
          'Got DIOEXCEPTION ${e.type.name} on filter properties: ${e.toString()}');
      return Error(SE(
          detail:
              'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
    } catch (e) {
      AppLogger.log.e('Error on filter properties: ${e.toString()}');
      return Error(SE(detail: e.toString().split('Exception:').last));
    }
  }

  // Future<Result<SS<DateTime>, SE>> getAvailableSchedule(
  //     {required DateTime date, required String subsidiaryId}) async {
  //   try {
  //     List<DateTime> availableSchedules = [];

  //     Response response = await HttpAuthedClient().client.get(
  //         '${BackendEndpoints.propertyPath}/availableSchedules',
  //         queryParameters: {
  //           'subsidiaryId': subsidiaryId,
  //           'appointmentDate': date.toString()
  //         });
  //     if (response.statusCode == null || response.statusCode != 200) {
  //       String? error = response.data is Map
  //           ? response.data['message']
  //           : response.statusCode.toString();
  //       throw Exception(error);
  //     }

  //     for (var date in response.data['items']) {
  //       availableSchedules.add(DateTime.parse(date));
  //     }

  //     AppLogger.log.i('Success getAvailableSchedule ${response.data}');
  //     return Success(SS(multiple: availableSchedules));
  //   } on DioException catch (e) {
  //     AppLogger.log.e(
  //         'Got DIOEXCEPTION ${e.type.name} on getAvailableSchedule: ${e.toString()}');
  //     return Error(SE(
  //         detail:
  //             'Ha ocurrido un error de conexión, tal vez no tengas acceso a internet: ${e.type.name}'));
  //   } catch (e) {
  //     AppLogger.log.e('Error on getAvailableSchedule: ${e.toString()}');
  //     return Error(SE(detail: e.toString().split('Exception:').last));
  //   }
  // }
}
