import 'dart:ffi';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart';
//DIRECTORIO
import 'package:hypeapp/views/events_supplier/found_event.dart';
import 'package:hypeapp/views/events_supplier/crud_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSupplier extends StatefulWidget {
  _MapSupplier createState() => _MapSupplier();
}

class _MapSupplier extends State<MapSupplier> {
  Location _location = Location(); //Obtener ubicacion
  late LocationData _locationData; //current location

  static const _initialCameraPosition =
      CameraPosition(target: LatLng(21.150281, -86.9036313), zoom: 11.5);

  GoogleMapController? _googleMapController; //controlador

  Marker? _origin;
  Marker? _destination;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _location.getLocation().then((location) {
      _locationData = location;
      print(_locationData.latitude);
      print(_locationData.longitude);
    });

    return Scaffold(
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            Expanded(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) {
                  _googleMapController = controller;
                  setState(() {
                    _origin = Marker(
                      markerId: const MarkerId('Origin'),
                      infoWindow: const InfoWindow(title: 'Destination'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      position: LatLng(21.175645, -86.823129),
                    );
                    _destination = null;
                  });
                },
                markers: {
                  if (_origin != null) _origin!,
                  if (_destination != null) _destination!,
                },
                onLongPress: _addMarker,
              ),
            )
          ])),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('Origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }
}
