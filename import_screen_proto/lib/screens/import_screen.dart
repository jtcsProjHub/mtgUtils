import 'package:flutter/material.dart';

class ImportScreen extends StatefulWidget {
  ImportScreen({
    super.key,
    required this.importPageRoute,
  });

  final String importPageRoute;

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Center(child: Text('I am the import screen')));
  }
}
