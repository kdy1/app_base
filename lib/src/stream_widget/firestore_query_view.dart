import 'package:app_base/app_base.dart';
import 'package:flutter/material.dart';
import 'package:typed_firestore/typed_firestore.dart';

abstract class StreamingQueryView<D extends DocData> extends StreamWidget<TypedQuerySnapshot<D>> {
  StreamingQueryView({
    Key key,
    @required TypedQuery<D> query,
  })  : assert(query != null),
        super(
          key: key,
          stream: query.snapshots(),
        );
}

class FirestoreStreamingListView<D extends DocData> extends StreamingQueryView<D> {
  final FirestoreListItemBuilder<D> builder;
  final WidgetBuilder empty;
  final ErrorRenderer errorHandler;

  final ScrollController controller;
  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double cacheExtent;

  FirestoreStreamingListView({
    Key key,
    @required TypedQuery<D> query,
    @required this.builder,
    this.controller,
    this.empty,
    this.errorHandler,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.cacheExtent,
  }) : super(key: key, query: query);

  @override
  Widget build(BuildContext context, AsyncSnapshot<TypedQuerySnapshot<D>> snapshot) {
    if (snapshot.hasError && errorHandler != null) {
      return errorHandler(snapshot.error);
    }

    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final docs = snapshot.data.docs;
    if (docs.isEmpty && empty != null) {
      return Builder(builder: empty);
    }
    return ListView.builder(
      controller: controller,
      scrollDirection: scrollDirection,
      padding: padding,
      physics: physics,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      cacheExtent: cacheExtent,
      primary: primary,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      itemCount: docs.length,
      itemBuilder: (BuildContext context, int index) {
        return builder(context, docs[index], index);
      },
    );
  }
}

typedef Widget FirestoreDocBuilder<D extends DocData>(BuildContext context, DocSnapshot<D> doc);

abstract class StreamingDocView<D extends DocData> extends StreamWidget<DocSnapshot<D>> {
  StreamingDocView({
    Key key,
    @required DocRef<D> doc,
  })  : assert(doc != null),
        super(key: key, stream: doc.snapshots());
}

class StreamingDocBuilder<D extends DocData> extends StreamingDocView<D> {
  final FirestoreDocBuilder<D> builder;
  final Widget loading;

  StreamingDocBuilder({
    Key key,
    @required DocRef<D> doc,
    this.loading,
    @required this.builder,
  }) : super(key: key, doc: doc);

  @override
  Widget build(BuildContext context, AsyncSnapshot<DocSnapshot<D>> snapshot) {
    if (snapshot.connectionState == ConnectionState.none) {
      if (loading != null) return loading;
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return builder(context, snapshot.data);
  }
}
