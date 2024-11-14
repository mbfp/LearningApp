import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/calendar/domain/entities/streaks.dart';
import 'package:learning_app/features/calendar/domain/entities/time_span.dart';
import 'package:learning_app/features/calendar/domain/helper/date_time_extension.dart';
import 'package:learning_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:learning_app/generated/l10n.dart';

part 'streak_state.dart';

class StreakCubit extends Cubit<StreakState> {
  StreakCubit({required this.calendarRepository}) : super(StreakInitial());

  final CalendarRepository calendarRepository;
  var _streaks = Streaks();
  Streaks get streaks => _streaks;

  Future<void> getStreaks() async {
    emit(StreakLoading());
    final streaksEither = await calendarRepository.getStreaks();
    streaksEither.fold(
      (failure) => emit(StreakError(errorMessage: failure.errorMessage)),
      (streaks) {
        _streaks = streaks;
      },
    );
    emit(StreakLoaded());
  }

  Future<void> addDayToStreaks(DateTime day) async {
    emit(StreakLoading());
    _streaks.addDayToStreak(day);
    print(_streaks.toString());
    final streaksEither = await calendarRepository.saveStreaks(_streaks);
    streaksEither.fold(
      (failure) => emit(StreakError(errorMessage: failure.errorMessage)),
      (_) => emit(StreakSaved()),
    );
  }

  Future<void> deleteStreaks() async {
    emit(StreakLoading());
    final streaksEither = await calendarRepository.deleteStreaks();
    streaksEither.fold(
      (failure) => emit(StreakError(errorMessage: failure.errorMessage)),
      (_) => emit(StreakDeleted()),
    );
    await getStreaks();
  }

  Stream<Streaks?> watchStreaks() {
    return calendarRepository.watchStreaks().fold(
      (failure) {
        emit(StreakError(errorMessage: failure.errorMessage));
        return const Stream.empty();
      },
      (stream) => stream,
    );
  }
}