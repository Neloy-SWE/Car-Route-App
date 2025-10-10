/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/network/repository/route/i_route_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../use_case/use_case_route_details.dart';

part 'route_event.dart';

part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final IRouteRepository routeRepository;

  RouteBloc({required this.routeRepository}) : super(RouteInitial()) {
    on<RouteFetchEvent>(_onRouteFetch);
    on<RouteClearEvent>(_onRouteClear);
  }

  Future<void> _onRouteFetch(
    RouteFetchEvent event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());
    try {
      final route = await routeRepository.getRoute(
        origin: event.origin,
        destination: event.destination,
      );
      emit(RouteLoaded(route: route));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }

  void _onRouteClear(RouteClearEvent event, Emitter<RouteState> emit) {
    emit(RouteInitial());
  }
}
