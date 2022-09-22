import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './screens/collection_screen.dart';
import './screens/deck_overview_screen.dart';
import './screens/export_screen.dart';
import './screens/import_screen.dart';
import 'dart:async';

// Used for limiting the size of the app, mainly so it can't get too small
import 'package:desktop_window/desktop_window.dart';

// Package name is self-descriptive
import 'package:side_navigation/side_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _sideBarPageIndex = -1;

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
          Expanded(child: defaultStartScreen()),
        ],
      ),
    );
  }

  Widget sideBarWidget() {
    return SideNavigationBar(
      selectedIndex: _sideBarPageIndex,
      items: const [
        SideNavigationBarItem(
          icon: Icons.collections,
          label: 'Decks',
        ),
        SideNavigationBarItem(
          icon: Icons.list,
          label: 'Collection',
        ),
        SideNavigationBarItem(
          icon: Icons.upload,
          label: 'Import',
        ),
        SideNavigationBarItem(
          icon: Icons.download,
          label: 'Export',
        ),
      ],
      onTap: (index) {
        setState(() {
          _sideBarPageIndex = index;
        });
      },
      initiallyExpanded: true,
    );
  }

  Widget defaultStartScreen() {
    return Navigator(
      pages: [
        MaterialPage(child: welcomeScreen()),
        if (_sideBarPageIndex == 2) const MaterialPage(child: ImportScreen())
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }

  Widget welcomeScreen() {
    return const Expanded(
        child: Center(
      child: Text(
        'Welcome to Magic: The Managing! Select options from the sidebar!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontSize: 20,
        ),
      ),
    ));
  }
} // HomePage

// Widget from this kind soul on StackOverflow:
// https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget/60868972#60868972
// This was much easier than trying to do a Notification Listener on a resize and then
// doing future calls for the window size library that I was trying to use.
typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
