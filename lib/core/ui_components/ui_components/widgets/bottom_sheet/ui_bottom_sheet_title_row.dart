import 'package:flutter/material.dart';

class UIBottomSheetTitleRow extends StatelessWidget {
  const UIBottomSheetTitleRow({
    super.key,
    this.title,
    this.actionLeft,
    this.actionRight,
  });

  /// preferably icon on the left
  final Widget? actionLeft;

  /// preferably text in the center of the row
  final Widget? title;

  /// preferably icon on the right
  final Widget? actionRight;

  @override
  Widget build(BuildContext context) {
    if (actionLeft == null && actionRight == null && title != null) {
      return Container(
        alignment: Alignment.center,
        child: title,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: actionLeft,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: title,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: actionRight,
          ),
        ),
      ],
    );
  }
}
