// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subject_overview_selection_bloc.dart';

@immutable
abstract class SubjectOverviewSelectionEvent {}

class SubjectOverviewSelectionToggleSelectMode
    extends SubjectOverviewSelectionEvent {
  bool inSelectMode;
  SubjectOverviewSelectionToggleSelectMode({
    required this.inSelectMode,
  });
}

class SubjectOverviewSelectionChange extends SubjectOverviewSelectionEvent {
  Card card;
  bool addCard;
  SubjectOverviewSelectionChange({
    required this.card,
    required this.addCard,
  });
}

class SubjectOverviewSelectionDeleteSelectedCards
    extends SubjectOverviewSelectionEvent {}