import 'package:flutter_mmh/screens/auth/places_autocomplete.dart';

abstract class BasePlaceRepository {
  Future<List<PlaceAutoComplete>?> getAutoComplete(String searchInput) async {}
}
