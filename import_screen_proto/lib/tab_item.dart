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

const Map<TabItem, Widget> tabRootPages = {
  TabItem.decks: DeckOverviewScreen(),
  TabItem.collection: CollectionScreen(),
  TabItem.import: ImportScreen(),
  TabItem.export: ExportScreen(),
};

const Map<TabItem, String> routeName = {
  TabItem.decks: '/',
  TabItem.collection: '/Collection',
  TabItem.import: '/Import',
  TabItem.export: '/Export',
};
