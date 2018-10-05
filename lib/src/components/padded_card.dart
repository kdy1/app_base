import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets outer;
  final EdgeInsets inner;

  const PaddedCard({
    Key key,
    @required this.child,
    this.outer = const EdgeInsets.symmetric(horizontal: 8.0),
    this.inner = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;

    if (inner != const EdgeInsets.all(0.0)) {
      child = Padding(
        padding: inner,
        child: child,
      );
    }

    if (outer != const EdgeInsets.all(0.0)) {
      return Padding(
        padding: outer,
        child: Card(child: child),
      );
    } else {
      return Card(
        child: child,
      );
    }
  }
}
