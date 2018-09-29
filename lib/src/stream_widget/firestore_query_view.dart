import 'package:app_base/app_base.dart';
import 'package:flutter/material.dart';
import 'package:typed_firestore/typed_firestore.dart';

abstract class QueryView<D extends DocData> extends StreamWidget<TypedQuerySnapshot<D>> {
  QueryView({
    Key key,
    @required TypedQuery<D> query,
  })  : assert(query != null),
        super(
          key: key,
          stream: query.snapshots(),
        );
}

typedef Widget FirestoreListItemBuilder<D extends DocData>(BuildContext context, DocSnapshot<D> doc, int index);

class FirestoreListView<D extends DocData> extends QueryView<D> {
  final FirestoreListItemBuilder<D> builder;

  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double cacheExtent;

  FirestoreListView({
    Key key,
    @required TypedQuery<D> query,
    @required this.builder,
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
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final docs = snapshot.data.docs;
    return ListView.builder(
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

abstract class DocView<D extends DocData> extends StreamWidget<DocSnapshot<D>> {
  DocView({
    Key key,
    @required DocRef<D> doc,
  })  : assert(doc != null),
        super(key: key, stream: doc.snapshots());
}

class DocBuilder<D extends DocData> extends DocView<D> {
  final FirestoreDocBuilder<D> builder;

  DocBuilder({
    Key key,
    @required DocRef<D> doc,
    @required this.builder,
  }) : super(key: key, doc: doc);

  @override
  Widget build(BuildContext context, AsyncSnapshot<DocSnapshot<D>> snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return builder(context, snapshot.data);
  }
}
