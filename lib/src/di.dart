import 'package:flutter/material.dart';

/// Super-simple di for flutter.
///
/// This will be extended to support web in future.
T inject<T>(
  BuildContext context, {
  bool nullOk = false,
}) {
  assert(nullOk != null);

  final Type widgetType = _type<_Provider<T>>();

  final w = context.inheritFromWidgetOfExactType(widgetType) as _Provider<T>;

  if (w != null || nullOk) return w.value;

  var msg = 'Failed to inject ${_typeToStr(T)}: ${_typeToStr(widgetType)} not found';

  assert(() {
    msg += '\n----- Parent providers: -----\n';

    context.visitAncestorElements((e) {
      // skip useless nodes
      if (e is! InheritedElement) return true;

      final iw = e.widget;
      // if iw
      if (iw is _Provider<dynamic>) {
        if (iw is _Provider<T>) {
          msg += '\nFound: ${_typeToStr(iw.runtimeType)} (WTF?! $T is found)';
        } else {
          msg += '\nFound: ${_typeToStr(iw.runtimeType)}';
        }
      }

      return true;
    });

    return true;
  }());

  throw new FlutterError(msg);
}

/// A inheritable module. (As it's immutable, calling register is enough to do so.)
@immutable
class Module {
  Module() : this._((c) => c);

  Module._(this._wrap);

  final Widget Function(Widget child) _wrap;

  /// Provides [T] to children.
  ///
  /// This can be overrided by calling [register()] again with same type [T].
  ///
  ///
  /// returns copy of this module with `impl` added.
  Module register<T>(T impl) {
    assert(impl != null);

    // Pass type information to ProviderWidget
    return Module._(
      (Widget child) {
        final _Provider<T> implProvided = new _Provider<T>(
          value: impl,
          child: child,
        );

        // allow overriding
        return this._wrap(implProvided);
      },
    );
  }

  Widget build(Widget child) {
    return _wrap(child);
  }
}

/// This class should **not** be extended.
class _Provider<T> extends InheritedWidget {
  final T value;

  const _Provider({
    Key key,
    @required this.value,
    @required Widget child,
  })  : assert(value != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_Provider<T> old) => old.value != value;
}

String _typeToStr(Type t) {
  return '$t(#${t.hashCode})';
}

Type _type<T>() => T;
