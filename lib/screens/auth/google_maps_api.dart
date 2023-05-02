import 'package:flutter_mmh/screens/auth/places_autocomplete.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GoogleMapsAPI {
  final String key = 'AIzaSyA2jzyvRjy0lDKmenj7xI94wAWPMo4hO_E';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints().decodePolyline(
        json['routes'][0]['overview_polyline']['points'],
      )
    };

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getMidpoint(
      String origin, String destination) async {
    // Get the directions from origin to destination
    final directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
    final directionsResponse = await http.get(Uri.parse(directionsUrl));
    final directionsJson = convert.jsonDecode(directionsResponse.body);

    // Extract the latitude and longitude of the start and end locations
    final startLat =
        directionsJson['routes'][0]['legs'][0]['start_location']['lat'];
    final startLng =
        directionsJson['routes'][0]['legs'][0]['start_location']['lng'];
    final endLat =
        directionsJson['routes'][0]['legs'][0]['end_location']['lat'];
    final endLng =
        directionsJson['routes'][0]['legs'][0]['end_location']['lng'];

    // Calculate the midpoint
    final midpointLat = (startLat + endLat) / 2;
    final midpointLng = (startLng + endLng) / 2;

    // Return the midpoint as a Map
    return {
      'lat': midpointLat,
      'lng': midpointLng,
    };
  }

  Future<List<Map<String, dynamic>>> getNearbyPlaces(
      String keyword, String type, String origin, String destination) async {
    final midpoint = await getMidpoint(origin, destination);
    final lat = midpoint['lat'];
    final lng = midpoint['lng'];

    final radius = 10000; // 10m radius
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&keyword=$keyword&type=$type&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['results'] as List<dynamic>;

    return results.map<Map<String, dynamic>>((place) {
      // Get the photo reference for the first photo (if any)
      var photoReference;
      if (place.containsKey('photos') && place['photos'].isNotEmpty) {
        photoReference = place['photos'][0]['photo_reference'] as String;
      }

      // Build the photo URL
      var photoUrl;
      if (photoReference != null) {
        photoUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
      }

      return {
        'name': place.containsKey('name')
            ? place['name'] as String
            : place['vicinity'] as String,
        'vicinity': place['vicinity'] as String,
        'address': place['vicinity'] as String,
        'types': place['types'] as List<dynamic>,
        'location': place['geometry']['location'] as Map<String, dynamic>,
        'place_id': place['place_id'] as String,
        'rating':
            place.containsKey('rating') ? place['rating'].toDouble() : null,
        'photo_url': photoUrl,
      };
    }).toList();
  }

  Future<String?> getPhotoUrl(Map<String, dynamic> place) async {
    // Get the photo reference for the first photo (if any)
    var photoReference;
    if (place.containsKey('photos') && place['photos'].isNotEmpty) {
      photoReference = place['photos'][0]['photo_reference'] as String;
    }

    // Build the photo URL
    var photoUrl;
    if (photoReference != null) {
      final maxWidth = 400;
      final url =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$key';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        photoUrl = response.request?.url.toString();
      }
    }
    return photoUrl;
  }
}
