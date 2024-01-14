import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/subject_overview/bloc/folder_bloc/folder_list_tile_bloc.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_button.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/text_fields/ui_text_field_large.dart';class EditFolderBottomSheet extends StatefulWidget {
  const EditFolderBottomSheet({
    super.key,
    required this.folder,
  });

  final Folder folder;

  @override
  State<EditFolderBottomSheet> createState() => _EditFolderBottomSheetState();
}

class _EditFolderBottomSheetState extends State<EditFolderBottomSheet> {
  void trySaveFolder(String name) {
    context.read<FolderListTileBloc>().add(FolderListTileChangeFolderName(
          folder: widget.folder,
          newName: name,
        ),);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.folder.name);

    return UIBottomSheet(
      actionLeft: UIIconButton(
        icon: UIIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Edit Foldername', style: UIText.label),
      actionRight: UIButton(
        child: Text(
          'Save',
          style: UIText.labelBold.copyWith(
            color: UIColors.primary,
          ),
        ),
        onPressed: () => trySaveFolder(nameController.text),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: UIIcons.folder.copyWith(color: UIColors.smallText),
              ),
              const SizedBox(
                width: UIConstants.itemPadding * 0.75,
              ),
              Expanded(
                child: UITextFieldLarge(
                  controller: nameController,
                  autofocus: true,
                  onFieldSubmitted: (p0) {
                    trySaveFolder(nameController.text);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.itemPaddingLarge),
        ],
      ),
    );
  }
}
