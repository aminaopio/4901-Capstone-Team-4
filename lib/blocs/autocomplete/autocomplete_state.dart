part of 'autocomplete_bloc.dart';

abstract class AutoCompleteState extends Equatable {
  const AutoCompleteState();

  @override
  List<Object> get props => [];
}

class AutoCompleteLoading extends AutoCompleteState {}

class AutoCompleteLoaded extends AutoCompleteState {
  final List<PlaceAutoComplete> autocomplete;

  const AutoCompleteLoaded({required this.autocomplete});

  @override
  List<Object> get props => [autocomplete];
}

class AutoCompleteError extends AutoCompleteState {}
