import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:ui_components/ui_components.dart';

class EditorWidget extends StatelessWidget {
  EditorWidget({super.key});
  bool _firstBuild = true;
  GlobalKey<SliverReorderableListState> listKey =
      GlobalKey<SliverReorderableListState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorBloc, TextEditorState>(
      buildWhen: (previousState, currentState) =>
          currentState is TextEditorEditorTilesChanged,
      builder: (context, state) {
        final editorTiles = context.read<TextEditorBloc>().editorTiles;
        if (_firstBuild) {
          if (editorTiles[0] is HeaderTile &&
              ((editorTiles[0] as HeaderTile).charTiles == null ||
                  (editorTiles[0] as HeaderTile).charTiles!.isEmpty)) {
            editorTiles[0].focusNode!.requestFocus();
          }
          _firstBuild = false;
        }
        final listChildren = <Widget>[
          // SliverList(
          //   delegate: SliverChildListDelegate.fixed([
          //     ReorderableListView.builder(
          //         itemBuilder: (context, index) {
          //           return BlocProvider.value(
          //             key: Key(index.toString()),
          //             value: context.read<TextEditorBloc>(),
          //             child: Row(
          //               children: [
          //                 Expanded(child: editorTiles[index] as Widget),
          //               ],
          //             ),
          //           );
          //         },
          //         itemCount: editorTiles.length,
          //         onReorder: (oldIndex, newIndex) {
          //           context.read<TextEditorBloc>().add(
          //               TextEditorChangeOrderOfTile(
          //                   oldIndex: oldIndex, newIndex: newIndex));
          //         })
          //   ]),
          // ),
          SliverReorderableList(
              key: listKey,
              itemBuilder: (context, index) {
                return ReorderableDelayedDragStartListener(
                  key: Key(index.toString()),
                  index: index,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<TextEditorBloc>(),
                      ),
                      BlocProvider.value(
                          value: context.read<KeyboardRowCubit>()),
                    ],
                    child: Material(child: editorTiles[index] as Widget),
                  ),
                );
              },
              itemCount: editorTiles.length,
              onReorderStart: (p0) {},
              onReorder: (oldIndex, newIndex) {
                context.read<TextEditorBloc>().add(TextEditorChangeOrderOfTile(
                    oldIndex: oldIndex, newIndex: newIndex));
              }),

          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) => editorTiles[index] as Widget,
          //     childCount: editorTiles.length,
          //   ),
          // ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context
                    .read<TextEditorBloc>()
                    .add(TextEditorFocusLastWidget()),
                child: Container(height: 120),
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: GestureDetector(
              onTap: () => context
                  .read<TextEditorBloc>()
                  .add(TextEditorFocusLastWidget()),
              // child: Container(height: 120),
            ),
          ),
        ];
        return CustomScrollView(
          slivers: listChildren,
        );
      },
    );
  }
}


/// # heading 1
/// ## heading 2
/// ### heading 3
/// #### heading 4
/// ##### heading 5
/// ###### heading 6
/// - / + / * unordered list
/// > quotes
/// [link] (href) links
/// ''' code '''
/// | tables | column 2
/// --- hr
/// 1. ordered list
/// $ latex
/// \** bold **
/// \* italic *
/// text color
