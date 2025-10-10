/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/network/configuration/configuration_api_constant.dart';
import 'package:car_route_app/network/configuration/configuration_network.dart';
import 'package:car_route_app/network/model/model_direction.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart' as lat_long;

import '../../configuration/configuration_exception.dart';
import 'i_api_call_get_direction.dart';

class ApiCallGetDirection implements IApiCallGetDirection {
  final ConfigurationNetwork network;

  ApiCallGetDirection({required this.network});

  @override
  Future<ModelDirection> getDirections({
    required lat_long.LatLng origin,
    required lat_long.LatLng destination,
    required Map<String, dynamic> data,
  }) async {
    final String coordination =
        "${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}";
    Response response = await network.request.get(
      coordination,
      queryParameters: data,
    );

    if (response.statusCode == 200) {
      return ModelDirection.fromJson(response.data);
    } else {
      throw ServerException(ConfigurationApiConstant.carCannotGoThereDirectly);
    }
  }
}
