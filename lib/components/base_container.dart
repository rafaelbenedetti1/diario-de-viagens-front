import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final Widget? child;

  BaseContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      child: Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: Container(
            decoration: BoxDecoration(color: theme.backgroundColor),
            child: child,
          ),
        ),
      ),
    );
  }
}
