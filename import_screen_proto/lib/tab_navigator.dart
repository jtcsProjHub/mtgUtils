import 'package:flutter/material.dart';
import 'tab_item.dart';

Widget routeErrorScreen() {
  return const Expanded(
      child: Center(
    child: Text(
      'Woops! Looks like there\'s a navigation error!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontSize: 20,
      ),
    ),
  ));
}

Widget welcomeScreen() {
  return const Expanded(
      child: Center(
    child: Text(
      'Welcome to Magic: The Managing! Use the sidebar to start!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontSize: 20,
      ),
    ),
  ));
}

class TabNavigatorRoutes {
  static final routeNames = List<String>.generate(
      TabItem.values.length, (index) => '/${tabName[TabItem.values[index]]}');
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    Map<String, WidgetBuilder> widgetMap = {
      for (var item in TabNavigatorRoutes.routeNames)
        item: (context) => tabRootPages[item] ?? routeErrorScreen()
    };
    widgetMap['/'] = (context) => welcomeScreen();
    return widgetMap;
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.routeNames.first,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
