import 'package:app_base/app_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Svc {}

class _SvcImpl extends Svc {}

class WidgetUsingSvc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ignore:unused_local_variable
    final Svc svc = inject<Svc>(context);

    return SizedBox(
      width: 48.0,
      height: 48.0,
    );
  }
}

Widget _child() {
  return Builder(
    builder: (BuildContext context) {
      return new WidgetUsingSvc();
    },
  );
}

void main() {
  testWidgets('Module.register<T>', (WidgetTester tester) async {
    await tester.pumpWidget(
      Module().register<Svc>(_SvcImpl()).build(_child()),
    );
  });
}
