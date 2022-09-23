// Modified from https://codewithandrea.com/articles/multiple-navigators-bottom-navigation-bar/
import 'package:flutter/material.dart';

enum TabItem { decks, collection, import, export }

const Map<TabItem, String> tabName = {
  TabItem.decks: 'Decks',
  TabItem.collection: 'Collection',
  TabItem.import: 'Import',
  TabItem.export: 'Export'
};

const Map<TabItem, IconData> tabIcons = {
  TabItem.decks: Icons.collections,
  TabItem.collection: Icons.list,
  TabItem.import: Icons.upload,
  TabItem.export: Icons.download
};
