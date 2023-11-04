import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_folder/view/edit_folder_bottom_sheet.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:ui_components/ui_components.dart';

import '../../bloc/folder_bloc/folder_list_tile_bloc.dart';

class SubjectPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubjectPageAppBar(
      {super.key, required this.cardsRepository, required this.subjectToEdit});
  final CardsRepository cardsRepository;
  final Subject subjectToEdit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectOverviewSelectionBloc,
        SubjectOverviewSelectionState>(
      builder: (context, state) {
        final softSelectedFile = cardsRepository.objectFromId(
            context.read<SubjectOverviewSelectionBloc>().fileUIDSoftSelected);
        return UIAppBar(
          leadingBackButton:
              !context.read<SubjectOverviewSelectionBloc>().isInSelectMode,
          leading: context.read<SubjectOverviewSelectionBloc>().isInSelectMode
              ? UIIconButton(
                  icon: UIIcons.close,
                  onPressed: () =>
                      context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionToggleSelectMode(
                              inSelectMode: false,
                            ),
                          ),
                )
              : null,
          actions: softSelectedFile is Folder
              ? [
                  UIIconButton(
                    icon: UIIcons.edit,
                    onPressed: () => UIBottomSheet.showUIBottomSheet(
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<FolderListTileBloc>(),
                          child: EditFolderBottomSheet(
                            folder: softSelectedFile!,
                          ),
                        );
                      },
                    ),
                  ),
                ]
              : softSelectedFile is Card
                  ? [
                      Text((softSelectedFile! as Card).uid),
                    ]
                  : [
                      UIIconButton(
                        icon: UIIcons.settings,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/subject_overview/edit_subject',
                            arguments: subjectToEdit,
                          );
                        },
                      ),
                    ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
