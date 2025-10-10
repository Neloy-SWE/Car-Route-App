/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class UseCaseRouteDetails extends Equatable {
  final List<lat_long.LatLng> polylinePoints;
  final double distance;
  final double duration;

  const UseCaseRouteDetails({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });

  double get distanceInKm => distance / 1000.0;

  int get durationInMinutes => (duration / 60).round();

  @override
  List<Object> get props => [polylinePoints, distance, duration];
}
