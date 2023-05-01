import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/edit_subject_bloc/subject_overview_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/inactive_folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTileParent extends StatelessWidget {
  FolderListTileParent({
    super.key,
    required this.folder,
    required this.cardsRepository,
  });

  final Folder folder;
  final CardsRepository cardsRepository;

  bool isHoverd = false;

  var childListTiles = <String, Widget>{};
  @override
  Widget build(BuildContext context) {
    context
        .read<FolderListTileBloc>()
        .add(FolderListTileGetChildrenById(id: folder.id));
    // print("rebuild" + folder.name);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: UIConstants.defaultSize,
      ),
      child: BlocBuilder<SubjectOverviewSelectionBloc,
          SubjectOverviewSelectionState>(
        builder: (context, state) {
          return LongPressDraggable<Folder>(
            data: folder,
            feedback: FolderDraggableTile(
              folder: folder,
            ),
            onDragEnd: (details) {
              isHoverd = false;
              context
                  .read<FolderListTileBloc>()
                  .add(FolderListTileClearHovers());
            },
            maxSimultaneousDrags:
                state is SubjectOverviewSelectionModeOn ? 0 : 1,
            childWhenDragging: const PlaceholderWhileDragging(),
            child: DragTarget(
              onMove: (details) {
                if (isHoverd == false) {
                  isHoverd = true;
                  context
                      .read<FolderListTileBloc>()
                      .add(FolderListTileUpdate(id: folder.id));
                }
              },
              onLeave: (data) {
                if (isHoverd == true) {
                  isHoverd = false;
                  context
                      .read<FolderListTileBloc>()
                      .add(FolderListTileUpdate(id: folder.id));
                }
              },
              onAccept: (data) {
                if (data is Folder) {
                  if (data.parentId == folder.id) return;
                  context.read<EditSubjectBloc>().add(
                        EditSubjectSetFolderParent(
                          folder: data,
                          parentId: folder.id,
                        ),
                      );
                } else if (data is Card) {
                  if (data.parentId != folder.id) {
                    if (context.read<SubjectOverviewSelectionBloc>().state
                        is SubjectOverviewSelectionMultiDragging) {
                      context.read<SubjectOverviewSelectionBloc>().add(
                            SubjectOverviewSelectionMoveSelectedCards(
                              parentId: folder.id,
                            ),
                          );
                    } else {
                      context.read<EditSubjectBloc>().add(
                            EditSubjectSetCardParent(
                              card: data,
                              parentId: folder.id,
                            ),
                          );
                    }
                  } else if (context
                      .read<SubjectOverviewSelectionBloc>()
                      .isInSelectMode) {
                    context.read<SubjectOverviewSelectionBloc>().add(
                          SubjectOverviewSelectionMoveSelectedCards(
                            parentId: folder.id,
                          ),
                        );
                  } else {
                    context.read<SubjectOverviewSelectionBloc>().add(
                          SubjectOverviewSelectionToggleSelectMode(
                            inSelectMode: true,
                          ),
                        );
                    context.read<SubjectOverviewSelectionBloc>().add(
                          SubjectOverviewSelectionChange(
                            card: data,
                            addCard: true,
                          ),
                        );
                  }
                }
              },
              builder: (context, candidateData, rejectedData) {
                return BlocBuilder<FolderListTileBloc, FolderListTileState>(
                  buildWhen: (previous, current) {
                    if (current is FolderListTileRetrieveChildren &&
                        current.senderId == folder.id) {
                      isHoverd = false;
                      return true;
                    } else if (current is FolderListTileUpdateOnHover) {
                      if (current.id == folder.id) return true;
                    } else if (current is FolderListTileToClearHover) {
                      if (isHoverd == true) {
                        isHoverd = false;
                        return true;
                      }
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is FolderListTileRetrieveChildren &&
                        state.senderId == folder.id) {
                      childListTiles = {
                        ...childListTiles,
                        ...state.childrenStream
                      };
                      for (final element in state.removedWidgets) {
                        if (childListTiles.containsKey(element.id)) {
                          childListTiles.remove(element.id);
                        }
                      }
                    }

                    return BlocBuilder<SubjectOverviewSelectionBloc,
                        SubjectOverviewSelectionState>(
                      builder: (context, state) {
                        return FolderListTileView(
                          isHoverd: isHoverd,
                          inSelectionMode:
                              state is SubjectOverviewSelectionModeOn,
                          folder: folder,
                          childListTiles: childListTiles,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
