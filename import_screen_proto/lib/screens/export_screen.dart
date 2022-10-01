import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  ExportScreen({
    super.key,
    required this.exportPageRoute,
  });

  final String exportPageRoute;

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Center(child: Text('I am the export screen')));
  }
}
