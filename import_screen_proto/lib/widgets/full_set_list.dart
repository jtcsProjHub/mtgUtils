import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:import_screen_proto/scryfall_singleton.dart';
import 'package:scryfall_api/scryfall_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullSetList extends StatefulWidget {
  FullSetList({super.key, required this.setUserPrefs});

  Function setUserPrefs;

  @override
  State<FullSetList> createState() => _FullSetListState();
}

class _FullSetListState extends State<FullSetList> {
  // Abstraction of the Scryfall API class so we don't open multiple connections
  final _scryfallSingletonRef = ScryfallSingleton();

  // All of the different widget controllers we need for this widget
  final ScrollController _multiController = ScrollController();
  final ScrollController _controller = ScrollController();
  TextEditingController editingController = TextEditingController();

  // Placeholder that we'll dump the full MTG set list into once we get it from Scryfall
  PaginableList<MtgSet> _fullSetData = PaginableList(data: [], hasMore: false);

  // Copy and utility data that we'll need for the dynamic search filter capability
  PaginableList<MtgSet> _fullSetDataCopy =
      PaginableList(data: [], hasMore: false);
  List<MtgSet> _items = [];

  // These are going to be strings of the indices. Easier that way.
  List<String> _selectedSets = [];
  HashSet<MtgSet> _selectedSetCodes = HashSet<MtgSet>();
  List<String> _selectedSetCodeStrings = [];
  Map<String, SvgPicture> _setIcons = Map<String, SvgPicture>();

  // Some common styles that we want to just define up top.
  var listTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
  var selectedTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  var selectedColor = Colors.indigo.withOpacity(0.8);
  var hoverColor = Colors.indigo.withOpacity(0.2);
  var nominalTileColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Sync functional tie-in with the widget that own this one. Everytime a
    //user select a set we rebuild, so after each build we send the data their way.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.setUserPrefs(_selectedSetCodeStrings));

    // Only fetch data if we don't have a local copy of it.
    if (_fullSetData.data.isEmpty) {
      return FutureBuilder(
          future: _mtgSetList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator()));
              default:
                if (snapshot.hasError) {
                  return Container();
                } else {
                  // The first time we grab the data, there are some local data
                  // stores that we need to initialize. Some of them were
                  //declared up-top as 'late' so we better get to them.
                  return _buildListViewInitial(snapshot.data);
                }
            }
          });
    } else {
      return _buildListView(_fullSetData);
    }
  }

  // Grabs the full MTG set list for display
  Future<PaginableList<MtgSet>> _mtgSetList() async {
    final setList = await _scryfallSingletonRef.apiClient.getAllSets();
    return setList;
  }

  // Called only when we first get the full set list.
  Widget _buildListViewInitial(PaginableList<MtgSet> setData) {
    _fullSetData = setData;
    _fullSetDataCopy = _fullSetData;
    _items.addAll(_fullSetData.data);

    // Load the set icons in the background once we fetch the list. That way we
    // don't hold up the user and can use them throughout the widget without
    // reloading them.
    for (var set in _items) {
      String setCode = set.code;
      String iconUri = set.iconSvgUri.origin + set.iconSvgUri.path;
      _setIcons[setCode] = SvgPicture.network(iconUri,
          semanticsLabel: "$setCode icon",
          placeholderBuilder: (BuildContext context) =>
              const CircularProgressIndicator());
    }
    return _buildListView(setData);
  }

  // Actually builds out the scrollable list of all sets from the paginated set data
  Widget _buildListView(PaginableList<MtgSet> setData) {
    // Populate out list of set codes that have been selected so far
    _selectedSetCodeStrings = [];
    for (var set in _selectedSetCodes) {
      _selectedSetCodeStrings.add(set.code);
    }

    // List ofsets for the user to select from. Includes text filter box.
    Widget scrollableList = Container(
        width: 500,
        child: Column(children: [
          const Text("MTG Sets to Select"),
          // Search box for filtering sets to select
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          // Actual list of sets, filtered based on user input from search field
          Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _multiController,
                  itemCount: _items.length,
                  shrinkWrap: true,
                  prototypeItem: getMtgSetCard(_fullSetData.data.first, true),
                  itemBuilder: (context, index) {
                    return getMtgSetCard(_items[index], true);
                  }))
        ]));

    // Scrollable list of the sets that you selected
    Widget selectedSetsList = Container(
        width: 500,
        child: Column(children: [
          const Text("Selected Sets"),
          Expanded(
              child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            itemCount: _selectedSetCodes.length,
            shrinkWrap: true,
            prototypeItem: getMtgSetCard(_fullSetData.data.first, false),
            itemBuilder: (context, index) {
              return getMtgSetCard(_selectedSetCodes.toList()[index], false);
            },
          ))
        ]));

    // Simple divider between the lists.
    Widget divider = const VerticalDivider(
      width: 20,
      thickness: 5,
      indent: 20,
      endIndent: 0,
      color: Colors.black,
    );

    // Side-by-side composition of the list of all sets and the selected sets
    Widget limitToSetsPanel = Row(
      children: [scrollableList, divider, selectedSetsList],
    );

    return limitToSetsPanel;
  } // end buildListView

  void filterSearchResults(String query) {
    List<MtgSet> dummySearchList = [];
    dummySearchList.addAll(_fullSetDataCopy.data);
    if (query.isNotEmpty) {
      List<MtgSet> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        _items.clear();
        _items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _items.clear();
        _items.addAll(_fullSetDataCopy.data);
      });
    }
  }

  Widget getMtgSetCard(MtgSet mtgSet, bool selectable) {
    bool isSelected = selectable && _selectedSetCodes.contains(mtgSet);
    return Material(
        child: Card(
            child: ListTile(
      onTap: () {
        doMultiSelectionMtgSet(mtgSet);
      },
      selected: isSelected,
      selectedColor: selectedColor,
      hoverColor: hoverColor,
      tileColor: nominalTileColor,
      textColor: Colors.black,
      title: Text(
        mtgSet.name,
        style: isSelected ? selectedTextStyle : listTextStyle,
      ),
      subtitle: Text(
        mtgSet.code,
        style: isSelected ? selectedTextStyle : listTextStyle,
      ),
      leading: Container(
        width: 50,
        height: 50,
        child: _setIcons[mtgSet.code],
      ),
      trailing: selectable
          ? Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 30, color: Colors.indigo)
          : const Icon(Icons.delete),
    )));
  }

  void doMultiSelectionMtgSet(MtgSet mtgSet) {
    setState(() {
      if (_selectedSetCodes.contains(mtgSet)) {
        _selectedSetCodes.remove(mtgSet);
      } else {
        _selectedSetCodes.add(mtgSet);
      }
    });
  }
}
