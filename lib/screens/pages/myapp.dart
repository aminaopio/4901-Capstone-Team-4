import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../auth/location_services.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  late String _darkMapStyle;
  late String _lightMapStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
    _setMarker(LatLng(33.2075, -97.1526));
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kUNT =
      CameraPosition(target: LatLng(33.2075, -97.1526), zoom: 15);
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addObserver(this);
  //   _loadMapStyles();
  //   _setMarker(LatLng(33.2075, -97.1526));
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('marker'), position: point),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Starting Location',
                        hintStyle:
                            TextStyle(fontSize: 18, color: Colors.grey[500]),
                      ),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Destination',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500]),
                      ),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                var directions = await LocationService().getDirections(
                    _originController.text, _destinationController.text);
                _goToPlace(
                  directions['start_location']['lat'],
                  directions['start_location']['lng'],
                  directions['bounds_ne'],
                  directions['bounds_sw'],
                  directions[
                      'polyline_decoded'], // pass the polyline points to _goToPlace
                );
              },
              icon: Icon(Icons.search),
              color: Colors.grey,
              iconSize: 30,
            ),
          ],
        ),
        Expanded(
          child: GoogleMap(
            padding: EdgeInsets.only(bottom: 25, left: 15),
            compassEnabled: true,
            mapType: MapType.normal,
            markers: _markers,
            polygons: _polygons,
            polylines: _polylines,
            initialCameraPosition: _kUNT,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _setMapStyle();
            },
            onTap: (point) {
              setState(() {
                polygonLatLngs.add(point);
                _setPolygon();
              });
            },
          ),
        ),
      ],
    ));
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
    List<PointLatLng> polylinePoints, // accept polyline points as an argument
  ) async {
    final GoogleMapController controller = await _controller.future;

    // Calculate midpoint between origin and destination
    double midLat = (boundsNe['lat'] + boundsSw['lat']) / 2;
    double midLng = (boundsNe['lng'] + boundsSw['lng']) / 2;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(midLat, midLng), zoom: 12),
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
          northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
        ),
        25,
      ),
    );

    _markers.clear(); // clear previous markers
    _setMarker(LatLng(midLat, midLng));

    _polygons.clear(); // clear previous polygons
    polygonLatLngs = []; // clear polygonLatLngs list

    _polylines.clear(); // clear previous polylines
    if (polylinePoints.isNotEmpty) {
      // add this check to make sure there are polyline points
      _setPolyline(polylinePoints);
    }
  }
}
