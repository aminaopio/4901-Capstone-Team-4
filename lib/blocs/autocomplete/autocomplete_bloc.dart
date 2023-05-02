import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/auth/places_autocomplete.dart';
import '../../screens/auth/places_repository.dart';

part 'autocomplete_state.dart';
part 'autcomplete_event.dart';

class AutoCompleteBloc extends Bloc<AutoCompleteEvent, AutoCompleteState> {
  final PlacesRepository _placesRepository;
  StreamSubscription? _placesSubscription;

  AutoCompleteBloc({required PlacesRepository placesRepository})
      : _placesRepository = placesRepository,
        super(AutoCompleteLoading());

  // @override
  Stream<AutoCompleteState> mapEventToState(
    AutoCompleteEvent event,
  ) async* {
    if (event is LoadAutoComplete) {
      yield* _mapLoadAutoCompleteToState(event);
    }
  }

  Stream<AutoCompleteState> _mapLoadAutoCompleteToState(
      LoadAutoComplete event) async* {
    _placesSubscription?.cancel();

    final List<PlaceAutoComplete> autocomplete =
        await _placesRepository.getAutoComplete(event.searchInput);

    yield AutoCompleteLoaded(autocomplete: autocomplete);
  }
}
