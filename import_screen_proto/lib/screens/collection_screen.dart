import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  CollectionScreen({
    super.key,
    required this.collectionPageRoute,
  });

  final String collectionPageRoute;

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Center(child: Text('I am the collection screen')));
  }
}
