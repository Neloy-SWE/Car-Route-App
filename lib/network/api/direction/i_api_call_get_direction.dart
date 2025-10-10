/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:latlong2/latlong.dart' as lat_long;

import '../../model/model_direction.dart';

abstract class IApiCallGetDirection {
  Future<ModelDirection> getDirections({
    required lat_long.LatLng origin,
    required lat_long.LatLng destination,
    required Map<String, dynamic> data,
  });
}
