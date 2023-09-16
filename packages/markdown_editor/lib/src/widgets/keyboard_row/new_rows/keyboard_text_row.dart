import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_button.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_row_container.dart';
import 'package:markdown_editor/src/widgets/keyboard_row/keyboard_toggle.dart';
import 'package:ui_components/ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardTextRow extends StatelessWidget {
  const KeyboardTextRow({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditorBloc = context.read<TextEditorBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(
          width: 8,
        ),
        KeyboardButton(
          icon: UIIcons.add,
          onPressed: () {
            context.read<KeyboardRowCubit>().expandAddNewTile();
          },
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 4,
              ),
              KeyboardRowContainer(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatBold,
                      onPressed: (value) {
                        textEditorBloc
                            .add(TextEditorKeyboardRowChange(isBold: value));
                      },
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatItalic,
                      onPressed: (value) {
                        textEditorBloc
                            .add(TextEditorKeyboardRowChange(isItalic: value));
                      },
                    ),
                    KeyboardToggle(
                      icon: UIIcons.formatUnderline,
                      onPressed: (value) {
                        textEditorBloc.add(
                            TextEditorKeyboardRowChange(isUnderlined: value));
                      },
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
              KeyboardRowContainer(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    KeyboardButton(
                      icon: UIIcons.formatColorFill.copyWith(
                          color: textEditorBloc.textBackgroundColor ==
                                  Colors.transparent
                              ? UIColors.smallText
                              : textEditorBloc.textBackgroundColor.withAlpha(255)),
                      onPressed: () {
                        if (!context
                            .read<KeyboardRowCubit>()
                            .expandedBackgroundColors) {
                          context
                              .read<KeyboardRowCubit>()
                              .expandBackgroundColors();
                        } else {
                          context.read<KeyboardRowCubit>().expandText();
                        }
                      },
                      onDoubleTap: (){
                        context.read<KeyboardRowCubit>().changeBackgroundColor(Colors.transparent, textEditorBloc);
                      }
                    ),
                    KeyboardButton(
                      icon: UIIcons.formatColorText
                          .copyWith(color: textEditorBloc.isDefaultOnBackgroundTextColor? UIColors.smallText : textEditorBloc.textColor),
                      onPressed: () {
                        if (!context
                            .read<KeyboardRowCubit>()
                            .expandedTextColors) {
                          context.read<KeyboardRowCubit>().expandTextColors();
                        } else {
                          context.read<KeyboardRowCubit>().expandText();
                        }
                      },
                      onDoubleTap: (){
                        context.read<KeyboardRowCubit>().defaultTextColor(textEditorBloc);
                      }
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
        KeyboardButton(icon: UIIcons.done.copyWith(color: UIColors.primary), onPressed: () {}),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}