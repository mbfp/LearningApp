// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning_app/ui_components/ui_constants.dart';
import 'package:learning_app/ui_components/ui_icons.dart';
import 'package:learning_app/ui_components/ui_text.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  String title;
  double? titleSpacing;
  double? iconSpacing;
  double? childSpacing;
  double? collapsedHeight;
  Widget? trailing;
  Color? backgroundColor;
  Color? textColor;
  Color? iconColor;
  bool iconOnTheRight;
  Border? border;
  bool changeExtensionState;

  UIExpansionTile({
    super.key,
    required this.children,
    required this.title,
    this.titleSpacing = UIConstants.defaultSize,
    this.iconSpacing = UIConstants.defaultSize,
    this.childSpacing = 0,
    this.collapsedHeight,
    this.trailing,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconOnTheRight = false,
    this.border,
    this.changeExtensionState = false,
  }) {
    iconColor ??= textColor;
  }

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isOpened = false;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  GestureDetector expansionIcon() => GestureDetector(
        onTap: update,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Transform.rotate(
              angle: pi * _animation.value / 2 - pi / 2,
              child: UIIcons.expandMore.copyWith(color: widget.iconColor),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: _key,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
        color: widget.backgroundColor,
        border: widget.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.collapsedHeight,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              children: [
                if (!widget.iconOnTheRight) expansionIcon(),
                if (!widget.iconOnTheRight)
                  SizedBox(width: widget.titleSpacing),
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: UIText.label.copyWith(color: widget.textColor),
                  ),
                ),
                const SizedBox(width: UIConstants.defaultSize),
                if (widget.trailing != null) widget.trailing!,
                const SizedBox(width: UIConstants.defaultSize),
                if (widget.iconOnTheRight) expansionIcon(),
              ],
            ),
          ),
          if ((_isOpened || _animation.value > 0) &&
              widget.childSpacing != null)
            SizedBox(height: widget.childSpacing),
          if (_isOpened || _animation.value > 0)
            SizeTransition(
              sizeFactor: _animation,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => widget.children[index],
                itemCount: widget.children.length,
              ),
            ),
        ],
      ),
    )
        .animate(
            delay: const Duration(milliseconds: 100),
            target: widget.changeExtensionState == true ? 1 : 0,
            onComplete: (controller) => controller.reset(),
            onPlay: (controller) => controller.reset(),
            autoPlay: false)
        .shake(
            delay: const Duration(milliseconds: 800),
            duration: const Duration(milliseconds: 800),
            hz: 3,
            rotation: .02,
            curve: Curves.easeIn)
        .callback(callback: (value) {
      changeState();
    });
  }

  void update() {
    setState(() {
      _isOpened = !_isOpened;
    });
    if (_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void changeState() async {
    if (widget.changeExtensionState) {
      widget.changeExtensionState = false;
      update();
    }
  }
}