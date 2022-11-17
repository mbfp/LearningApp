import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit(this._cardsRepository) : super(AddCardInitial());

  final CardsRepository _cardsRepository;

  Future<void> saveCard(
      String front, String back, String parentId, String icon) async {
    emit(AddCardLoading());
    final newCard = Card(
        id: const Uuid().v4(),
        front: front,
        back: back,
        dateCreated: DateTime.now().toIso8601String(),
        parentSubjectId: parentId,
        askCardsInverted: false,
        typeAnswer: true,
        dateToReview: DateTime.thursday.toString());
    try {
      await _cardsRepository.saveCard(newCard);
      emit(AddCardSuccess());
    } catch (e) {
      emit(
        AddCardFailure(
            errorMessage: 'Card saving failed, while communicating with hive'),
      );
    }
  }
}