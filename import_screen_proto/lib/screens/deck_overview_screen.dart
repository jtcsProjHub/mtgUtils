import 'package:flutter/material.dart';

class DeckOverviewScreen extends StatefulWidget {
  const DeckOverviewScreen({super.key});

  @override
  State<DeckOverviewScreen> createState() => _DeckOverviewScreenState();
}

class _DeckOverviewScreenState extends State<DeckOverviewScreen> {
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
