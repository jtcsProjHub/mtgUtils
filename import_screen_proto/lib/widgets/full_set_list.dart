import 'package:flutter/material.dart';
import 'package:import_screen_proto/scryfall_singleton.dart';
import 'package:scryfall_api/scryfall_api.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class FullSetList extends StatefulWidget {
  const FullSetList({super.key});

  @override
  State<FullSetList> createState() => _FullSetListState();
}

class _FullSetListState extends State<FullSetList> {
  final _scryfallSingletonRef = ScryfallSingleton();
  final MultiSelectController<String> _controller = MultiSelectController();
  PaginableList<MtgSet> _fullSetData = PaginableList(data: [], hasMore: false);

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

  // Actually builds out the scrollable list from the paginated set data
  Widget _buildListView(PaginableList<MtgSet> setData) {
    _fullSetData = setData;
    Widget scrollableList = Container(
      height: 500,
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
        controller: _controller,
        items: List.generate(
            _fullSetData.length,
            (index) => CheckListCard(
                value: _fullSetData[index].id,
                title: Text(_fullSetData[index].name),
                subtitle: Text(_fullSetData[index].code),
                selectedColor: Colors.white,
                checkColor: Colors.indigo,
                checkBoxBorderSide: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
        onChange: (allSelectedItems, selectedItem) {},
      ),
    );

    return scrollableList;
  }
}
