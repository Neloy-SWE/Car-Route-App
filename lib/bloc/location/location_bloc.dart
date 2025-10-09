/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as lat_long;

import '../../view/use_case/use_case_location_point.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationTappedEvent>(_onLocationTapped);
    on<LocationResetEvent>(_onLocationReset);
  }

  void _onLocationTapped(
    LocationTappedEvent event,
    Emitter<LocationState> emit,
  ) {
    final currentState = state;
    if (currentState is LocationInitial) {
      final origin = UseCaseLocationPoint(latLng: event.position);
      emit(LocationOriginSelected(origin: origin));
    } else if (currentState is LocationOriginSelected) {
      final destination = UseCaseLocationPoint(latLng: event.position);
      emit(
        LocationDestinationSelected(
          origin: currentState.origin,
          destination: destination,
        ),
      );
    }
  }

  void _onLocationReset(LocationResetEvent event, Emitter<LocationState> emit) {
    emit(LocationInitial());
  }
}
