/* 
Created by Neloy on 11 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:mocktail/mocktail.dart';
import 'package:car_route_app/bloc/route/route_bloc.dart';
import 'package:car_route_app/use_case/use_case_route_details.dart';
import 'package:car_route_app/network/repository/route/i_route_repository.dart';

class MockIRouteRepository extends Mock implements IRouteRepository {}

void main() {
  group('RouteBloc', () {
    late RouteBloc bloc;
    late MockIRouteRepository mockRepository;

    setUp(() {
      mockRepository = MockIRouteRepository();
      bloc = RouteBloc(routeRepository: mockRepository);
      registerFallbackValue(UseCaseRouteDetails(polylinePoints: [], distance: 0, duration: 0));  // For anyNamed
    });

    test("initial", () {
      expect(bloc.state, RouteInitial());
    });

    blocTest<RouteBloc, RouteState>(
      "success route load",
      build: () => bloc,
      setUp: () => when(() => mockRepository.getRoute(
        origin: lat_long.LatLng(23.8, 90.4),
        destination: lat_long.LatLng(23.9, 90.5),
      )).thenAnswer((_) async => UseCaseRouteDetails(
        polylinePoints: [lat_long.LatLng(23.8, 90.4), lat_long.LatLng(23.9, 90.5)],
        distance: 5200.0,
        duration: 720.0,
      )),
      act: (bloc) => bloc.add(RouteFetchEvent(
        origin: lat_long.LatLng(23.8, 90.4),
        destination: lat_long.LatLng(23.9, 90.5),
      )),
      expect: () => [
        RouteLoading(),
        isA<RouteLoaded>(),
      ],
      verify: (_) {
        final state = bloc.state as RouteLoaded;
        expect(state.route.polylinePoints.length, 2);
        expect(state.route.distanceInKm, 5.2);
        expect(state.route.durationInMinutes, 12);
      },
    );

    blocTest<RouteBloc, RouteState>(
      "fail route load",
      build: () => bloc,
      setUp: () => when(() => mockRepository.getRoute(
        origin: lat_long.LatLng(23.8, 90.4),
        destination: lat_long.LatLng(23.9, 90.5),
      )).thenThrow(Exception("fail")),
      act: (bloc) => bloc.add(RouteFetchEvent(
        origin: lat_long.LatLng(23.8, 90.4),
        destination: lat_long.LatLng(23.9, 90.5),
      )),
      expect: () => [
        RouteLoading(),
        RouteError("Exception: fail"),
      ],
    );

    blocTest<RouteBloc, RouteState>(
      "reset",
      seed: () =>  RouteLoaded(route: UseCaseRouteDetails(polylinePoints: [], distance: 0, duration: 0)),
      build: () => bloc,
      act: (bloc) => bloc.add(RouteClearEvent()),
      expect: () => [RouteInitial()],
    );

    tearDown(() => bloc.close());
  });
}