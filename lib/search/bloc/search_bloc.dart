import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/card_list_tile_view.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._cardsRepository) : super(SearchInitial()) {
    on<SearchRequest>(request);
  }

  final CardsRepository _cardsRepository;
  String lastSearch = '';

  FutureOr<void> request(SearchRequest event, Emitter<SearchState> emit) {
    emit(SearchLoading());
    if(event.searchRequest.isEmpty){
      emit(SearchInitial());
      return null;
    }
    final cards = _cardsRepository.search(event.searchRequest);
    final tiles = <CardListTileView>[];
    lastSearch = event.searchRequest;
    for (final card in cards) {
      tiles.add(
        CardListTileView(
          card: card,
          isSelected: false,
          height: 40,
        ),
      );
    }
    if (tiles.isEmpty) {
      emit(SearchNothingFound());
    }
    else {
      emit(
        SearchSuccess(
          foundCards: tiles,
        ),
      );
    }
  }
}
