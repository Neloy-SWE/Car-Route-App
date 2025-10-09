/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class UseCaseLocationPoint extends Equatable {
  final lat_long.LatLng latLng;

  const UseCaseLocationPoint({required this.latLng});

  @override
  List<Object> get props => [latLng];
}
