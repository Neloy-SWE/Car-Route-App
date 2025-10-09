/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

part of 'route_bloc.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class RouteFetchEvent extends RouteEvent {
  final lat_long.LatLng origin;
  final lat_long.LatLng destination;

  const RouteFetchEvent({required this.origin, required this.destination});

  @override
  List<Object> get props => [origin, destination];
}

class RouteClearEvent extends RouteEvent {}
