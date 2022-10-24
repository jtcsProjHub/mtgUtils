import 'package:flutter/material.dart';
import 'package:import_screen_proto/scryfall_singleton.dart';

class FullSetList extends StatefulWidget {
  const FullSetList({super.key});

  @override
  State<FullSetList> createState() => _FullSetListState();
}

class _FullSetListState extends State<FullSetList> {
  var scryfallSingletonRef = ScryfallSingleton();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Yeah...I'm a screen.");
  }
}
