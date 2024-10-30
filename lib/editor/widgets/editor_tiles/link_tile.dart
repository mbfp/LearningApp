import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/editor/bloc/text_editor_bloc.dart';
import 'package:learning_app/editor/card_preview_bottom_sheet.dart';
import 'package:learning_app/editor/models/editor_tile.dart';
import 'package:learning_app/editor/models/text_field_controller.dart';
import 'package:learning_app/ui_components/ui_colors.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';
import 'package:learning_app/ui_components/widgets/bottom_sheet/ui_bottom_sheet.dart';
import 'package:learning_app/ui_components/widgets/buttons/ui_icon_button.dart';
import 'package:learning_app/ui_components/widgets/dialogs/ui_dialog.dart';

class LinkTile extends StatelessWidget implements EditorTile {
  LinkTile({
    super.key,
    required this.cardId,
    this.inRenderMode = false,
    this.cardsRepository,
  });

  String cardId;

  ///used if inRenderMode to avoid TextEditorBloc
  CardsRepository? cardsRepository;

  @override
  FocusNode? focusNode;

  @override
  TextFieldController? textFieldController;

  @override
  bool inRenderMode;

  @override
  Widget build(BuildContext context) {
    final card = inRenderMode
        ? cardsRepository!.getCardById(cardId)
        : context.read<TextEditorBloc>().cardsRepository.getCardById(cardId);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          if (card == null) {
            showDialog(
                context: context,
                builder: (_) => UIDialog(
                    title: 'Link Error',
                    body: "The linked card isn't anymore accessible",
                    actions: []));
            return;
          }

          UIBottomSheet.showUIBottomSheet(
            context: context,
            builder: (_) {
              return CardPreviewBottomSheet(
                card: card,
                cardsRepository: inRenderMode
                    ? cardsRepository!
                    : context.read<TextEditorBloc>().cardsRepository,
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: UIConstants.itemPadding / 2,
            horizontal: UIConstants.pageHorizontalPadding,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: UIColors.overlay,
              borderRadius: BorderRadius.circular(UIConstants.cornerRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: UIConstants.itemPadding,
                right: 2,
                // top: UIConstants.itemPadding / 2.5,
                /* bottom: UIConstants.itemPadding/2.5 */
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIIcons.link.copyWith(color: UIColors.smallText),
                  const SizedBox(width: UIConstants.itemPadding / 2),
                  Text(
                    card != null ? card.name : 'Linked card got deleted',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: card != null
                        ? UIText.label.copyWith(color: UIColors.smallText)
                        : UIText.code.copyWith(color: UIColors.red),
                  ),
                  if (!inRenderMode)
                    UIIconButton(
                      icon: UIIcons.cancel
                          .copyWith(color: card!=null? UIColors.background : UIColors.red, size: 28),
                      animateToWhite: true,
                      onPressed: () {
                        context.read<TextEditorBloc>().add(
                              TextEditorRemoveEditorTile(
                                tileToRemove: this,
                                context: context,
                              ),
                            );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}