// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_icons.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_label_row.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_drag_target.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/list_tile_wrapper.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_hover_cubit.dart';
import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

import 'package:learning_app/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:learning_app/features/file_system/presentation/subjects/widgets/folder_content.dart';
import 'package:learning_app/features/subject/presentation/widgets/subject_app_bar.dart';
import 'package:learning_app/features/subject/presentation/widgets/subject_card.dart';
import 'package:learning_app/features/subject/presentation/widgets/subject_page_auto_scroller.dart';
import 'package:learning_app/features/subject/presentation/widgets/files_tool_bar.dart';
import 'package:learning_app/injection_container.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SubjectBloc>(param1: subjectId),
        ),
        BlocProvider(
          create: (context) => sl<SubjectSelectionCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SubjectHoverCubit>(),
        ),
      ],
      child: SubjectView(subjectId: subjectId),
    );
  }
}

class SubjectView extends StatelessWidget {
  final String subjectId;
  const SubjectView({
    super.key,
    required this.subjectId,
  });
  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();
    final scrollController = ScrollController();
    return Scaffold(
      appBar: const SubjectAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.pageHorizontalPadding),
          child: AutoScrollView(
            globalKey: globalKey,
            scrollController: scrollController,
            child: FolderDragTarget(
              folderId: subjectId,
              child: Scrollbar(
                controller: scrollController,
                interactive: true,
                thumbVisibility: false,
                radius: const Radius.circular(8.0),
                thickness: UIConstants.defaultSize,
                child: CustomScrollView(
                  controller: scrollController,
                  key: globalKey,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: UIConstants.itemPadding),
                        SubjectCard(subjectId: subjectId),
                        const SizedBox(height: UIConstants.itemPaddingLarge),
                      ]),
                    ),
                    const FilesToolBar(),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: UIConstants.itemPadding),
                        BlocBuilder<SubjectHoverCubit, SubjectHoverState>(
                          builder: (context, state) {
                            return FolderContent(parentId: subjectId);
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
