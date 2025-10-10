/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:car_route_app/network/api/direction/api_call_get_direction.dart';
import 'package:car_route_app/network/configuration/configuration_network.dart';
import 'package:car_route_app/network/repository/route/route_repository.dart';
import 'package:car_route_app/utilities/app_color.dart';
import 'package:car_route_app/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as lat_long;

import '../../bloc/location/location_bloc.dart';
import '../../bloc/route/route_bloc.dart';
import '../../network/api/direction/i_api_call_get_direction.dart';
import '../../network/repository/route/i_route_repository.dart';
import '../../use_case/use_case_location_point.dart';
import '../../use_case/use_case_route_details.dart';
import '../../utilities/app_constant.dart';

class ScreenMap extends StatefulWidget {
  const ScreenMap({super.key});

  @override
  State<ScreenMap> createState() => _MapScreenState();
}

class _MapScreenState extends State<ScreenMap> {
  final MapController _mapController = MapController();
  List<Marker> markers = [];
  List<Polyline> polyLines = [];

  late final LocationBloc _locationBloc;
  late final RouteBloc _routeBloc;

  bool isShowInstruction = true;

  @override
  void initState() {
    super.initState();
    ConfigurationNetwork network = ConfigurationNetwork();
    IApiCallGetDirection apiCallGetDirection = ApiCallGetDirection(
      network: network,
    );
    IRouteRepository routeRepository = RouteRepository(
      apiCallGetDirection: apiCallGetDirection,
    );

    _locationBloc = LocationBloc();
    _routeBloc = RouteBloc(routeRepository: routeRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _locationBloc),
        BlocProvider.value(value: _routeBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppText.title),
          actions: [
            SizedBox(
              height: 30,
              child: TextButton(
                onPressed: _reset,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColor.colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                child: Text(AppText.reset),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              MultiBlocListener(
                listeners: [
                  BlocListener<LocationBloc, LocationState>(
                    listener: (context, state) {
                      if (state is LocationOriginSelected) {
                        _updateMarkers(state.origin);
                      } else if (state is LocationDestinationSelected) {
                        _updateMarkers(state.destination, origin: state.origin);
                        // Dispatch event to fetch route
                        _routeBloc.add(
                          RouteFetchEvent(
                            origin: state.origin.latLng,
                            destination: state.destination.latLng,
                          ),
                        );
                      }
                    },
                  ),
                  BlocListener<RouteBloc, RouteState>(
                    listener: (context, state) {
                      setState(() {
                        isShowInstruction = true;
                      });

                      if (state is RouteLoading) {
                        _showLoading();
                      } else if (state is RouteLoaded) {
                        _updatePolyLines(state.route);
                      } else if (state is RouteError) {
                        setState(() {
                          isShowInstruction = false;
                        });

                        _showError(state.message);
                      }
                    },
                  ),
                ],
                child: BlocBuilder<RouteBloc, RouteState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: const lat_long.LatLng(
                              AppConstant.defaultLat,
                              AppConstant.defaultLong,
                            ),
                            // Default: SF
                            initialZoom: AppConstant.initialZoom,
                            onTap: _onMapTap,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: AppConstant.osmTileUrl,
                              subdomains: AppConstant.subdomains,
                            ),
                            MarkerLayer(markers: markers),
                            PolylineLayer(polylines: polyLines),
                          ],
                        ),
                        if (state is RouteLoaded) _buildRouteInfo(state.route),
                      ],
                    );
                  },
                ),
              ),
              // Instructions overlay
              isShowInstruction ? _buildInstructions() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapTap(TapPosition tapPosition, lat_long.LatLng point) {
    _locationBloc.add(LocationTappedEvent(position: point));
  }

  void _updateMarkers(
    UseCaseLocationPoint point, {
    UseCaseLocationPoint? origin,
  }) {
    setState(() {
      markers.clear();
      if (origin != null) {
        markers.add(
          Marker(
            point: origin.latLng,
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_pin,
              color: Colors.green,
              size: 40,
            ),
          ),
        );
      }
      // Add current point marker
      final icon = Icon(
        Icons.location_pin,
        color:
            point.pointName == AppConstant.origin ? Colors.green : Colors.red,
        size: 40,
      );
      markers.add(
        Marker(point: point.latLng, width: 40, height: 40, child: icon),
      );
    });
  }

  void _updatePolyLines(UseCaseRouteDetails route) {
    setState(() {
      polyLines.clear(); // Clear previous
      polyLines.add(
        Polyline(
          points: route.polylinePoints,
          color: AppColor.colorLine,
          strokeWidth: 2,
        ),
      );
    });

    // Animate map to fit route
    _animateToRoute(route.polylinePoints);
  }

  void _animateToRoute(List<lat_long.LatLng> points) {
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points); // Use fromPoints
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  void _showLoading() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppText.fetchingRouteDot)));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildInstructions() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        String instruction = AppText.tapOnMapToSelectOrigin;
        if (state is LocationOriginSelected) {
          instruction = AppText.tapOnMapToSelectDestination;
        } else if (state is LocationDestinationSelected) {
          instruction = AppText.routeDisplayed;
        }
        return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRouteInfo(UseCaseRouteDetails route) {
    if (route.polylinePoints.isEmpty) return const SizedBox.shrink();
    return Positioned(
      bottom: 100, // Above instructions
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          children: [
            _resultText(
              option: AppText.distanceColon,
              result: "${route.distanceInKm.toStringAsFixed(2)} km",
            ),
            _resultText(
              option: AppText.timeColon,
              result: "${route.durationInMinutes} minute",
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultText({required String option, required String result}) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(text: option, style: Theme.of(context).textTheme.bodyLarge),

          TextSpan(text: result, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      markers.clear();
      polyLines.clear();
    });
    _locationBloc.add(LocationResetEvent());
    _routeBloc.add(RouteClearEvent());
    _mapController.move(
      const lat_long.LatLng(AppConstant.defaultLat, AppConstant.defaultLong),
      AppConstant.initialZoom,
    ); // Reset view
  }

  @override
  void dispose() {
    _locationBloc.close();
    _routeBloc.close();
    super.dispose();
  }
}
