import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:import_screen_proto/scryfall_singleton.dart';
import 'package:scryfall_api/scryfall_api.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
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
  final MultiSelectController<String> _multiController =
      MultiSelectController();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.setUserPrefs(_selectedSetCodeStrings));
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

  Widget _buildListViewInitial(PaginableList<MtgSet> setData) {
    _fullSetData = setData;
    _fullSetDataCopy = _fullSetData;
    _items.addAll(_fullSetData.data);

    // Load these in the background once we fetch the list. That way we don't
    // hold up the user.
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
    _selectedSetCodeStrings = [];
    for (var set in _selectedSetCodes) {
      _selectedSetCodeStrings.add(set.code);
    }
    Widget scrollableList = Container(
        width: 500,
        child: Column(children: [
          const Text("MTG Sets to Select"),
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
          Expanded(
              child: MultiSelectCheckList(
            textStyles: const MultiSelectTextStyles(
                selectedTextStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            itemsDecoration: MultiSelectDecorations(
                selectedDecoration:
                    BoxDecoration(color: Colors.indigo.withOpacity(0.8))),
            listViewSettings: ListViewSettings(
                separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    )),
            controller: _multiController,
            items: List.generate(
                _items.length,
                (index) => CheckListCard(
                    value: index.toString(),
                    title: Text(_items[index].name),
                    subtitle: Text(_items[index].code),
                    selectedColor: Colors.white,
                    checkColor: Colors.indigo,
                    checkBoxBorderSide: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)))),
            onChange: (allSelectedItems, selectedItem) {
              setState(() {
                _selectedSets = allSelectedItems;
              });
            },
          ))
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
            itemCount: _selectedSets.length,
            shrinkWrap: true,
            prototypeItem: getMtgSetCard(_fullSetData.data.first, false),
            itemBuilder: (context, index) {
              return getMtgSetCard(
                  _fullSetData.data[int.parse(_selectedSets[index])], false);
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
        if (item.name.contains(query)) {
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
    return Card(
        child: ListTile(
            visualDensity: VisualDensity(vertical: 2),
            onTap: () {
              if (selectable) {
                doMultiSelectionMtgSet(mtgSet);
              }
            },
            hoverColor: Colors.indigo.withOpacity(0.8),
            title: Text(mtgSet.name),
            subtitle: Text(mtgSet.code),
            leading: Container(
              width: 50,
              height: 50,
              child: _setIcons[mtgSet.code],
            ),
            trailing: Visibility(
              visible: selectable,
              child: Icon(
                  _selectedSetCodes.contains(mtgSet)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 30,
                  color: Colors.indigo),
            )));
  }

  void doMultiSelectionMtgSet(MtgSet mtgSet) {}
}
