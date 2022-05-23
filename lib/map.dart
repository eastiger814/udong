import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Completer<GoogleMapController> _controller = Completer();
  double _lat = 37.785834;
  double _lng = -122.406417;
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  late CameraPosition _currentPosition;

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  initState() {
    super.initState();
    _currentPosition = CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('app_name.title').tr(),
      ),
      body: Stack(
        children: [
          GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _currentPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              }),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GestureDetector(
                  onTap: _goToCurrentLocation,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.lightBlueAccent,
                    size: 50.0,
                  )),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  _goToCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then((res) async {
      final GoogleMapController controller = await _controller.future;

      final position = CameraPosition(
        target: LatLng(res.latitude ?? _lat, res.longitude ?? _lng),
        zoom: 12,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(position));
      setState(() {
        _lat = res.latitude ?? _lat;
        _lng = res.longitude ?? _lng;
      });
    });
  }
}

//class GeoLocatorService {
//  Future<Position> getLocation() async {
//    Position position =
//    await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//    return position;
//  }
//}
