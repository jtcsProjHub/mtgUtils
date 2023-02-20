import 'package:flutter/material.dart';
import 'package:import_screen_proto/scryfall_singleton.dart';
import 'package:scryfall_api/scryfall_api.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullSetList extends StatefulWidget {
  FullSetList({super.key});

  @override
  State<FullSetList> createState() => _FullSetListState();
}

class _FullSetListState extends State<FullSetList> {
  final _scryfallSingletonRef = ScryfallSingleton();
  final MultiSelectController<String> _multiController =
      MultiSelectController();
  final ScrollController _controller = ScrollController();
  PaginableList<MtgSet> _fullSetData = PaginableList(data: [], hasMore: false);

  // These are going to be strings of the indices. Easier that way.
  List<String> _selectedSets = [];
  List<String> selectedSetCodes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  return _buildListView(snapshot.data);
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

  // Actually builds out the scrollable list of all sets from the paginated set data
  Widget _buildListView(PaginableList<MtgSet> setData) {
    _fullSetData = setData;
    selectedSetCodes = [];

    Widget scrollableList = Container(
        height: 400,
        width: 400,
        child: MultiSelectCheckList(
          textStyles: const MultiSelectTextStyles(
              selectedTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          itemsDecoration: MultiSelectDecorations(
              selectedDecoration:
                  BoxDecoration(color: Colors.indigo.withOpacity(0.8))),
          listViewSettings: ListViewSettings(
              separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  )),
          controller: _multiController,
          items: List.generate(
              _fullSetData.length,
              (index) => CheckListCard(
                  value: index.toString(),
                  title: Text(_fullSetData[index].name),
                  subtitle: Text(_fullSetData[index].code),
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
        ));

    // Scrollable list of the sets that you selected
    Widget selectedSetsList = Container(
        height: 500,
        width: 500,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: _selectedSets.length,
          shrinkWrap: true,
          prototypeItem: ListTile(
              title: Row(
            children: [
              Text(_fullSetData.data.first.name),
              Text(_fullSetData.data.first.code)
            ],
          )),
          itemBuilder: (context, index) {
            String setCode =
                _fullSetData.data[int.parse(_selectedSets[index])].code;
            String iconUri = _fullSetData
                    .data[int.parse(_selectedSets[index])].iconSvgUri.origin +
                _fullSetData
                    .data[int.parse(_selectedSets[index])].iconSvgUri.path;
            selectedSetCodes.add(setCode);
            return ListTile(
                title: Text(
                    _fullSetData.data[int.parse(_selectedSets[index])].name),
                subtitle: Text(setCode),
                trailing: Container(
                  width: 20,
                  height: 20,
                  child: SvgPicture.network(iconUri,
                      semanticsLabel: "$setCode icon",
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator()),
                ));
          },
        ));

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
  }
}
