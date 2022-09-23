import 'package:flutter/material.dart';
import 'tab_navigator.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Magic: The Managing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
