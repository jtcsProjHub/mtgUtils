import 'package:flutter/material.dart';

class DeckOverviewScreen extends StatefulWidget {
  DeckOverviewScreen({
    super.key,
    required this.deckPageRoute,
  });

  final String deckPageRoute;

  @override
  State<DeckOverviewScreen> createState() => _DeckOverviewScreenState();
}

class _DeckOverviewScreenState extends State<DeckOverviewScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Center(child: Text('I am the deck overview screen')));
  }
}
