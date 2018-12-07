import 'package:app_base/app_base.dart';
import 'package:flutter/material.dart';
import 'package:typed_firestore/typed_firestore.dart';

abstract class QueryView<D extends DocData> extends StatelessWidget {
  final TypedQuery<D> query;
  QueryView({
    Key key,
    @required this.query,
  })  : assert(query != null),
        super(
          key: key,
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
  Widget build(BuildContext context) {
    return new FutureBuilder<TypedQuerySnapshot<D>>(
        future: query.getDocs(),
        builder: (BuildContext context, AsyncSnapshot<TypedQuerySnapshot<D>> snapshot) {
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
        });
  }
}

abstract class DocView<D extends DocData> extends StatelessWidget {
  final DocRef<D> doc;
  DocView({
    Key key,
    @required this.doc,
  })  : assert(doc != null),
        super(key: key);
}

class DocBuilder<D extends DocData> extends DocView<D> {
  final FirestoreDocBuilder<D> builder;
  final Widget loading;

  DocBuilder({
    Key key,
    @required DocRef<D> doc,
    this.loading,
    @required this.builder,
  }) : super(key: key, doc: doc);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: doc.get(),
      builder: (BuildContext context, AsyncSnapshot<DocSnapshot<D>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          if (loading != null) return loading;
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return builder(context, snapshot.data);
      },
    );
  }
}
