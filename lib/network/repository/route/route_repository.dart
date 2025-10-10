/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/network/configuration/configuration_api_constant.dart';
import 'package:car_route_app/network/configuration/configuration_exception.dart';
import 'package:car_route_app/network/model/model_direction.dart';
import 'package:car_route_app/network/repository/route/i_route_repository.dart';
import 'package:car_route_app/use_case/use_case_route_details.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart' as lat_long;

import '../../api/direction/i_api_call_get_direction.dart';

class RouteRepository implements IRouteRepository {
  final IApiCallGetDirection apiCallGetDirection;

  RouteRepository({required this.apiCallGetDirection});

  @override
  Future<UseCaseRouteDetails> getRoute({
    required lat_long.LatLng origin,
    required lat_long.LatLng destination,
  }) async {
    try {
      Map<String, dynamic> data = {
        ConfigurationApiConstant.overview: ConfigurationApiConstant.full,
        ConfigurationApiConstant.geometries: ConfigurationApiConstant.polyline,
      };
      ModelDirection direction = await apiCallGetDirection.getDirections(
        origin: origin,
        destination: destination,
        data: data,
      );

      return UseCaseRouteDetails(
        polylinePoints: direction.polylinePoints,
        distance: direction.distance,
        duration: direction.duration,
      );
    } on DioException {
      throw ServerException(ConfigurationApiConstant.checkYourInternet);
    } catch (e) {
      rethrow;
    }
  }
}
