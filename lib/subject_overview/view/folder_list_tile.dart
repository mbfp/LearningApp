import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/subject_overview/bloc/selection_bloc/subject_overview_selection_bloc.dart';
import 'package:learning_app/subject_overview/view/folder_draggable_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile_view.dart';
import 'package:learning_app/subject_overview/view/folder_drag_target.dart';
import 'package:learning_app/subject_overview/view/inactive_folder_list_tile.dart';
import 'package:ui_components/ui_components.dart';

class FolderListTile extends StatefulWidget {
  FolderListTile({
    super.key,
    required this.folder,
    required this.cardsRepository,
    this.isHighlight = false,
  });

  final Folder folder;
  final CardsRepository cardsRepository;
  bool isHighlight;

  @override
  State<FolderListTile> createState() => _FolderListTileState();
}

class _FolderListTileState extends State<FolderListTile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        print("rebuild" + widget.folder.name);
        return FolderListTileBloc(
          widget.cardsRepository,
        );
      },
      child: Builder(
        builder: (context) {
          var childListTiles = <String, Widget>{};
          context
              .read<FolderListTileBloc>()
              .add(FolderListTileGetChildrenById(id: widget.folder.id));
          //test
          return Padding(
            padding: const EdgeInsets.only(
              bottom: UISizeConstants.defaultSize,
            ),
            child: BlocBuilder<SubjectOverviewSelectionBloc,
                SubjectOverviewSelectionState>(
              builder: (context, state) {
                return LongPressDraggable<Folder>(
                  data: widget.folder,
                  feedback: FolderDraggableTile(
                    folder: widget.folder,
                  ),
                  maxSimultaneousDrags:
                      state is SubjectOverviewSelectionModeOn ? 0 : 1,
                  childWhenDragging: const PlaceholderWhileDragging(),
                  child: FolderDragTarget(
                    parentID: widget.folder.id,
                    child: BlocBuilder<FolderListTileBloc, FolderListTileState>(
                      buildWhen: (previous, current) {
                        if (current is FolderListTileRetrieveChildren) {
                          setState(() {});
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is FolderListTileRetrieveChildren) {
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
                              inSelectionMode:
                                  state is SubjectOverviewSelectionModeOn,
                              folder: widget.folder,
                              childListTiles: childListTiles,
                              isHighlight: widget.isHighlight,
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
