/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import '../../../use_case/use_case_route_details.dart';
import 'package:latlong2/latlong.dart' as lat_long;

abstract class IRouteRepository {
  Future<UseCaseRouteDetails> getRoute({
    required lat_long.LatLng origin,
    required lat_long.LatLng destination,
  });
}
