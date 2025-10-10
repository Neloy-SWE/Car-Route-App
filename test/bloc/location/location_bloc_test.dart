/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:bloc_test/bloc_test.dart';
import 'package:car_route_app/bloc/location/location_bloc.dart';
import 'package:car_route_app/use_case/use_case_location_point.dart';
import 'package:car_route_app/utilities/app_constant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as lat_long;

void main() {
  group("LocationBloc", () {
    late LocationBloc bloc;

    setUp(() => bloc = LocationBloc());

    test("initial", () {
      expect(bloc.state, LocationInitial());
      // expect(
      //   bloc.state,
      //   LocationOriginSelected(
      //     origin: UseCaseLocationPoint(
      //       latLng: lat_long.LatLng(23.8, 90.4),
      //       pointName: "",
      //     ),
      //   ),
      // ); // checking false answer
    });

    blocTest<LocationBloc, LocationState>(
      "tap for origin",
      build: () => bloc,
      act:
          (bloc) => bloc.add(
            const LocationTappedEvent(position: lat_long.LatLng(23.8, 90.4)),
          ),
      expect: () => [isA<LocationOriginSelected>()],
      verify: (_) {
        final state = bloc.state as LocationOriginSelected;
        expect(state.origin.pointName, AppConstant.origin);
        expect(state.origin.latLng, const lat_long.LatLng(23.8, 90.4));
      },
    );

    blocTest<LocationBloc, LocationState>(
      "tap for destination",
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LocationTappedEvent(position: lat_long.LatLng(23.8, 90.4)),
        );
        bloc.add(
          const LocationTappedEvent(position: lat_long.LatLng(23.9, 90.5)),
        );
      },
      expect:
          () => [
            isA<LocationOriginSelected>(),
            isA<LocationDestinationSelected>(),
          ],
      verify: (_) {
        final state = bloc.state as LocationDestinationSelected;
        expect(state.origin.pointName, AppConstant.origin);
        expect(state.destination.pointName, AppConstant.destination);
        expect(state.destination.latLng, const lat_long.LatLng(23.9, 90.5));
      },
    );

    blocTest<LocationBloc, LocationState>(
      "reset from origin",
      seed:
          () => const LocationOriginSelected(
            origin: UseCaseLocationPoint(
              latLng: lat_long.LatLng(23.8, 90.4),
              pointName: AppConstant.origin,
            ),
          ),
      build: () => bloc,
      act: (bloc) => bloc.add(LocationResetEvent()),
      expect: () => [LocationInitial()],
    );

    blocTest<LocationBloc, LocationState>(
      "reset from destination",
      seed:
          () => const LocationDestinationSelected(
            origin: UseCaseLocationPoint(
              latLng: lat_long.LatLng(23.8, 90.4),
              pointName: AppConstant.origin,
            ),
            destination: UseCaseLocationPoint(
              latLng: lat_long.LatLng(23.9, 90.5),
              pointName: AppConstant.destination,
            ),
          ),
      build: () => bloc,
      act: (bloc) => bloc.add(LocationResetEvent()),
      expect: () => [LocationInitial()],
    );
  });
}
