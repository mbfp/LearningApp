import 'dart:math';

import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/add_folder/view/add_folder_bottom_sheet.dart';
import 'package:learning_app/add_folder/view/edit_folder_bottom_sheet.dart';
import 'package:learning_app/app/helper/uid.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/bloc/subject_bloc/subject_bloc.dart';
import 'package:ui_components/ui_components.dart';

class SubjectPageToolBar extends StatelessWidget {
  const SubjectPageToolBar({
    super.key,
    required this.cardsRepository,
    required this.subjectToEditUID,
  });
  final CardsRepository cardsRepository;
  final String subjectToEditUID;
  @override
  Widget build(BuildContext context) {
    String? softSelectedFolderUID;
    Object? softSelectedFile;
    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        softSelectedFile = cardsRepository.objectFromId(
            context.read<SubjectOverviewSelectionBloc>().fileSoftSelected);
        if (softSelectedFile is Folder) {
          softSelectedFolderUID = (softSelectedFile! as Folder).uid;
        } else {
          softSelectedFolderUID = null;
        }
        return UILabelRow(
          labelText: 'Files',
          actionWidgets: [
            UIIconButton(
              icon: UIIcons.search.copyWith(color: UIColors.smallText),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/search',
                  arguments: subjectToEditUID,
                );
              },
            ),
            const Spacer(),
            UIIconButton(
              icon: UIIcons.debug.copyWith(color: UIColors.smallText),
              onPressed: () {
                final r = Random();
                for (var i = 0; i < 100; i++) {
                  context.read<SubjectBloc>().add(
                        SubjectAddCard(
                          name: r.nextDouble().toString(),
                          parentId: softSelectedFolderUID ?? subjectToEditUID,
                        ),
                      );
                }
              },
            ),
            const Spacer(),
            UIIconButton(
              icon: UIIcons.addFolder.copyWith(color: UIColors.smallText),
              onPressed: () {
                UIBottomSheet.showUIBottomSheet(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<SubjectBloc>(),
                      child: BlocProvider.value(
                        value: context.read<SubjectOverviewSelectionBloc>(),
                        child: AddFolderBottomSheet(
                          parentId: softSelectedFolderUID ?? subjectToEditUID,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            UIIconButton(
              icon: UIIcons.card.copyWith(color: UIColors.smallText),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/add_card',
                  arguments: [
                    Card(
                      uid: Uid().uid(),
                      dateCreated: DateTime.now(),
                      askCardsInverted: false,
                      typeAnswer: false,
                      recallScore: 0,
                      dateToReview: DateTime.now(),
                      name: '',
                    ),
                    subjectToEditUID,
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
