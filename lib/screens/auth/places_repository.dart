import 'package:flutter_mmh/screens/auth/base_place_repo.dart';
import 'package:flutter_mmh/screens/auth/places_autocomplete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesRepository extends BasePlaceRepository {
  final String key = 'AIzaSyA2jzyvRjy0lDKmenj7xI94wAWPMo4hO_E';
  final String types = 'geocode';

  Future<List<PlaceAutoComplete>> getAutoComplete(String searchInput) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['predictions'] as List;

    return results.map((place) => PlaceAutoComplete.fromJson(place)).toList();
  }
}
