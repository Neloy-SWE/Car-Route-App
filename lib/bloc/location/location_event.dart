/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationTappedEvent extends LocationEvent {
  final lat_long.LatLng position;

  const LocationTappedEvent({required this.position});

  @override
  List<Object> get props => [position];
}

class LocationResetEvent extends LocationEvent {}
