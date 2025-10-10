/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:latlong2/latlong.dart' as lat_long;
import 'package:equatable/equatable.dart';

class ModelDirection extends Equatable {
  final List<lat_long.LatLng> polylinePoints;
  final double distance;
  final double duration;

  const ModelDirection({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });

  factory ModelDirection.fromJson(Map<String, dynamic> json) {
    final List<lat_long.LatLng> points = [];
    double distance = 0.0;
    double duration = 0.0;
    if (json['code'] == 'Ok' &&
        json['routes'] != null &&
        json['routes'].isNotEmpty) {
      final route = json['routes'][0];
      final String? encodedPolyline = route['geometry'];
      if (encodedPolyline != null && encodedPolyline.isNotEmpty) {
        points.addAll(decodePolyline(encodedPolyline));
      }
      distance = (route['distance'] ?? 0.0).toDouble();
      duration = (route['duration'] ?? 0.0).toDouble();
    }
    return ModelDirection(
      polylinePoints: points,
      distance: distance,
      duration: duration,
    );
  }

  static List<lat_long.LatLng> decodePolyline(String encoded) {
    List<lat_long.LatLng> points = <lat_long.LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(lat_long.LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  List<Object> get props => [polylinePoints, distance, duration];
}
