import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_card/cubit/add_card_cubit.dart';
import 'package:learning_app/add_card/view/add_card_page.dart';
import 'package:learning_app/add_edit_class_test/view/add_class_test_page.dart';
import 'package:learning_app/add_subject/cubit/add_subject_cubit.dart';
import 'package:learning_app/app/view/error.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:learning_app/edit_subject/view/edit_subject_page.dart';
import 'package:learning_app/learn/cubit/learn_cubit.dart';
import 'package:learning_app/learn/view/learning_screen.dart';
import 'package:learning_app/overview/bloc/overview_bloc.dart';
import 'package:learning_app/overview/view/overview_page.dart';
import 'package:learning_app/search/bloc/search_bloc.dart';
import 'package:learning_app/search/view/search_page.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:learning_app/subject_overview/view/subject_page.dart';
import 'package:markdown_editor/markdown_editor.dart';

/// Handles complete app routing and is injected in MaterialApp()
class AppRouter {
  AppRouter(this._cardsRepository);

  final CardsRepository _cardsRepository;

  late final SubjectBloc _editSubjectBloc =
      SubjectBloc(_cardsRepository);
  late final AddCardCubit _addCardCubit = AddCardCubit(_cardsRepository);
  late final OverviewBloc _overviewBloc = OverviewBloc(_cardsRepository)
    ..add(OverviewSubjectSubscriptionRequested());
  late final EditSubjectCubit _editSubjectCubit =
      EditSubjectCubit(_cardsRepository);
  late final LearnCubit _learnCubit = LearnCubit(_cardsRepository);
  late final SearchBloc _searchBloc = SearchBloc(_cardsRepository);
  late final FolderListTileBloc _folderListTileBloc =
      FolderListTileBloc(_cardsRepository);
  final TextEditorBloc _textEditorBloc = TextEditorBloc();
  final KeyboardRowCubit _keyboardRowCubit = KeyboardRowCubit();

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // home page, with bottom navigation bar
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _overviewBloc,
              ),
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
              BlocProvider.value(value: _editSubjectBloc),
              BlocProvider.value(value: _textEditorBloc),
              BlocProvider.value(value: _keyboardRowCubit),
              // BlocProvider.value(value: _audioTileCubit)
            ],
            child: AddCardPage(parentId: routeSettings.arguments as String),
          ),
        );
      case '/search':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [BlocProvider.value(value: _searchBloc)],
            child: SearchPage(searchId: routeSettings.arguments as String?,),
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
              )
            ],
            child: EditSubjectPage(
              subject: routeSettings.arguments! as Subject,
            ),
          ),
        );
      case '/subject_overview/edit_subject/add_class_test':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _editSubjectCubit,
              )
            ],
            child: AddClassTestPage(
              classTest: routeSettings.arguments as ClassTest?,
            ),
          ),
        );
      case '/learn':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _learnCubit,
              ),
            ],
            child: const LearningScreen(),
          ),
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
