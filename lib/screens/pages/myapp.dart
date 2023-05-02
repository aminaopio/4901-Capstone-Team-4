import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mmh/blocs/autocomplete/autocomplete_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/themes.dart';
import '../auth/google_maps_api.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
  const MapSample({Key? key}) : super(key: key);
}

class MapSampleState extends State<MapSample> {
  late final ThemeMode themeMode;
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;
  final GlobalKey<MapSampleState> _mapKey = GlobalKey();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _setMarker(LatLng(33.2075, -97.1526));
  }

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  // List<Map<String, dynamic>> nearbyPlaces = [];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  bool showUI = false;

  static final CameraPosition _kUNT =
      CameraPosition(target: LatLng(33.2075, -97.1526), zoom: 15);

  @override
  void dispose() {
    _mapController.dispose();
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
    final List<String> types = [
      'Select Place Type',
      'Restaurants',
      'Emergency',
      'Gyms',
      'Shopping',
      'Hospitals',
    ];
    String selectedType = types[0];

    return new Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
                          hintText: 'Location 1',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey[500]),
                        ),
                        onChanged: (value) {
                          print(value);
                          // context
                          //     .read<AutoCompleteBloc>()
                          //     .add(LoadAutoComplete(searchInput: value));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: _destinationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Location 2',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500],
                          ),
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
                  var directions = await GoogleMapsAPI().getDirections(
                    _originController.text,
                    _destinationController.text,
                  );
                  _goToPlace(
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                    directions[
                        'polyline_decoded'], // pass the polyline points to _goToPlace
                  );
                  setState(() {
                    showUI = true;
                  });
                },
                icon: Icon(Icons.search),
                color: Colors.grey,
                iconSize: 30,
              ),
            ],
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return GoogleMap(
                      key: _mapKey,
                      padding: EdgeInsets.only(bottom: 25, left: 15),
                      compassEnabled: false,
                      mapType: MapType.normal,
                      markers: _markers,
                      polygons: _polygons,
                      polylines: _polylines,
                      initialCameraPosition: _kUNT,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _mapController = controller;
                          themeProvider.mapController = controller;
                          _controller.complete(controller);
                          // Set the custom map style based on the current theme
                          controller.setMapStyle(themeProvider.mapStyle);
                        }
                      },
                      onTap: (point) {
                        setState(() {
                          polygonLatLngs.add(point);
                          _setPolygon();
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Visibility(
            visible: showUI,
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedType,
                    items: types.map((String type) {
                      IconData icon;
                      if (type == 'Restaurants') {
                        icon = Icons.restaurant;
                      } else if (type == 'Emergency') {
                        icon = Icons.emergency;
                      } else if (type == 'Gyms') {
                        icon = Icons.sports_gymnastics;
                      } else if (type == 'Shopping') {
                        icon = Icons.shopping_bag;
                      } else if (type == 'Hospitals') {
                        icon = Icons.local_hospital;
                      } else if (type == 'Select Place Type') {
                        icon = Icons.place;
                      } else {
                        icon = Icons.add;
                      }
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Row(
                          children: [
                            Icon(icon),
                            SizedBox(width: 10),
                            Text(type),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: FutureBuilder<List<List<Map<String, dynamic>>>>(
                      future: _getNearbyPlaces([
                        'restaurant',
                        'cafe',
                        'bank',
                        'gym',
                        'shopping_mall',
                        'police',
                        'library',
                        'department_store',
                        'bakery',
                        'hospital',
                      ], _originController.text, _destinationController.text),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<List<Map<String, dynamic>>>>
                              snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final List<List<Map<String, dynamic>>> nearbyPlaces =
                              snapshot.data!;
                          print("Nearby Places: $nearbyPlaces");
                          return Column(
                            children: [
                              KeyedSubtree(
                                key: UniqueKey(),
                                child: Expanded(
                                  child: PageView.builder(
                                    key: UniqueKey(),
                                    controller: _pageController,
                                    itemCount: nearbyPlaces.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final List<Map<String, dynamic>> places =
                                          nearbyPlaces[index];
                                      return KeyedSubtree(
                                        key: UniqueKey(),
                                        child: SizedBox(
                                          height: 200,
                                          child: PageView.builder(
                                            key: UniqueKey(),
                                            itemCount: places.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Map<String, dynamic> place =
                                                  places[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                  width: 220,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child:
                                                              place['photo_url'] !=
                                                                      null
                                                                  ? Image(
                                                                      image: NetworkImage(
                                                                          place[
                                                                              'photo_url']),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : Container(),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  place['name'],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  place['address'] ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Rating: ${place['rating'] ?? ''}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            16,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  SizedBox(width: 32),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            16,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      onPressed: () {
                                        _pageController.nextPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          print(
                              "Snapshot Connection State: ${snapshot.connectionState}");
                          print("Snapshot Has Data: ${snapshot.hasData}");
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Future<List<List<Map<String, dynamic>>>> _getNearbyPlaces(
      List<String> types, String origin, String destination) async {
    try {
      final googleMapsAPI = GoogleMapsAPI();
      final List<List<Map<String, dynamic>>> nearbyPlaces = [];

      for (String type in types) {
        final List<Map<String, dynamic>> places =
            await googleMapsAPI.getNearbyPlaces("", type, origin, destination);
        nearbyPlaces.add(places);
      }

      return nearbyPlaces;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
