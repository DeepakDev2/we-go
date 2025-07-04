import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:we_go/resources/location_methods.dart';
import 'package:we_go/resources/room_methods.dart';
// import 'package:we_go/resources/room_methods.dart';
import 'package:we_go/widgets/show_snackbar.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // final Stream<LocationMarkerPosition?> myPositionStream = LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
  final mapController = MapController();

  List friends = [];

  void getFrinds() async {
    friends = await RoomMethods().getMembersList(roomId: widget.roomId);
    setState(() {});
    print(friends);
  }

  @override
  void dispose() {
    _locationController.dispose();
    mapController.dispose();
    super.dispose();
  }

  final Location _location = Location();
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;
  LatLng? _destination;
  List<LatLng> _route = [];

  Future<bool> _checkRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted == PermissionStatus.denied) {
        return false;
      }
    }
    return true;
  }

  Future<void> _initializeLocaion() async {
    if (!await _checkRequestPermission()) return;
    _location.onLocationChanged.listen((data) {
      if (data.latitude != null && data.longitude != null) {
        LocationMethods().updateLocation(
          lat: data.latitude!,
          lng: data.longitude!,
        );

        setState(() {
          _currentLocation = LatLng(data.latitude!, data.longitude!);
          _fetchRoute();
          isLoading = false;
        });
      }
    });
  }

  LatLng? _currentLocation;

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      setState(() {
        mapController.move(_currentLocation!, 15);
      });
    } else {
      showSnackBar(context, "Current location not available");
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) {
      return;
    }

    // if (!context.mounted) return;
    try {
      final url = Uri.parse(
        "http://router.project-osrm.org/route/v1/driving/"
        "${_currentLocation!.longitude},${_currentLocation!.latitude};"
        "${_destination!.longitude},${_destination!.latitude}"
        "?overview=full&geometries=polyline",
      );

      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final geometry = data["routes"][0]["geometry"];
          _decodePolyline(geometry);
        } else {
          if (mounted) {
            showSnackBar(context, "No route found.");
          }
        }
      } else {
        if (!mounted) return;
        showSnackBar(context, "Routing API error: ${res.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "An error occurred: $e");
    }
  }

  void _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);

    setState(() {
      _route =
          result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
    });
  }

  Future<void> _fetchCoordinatePoints(String location) async {
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1",
      );

      final res = await http.get(
        url,
        headers: {
          'User-Agent':
              'WeGo/1.0 (wego@gmail.com)', // Replace with your app info
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lng = double.parse(data[0]['lon']);
          setState(() {
            _destination = LatLng(lat, lng);
          });

          await _fetchRoute();
        } else {
          if (!mounted) return;
          showSnackBar(context, "Location Not Found");
        }
      } else {
        if (!mounted) return;
        showSnackBar(context, "Geocoding API error: ${res.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, "An error occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocaion();
    getFrinds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Choose Members",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Text(friends[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  _currentLocation != null ? _currentLocation! : LatLng(0, 0),
              initialZoom: 1,
              minZoom: 0,
              maxZoom: 19,
            ),
            children: [
              // TileLayer(),
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.deepak.locationtracker',
                maxZoom: 19,
              ),
              CurrentLocationLayer(),
              // CurrentLocationLayer(
              //   style: LocationMarkerStyle(
              //     marker: DefaultLocationMarker(child: Icon(Icons.location_pin)),
              //   ),
              // ),
              if (_destination != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _destination!,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              if (_currentLocation != null &&
                  _destination != null &&
                  _route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(points: _route, strokeWidth: 5, color: Colors.red),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter the location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      final location = _locationController.text.trim();
                      if (location.isNotEmpty) {
                        _fetchCoordinatePoints(location);
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _userCurrentLocation,
        backgroundColor: Colors.blue,
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
