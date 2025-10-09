/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationOriginSelected extends LocationState {
  final UseCaseLocationPoint origin;

  const LocationOriginSelected({required this.origin});

  @override
  List<Object> get props => [origin];
}

class LocationDestinationSelected extends LocationState {
  final UseCaseLocationPoint origin;
  final UseCaseLocationPoint destination;

  const LocationDestinationSelected({
    required this.origin,
    required this.destination,
  });

  @override
  List<Object> get props => [origin, destination];
}
