import 'package:flutter/material.dart';

class CardBase extends StatelessWidget {
  //static const double PADDING_HORIZONTAL = 15;

  final Widget? child;
  final double? heigth;
  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? backgroundColor;
  final Function? onTapCard;

  CardBase(
      {this.child,
      this.heigth,
      this.width,
      this.horizontalPadding,
      this.verticalPadding,
      this.backgroundColor,
      this.onTapCard});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              height: heigth,
              width: width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: child),
        ));
  }
}