import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class StreamWidget<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  const StreamWidget({
    Key key,
    @required Stream<T> stream,
    this.initialData,
  }) : super(key: key, stream: stream);

  /// The data that will be used to create the initial snapshot. Null by default.
  final T initialData;

  @override
  AsyncSnapshot<T> initial() =>
      new AsyncSnapshot<T>.withData(ConnectionState.none, initialData);

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return new AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error) {
    return new AsyncSnapshot<T>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> snapshot);
}
