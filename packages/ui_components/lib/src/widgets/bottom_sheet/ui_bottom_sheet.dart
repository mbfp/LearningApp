// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_components/src/widgets/bottom_sheet/ui_bottom_sheet_title_row.dart';
import 'package:ui_components/ui_components.dart';

class UIBottomSheet extends StatelessWidget {
  const UIBottomSheet({
    super.key,
    required this.child,
    this.actionLeft,
    this.title,
    this.actionRight,
  });
  final Widget child;

  /// preferably icon on the left
  final Widget? actionLeft;

  /// preferably text in the center of the row
  final Widget? title;

  /// preferably icon on the right
  final Widget? actionRight;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: UIColors.overlay,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UIConstants.bottomSheetCornerRadius),
            topRight: Radius.circular(UIConstants.bottomSheetCornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: UIConstants.pageHorizontalPadding,
              right: UIConstants.pageHorizontalPadding,
              top: UIConstants.pageVerticalPadding),
          child: Column(children: [
            UIBottomSheetTitleRow(
              actionLeft: actionLeft,
              actionRight: actionRight,
              title: title,
            ),
            const SizedBox(height: UIConstants.itemPaddingLarge,),
            child
          ]),
        ),
      ),
    );
  }
}