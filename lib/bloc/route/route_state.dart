/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final UseCaseRouteDetails route;

  const RouteLoaded({required this.route});

  @override
  List<Object> get props => [route];
}

class RouteError extends RouteState {
  final String message;

  const RouteError(this.message);

  @override
  List<Object> get props => [message];
}
