import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mmh/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  static final CameraPosition _kUNT = CameraPosition(
    target: LatLng(33.2120, -97.1491),
    zoom: 14.4746,
  );

  static final CameraPosition _kUnion = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(33.2120, -97.1491),
      tilt: 59.440717697143555,
      zoom: 12);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Meet Halfway!'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Search by City'),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kUNT,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      //     floatingActionButton: FloatingActionButton.extended(
      //       onPressed: _goToTheLake,
      //       label: Text('To the lake!'),
      //      icon: Icon(Icons.directions_boat),
      //   ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 12)),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kUnion));
  }
}
