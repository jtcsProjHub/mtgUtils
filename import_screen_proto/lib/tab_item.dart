// Modified from https://codewithandrea.com/articles/multiple-navigators-bottom-navigation-bar/
import 'package:flutter/material.dart';
import './screens/collection_screen.dart';
import './screens/deck_overview_screen.dart';
import './screens/export_screen.dart';
import './screens/import_screen.dart';

enum TabItem { decks, collection, import, export }

const Map<TabItem, String> tabName = {
  TabItem.decks: 'Decks',
  TabItem.collection: 'Collection',
  TabItem.import: 'Import',
  TabItem.export: 'Export',
};

const Map<TabItem, IconData> tabIcons = {
  TabItem.decks: Icons.collections,
  TabItem.collection: Icons.list,
  TabItem.import: Icons.upload,
  TabItem.export: Icons.download,
};

const Map<TabItem, String> routeName = {
  TabItem.decks: '/Decks',
  TabItem.collection: '/Collection',
  TabItem.import: '/Import',
  TabItem.export: '/Export',
};

Map<TabItem, Widget> tabRootPages = {
  TabItem.decks: DeckOverviewScreen(
    deckPageRoute: routeName[TabItem.decks]!,
  ),
  TabItem.collection: CollectionScreen(
    collectionPageRoute: routeName[TabItem.collection]!,
  ),
  TabItem.import: ImportScreen(
    importPageRoute: routeName[TabItem.import]!,
  ),
  TabItem.export: ExportScreen(
    exportPageRoute: routeName[TabItem.export]!,
  ),
};
