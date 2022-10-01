import 'package:flutter/material.dart';
import 'tab_item.dart';
import 'dart:async';

// Used for limiting the size of the app, mainly so it can't get too small
import 'package:desktop_window/desktop_window.dart';

// Package name is self-descriptive
import 'package:side_navigation/side_navigation.dart';

final GlobalKey<NavigatorState> topLevelNavKey = GlobalKey();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: topLevelNavKey,
      title: 'Magic: The Managing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Magic: The Managing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(parentKey: key);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.parentKey});
  final Key? parentKey;
  int _sideBarPageIndex = 0;
  var _sideBarPageEnum = TabItem.decks;
  final _navigatorKeys = {
    for (var item in TabItem.values) item: GlobalKey<NavigatorState>()
  };

  Future<void> _setWindowConstraints() async {
    await DesktopWindow.setMinWindowSize(const Size(1920, 1080));
    await DesktopWindow.setMaxWindowSize(const Size(1920, 1080));
    await DesktopWindow.setWindowSize(const Size(1920, 1080));
  }

  @override
  void initState() {
    super.initState();
    _setWindowConstraints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          sideBarWidget(),
          Stack(
              children: List<Widget>.generate(TabItem.values.length,
                  (index) => _buildOffstageNavigator(TabItem.values[index]))),
        ],
      ),
    );
  }

  Widget sideBarWidget() {
    final navItems = List<SideNavigationBarItem>.generate(
        TabItem.values.length,
        (index) => SideNavigationBarItem(
            icon: tabIcons[TabItem.values[index]] ?? Icons.error,
            label: tabName[TabItem.values[index]] ?? 'Option Data Not Found'));
    return SideNavigationBar(
      selectedIndex: _sideBarPageIndex,
      items: navItems,
      onTap: (index) {
        setState(() {
          _sideBarPageIndex = index;
          _sideBarPageEnum = TabItem.values[index];
        });
      },
      initiallyExpanded: true,
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _sideBarPageEnum != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem] ?? topLevelNavKey,
        tabItem: tabItem,
      ),
    );
  }
} // HomePage
