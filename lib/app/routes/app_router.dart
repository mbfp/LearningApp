import 'package:learning_app/add_edit_class_test/cubit/add_edit_class_test_cubit.dart';
import 'package:learning_app/calendar/cubit/calendar_cubit.dart';
import 'package:learning_app/calendar/view/calendar_page.dart';
import 'package:learning_app/calendar_backend/calendar_repository.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/add_card_page.dart';
import 'package:learning_app/add_card/view/card_settings_page.dart';
import 'package:learning_app/add_edit_class_test/cubit/relevant_folders_cubit.dart';
import 'package:learning_app/add_edit_class_test/view/add_class_test_page.dart';
import 'package:learning_app/add_edit_class_test/view/relevant_folders_page.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/edit_subject/view/edit_subject_page.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/cubit/render_card.dart';
import 'package:learning_app/learn/view/learning_screen.dart';
import 'package:learning_app/overview/cubit/overview_cubit.dart';
import 'package:learning_app/overview/view/overview_page.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/search_page.dart';
import 'package:learning_app/settings/cubit/settings_cubit.dart';
import 'package:learning_app/settings/view/settings_page.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/subject_page/subject_page.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository, this._calendarRepository);

  final CardsRepository _cardsRepository;
  final CalendarRepository _calendarRepository;

  late final SubjectBloc _editSubjectBloc = SubjectBloc(_cardsRepository);
  late final AddCardCubit _addCardCubit = AddCardCubit(_cardsRepository);
  late final OverviewCubit _overviewCubit = OverviewCubit(_cardsRepository);
  // ..add(OverviewSubjectSubscriptionRequested());
  late final EditSubjectCubit _editSubjectCubit =
      EditSubjectCubit(_cardsRepository);
  late final LearnCubit _learnCubit = LearnCubit(_cardsRepository);
  late final SearchBloc _searchBloc = SearchBloc(_cardsRepository);
  late final FolderListTileBloc _folderListTileBloc =
      FolderListTileBloc(_cardsRepository);

  late final SettingsCubit _settingsCubit = SettingsCubit();

  late final _calendarCubit = CalendarCubit(
    calendarRepository: _calendarRepository,
    cardsRepository: _cardsRepository,
  );

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _overviewCubit),
              BlocProvider.value(value: _calendarCubit),
              BlocProvider.value(value: _learnCubit),
              BlocProvider(
                create: (context) => AddSubjectCubit(_cardsRepository),
              ),
            ],
            child: const OverviewPage(),
          ),
        );
      case '/add_card':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _addCardCubit),
              // BlocProvider.value(value: _editSubjectBloc),
              // BlocProvider.value(value: _audioTileCubit)
            ],
            child: AddCardPage(
              card: (routeSettings.arguments! as List)[0] as Card,
              parentId: (routeSettings.arguments! as List)[1] as String?,
            ),
          ),
        );
      case '/add_card/settings':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _addCardCubit,
              ),
            ],
            child: CardSettingsPage(
              card: (routeSettings.arguments! as List)[0] as Card,
              parentId: (routeSettings.arguments! as List)[1] as String?,
              editorTiles:
                  (routeSettings.arguments! as List)[2] as List<EditorTile>,
            ),
          ),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [BlocProvider.value(value: _settingsCubit)],
            child: SettingsPage(),
          ),
        );
      case '/calendar':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _calendarCubit,
              ),
              // BlocProvider(
              //   create: (context) => SubjectBloc(),
              // ),
              // BlocProvider(
              //   create: (context) => SubjectBloc(),
              // ),
            ],
            child: const CalendarPage(),
          ),
        );
      case '/search':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _searchBloc),
              BlocProvider.value(value: _overviewCubit)
            ],
            child: SearchPage(
              searchId: routeSettings.arguments as String?,
            ),
          ),
        );

      case '/subject_overview':
        final esb = SubjectBloc(_cardsRepository);
        final sosb = SubjectOverviewSelectionBloc(_cardsRepository);
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _folderListTileBloc,
              ),
              // BlocProvider.value(
              //   value: _editSubjectBloc,
              // ),
              // BlocProvider.value(
              //   value: _editSubjectBloc
              // ),
              BlocProvider.value(value: _editSubjectCubit),
              BlocProvider(
                create: (context) => sosb,
              ),
              // BlocProvider.value(
              //   value: _addFolderCubit,
              // )
            ],
            child: SubjectPage(
              subjectToEdit: routeSettings.arguments! as Subject,
              editSubjectBloc: esb,
              cardsRepository: _cardsRepository,
            ),
          ),
        );

      case '/subject_overview/edit_subject':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _editSubjectCubit,
              ),
            ],
            child: EditSubjectPage(
              subject: routeSettings.arguments! as Subject,
            ),
          ),
        );
      case '/subject_overview/edit_subject/add_class_test':
        return MaterialPageRoute(
          builder: (_) {
            // ClassTest? classTest;
            // if (routeSettings.arguments is List<dynamic> &&
            //     (routeSettings.arguments! as List<dynamic>)[1] is Subject) {
            //   _editSubjectCubit.init(
            //     (routeSettings.arguments! as List<dynamic>)[1] as Subject,
            //   );
            //   classTest =
            //       (routeSettings.arguments! as List<dynamic>)[0] as ClassTest;
            // } else {
            //   classTest = (routeSettings.arguments as ClassTest?);
            // }

            return MultiBlocProvider(
              providers: [
                // BlocProvider.value(
                //   value: _editSubjectCubit,
                // ),
                BlocProvider(
                  create: (context) => AddEditClassTestCubit(
                    parentSubject: routeSettings.arguments! as Subject,
                    cardsRepository: _cardsRepository,
                  ),
                ),
              ],
              child: AddClassTestPage(
                addClassTest: true,
              ),
            );
          },
        );
      case '/subject_overview/edit_subject/edit_class_test':
        return MaterialPageRoute(
          builder: (_) {
            // ClassTest? classTest;
            // if (routeSettings.arguments is List<dynamic> &&
            //     (routeSettings.arguments! as List<dynamic>)[1] is Subject) {
            //   _editSubjectCubit.init(
            //     (routeSettings.arguments! as List<dynamic>)[1] as Subject,
            //   );
            //   classTest =
            //       (routeSettings.arguments! as List<dynamic>)[0] as ClassTest;
            // } else {
            //   classTest = (routeSettings.arguments as ClassTest?);
            // }

            return MultiBlocProvider(
              providers: [
                // BlocProvider.value(
                //   value: _editSubjectCubit,
                // ),
                BlocProvider(
                  create: (context) => AddEditClassTestCubit(
                    parentSubject: (routeSettings.arguments!
                        as List<dynamic>)[1] as Subject,
                    cardsRepository: _cardsRepository,
                    classTest: (routeSettings.arguments! as List<dynamic>)[0]
                        as ClassTest,
                  ),
                ),
              ],
              child: AddClassTestPage(
                addClassTest: false,
              ),
            );
          },
        );
      case '/subject_overview/edit_subject/add_class_test/relevant_folders':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: (routeSettings.arguments!) as AddEditClassTestCubit,
              ),
            ],
            child: RelevantFoldersPage(
              cardsRepository: _cardsRepository,
              subjectToEdit:
                  ((routeSettings.arguments!) as AddEditClassTestCubit)
                      .parentSubject,
              classTest: ((routeSettings.arguments!) as AddEditClassTestCubit)
                  .classTest!,
            ),
          ),
        );
      case '/learn':
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _learnCubit
                    ..setToLearnCards(
                        (routeSettings.arguments as List<dynamic>)[0] == 'today'
                            ? _cardsRepository.getAllCardsToLearnForToday()
                            : []),
                ),
              ],
              child: LearningScreen(
                cardsRepository: _cardsRepository,
              ),
            );
          },
        );
      // error route
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorPage(
            errorMessage: 'Internal routing error',
          ),
        );
    }
  }
}

class LearnPageArguments {}
