// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/ui_constants.dart';

import '../ui_colors.dart';

class UICard extends StatelessWidget {
  const UICard({
    super.key,
    this.onTap,
    this.color,
    required this.child,
    this.useGradient = false,
    this.distanceToTop = 0,
    this.disabled = false,
  });

  final void Function()? onTap;
  final Color? color;
  final Widget child;
  final bool useGradient;
  final bool disabled;

  /// offset for gradient
  final double distanceToTop;

  @override
  Widget build(BuildContext context) {
    final relativeGradientPos =
        clampDouble(distanceToTop / MediaQuery.of(context).size.height, 0, 1);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? UIColors.overlay,
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadius),
          ),
          image: useGradient
              ? DecorationImage(
                  image: const AssetImage('assets/images/gradient.png'),
                  alignment: Alignment.lerp(
                        Alignment.topCenter,
                        Alignment.bottomCenter,
                        relativeGradientPos,
                      ) ??
                      Alignment.center,
                  fit: BoxFit.cover,
                  colorFilter: disabled
                      ? ColorFilter.mode(
                          Colors.black.withOpacity(.6), BlendMode.multiply)
                      : null,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.cardHorizontalPadding,
            vertical: UIConstants.cardVerticalPaddingLarge,
          ),
          child: child,
        ),
      ),
    );
  }
}
