import 'package:flutter/material.dart';
import 'package:import_screen_proto/scryfall_singleton.dart';
import 'package:scryfall_api/scryfall_api.dart';

class FullSetList extends StatefulWidget {
  const FullSetList({super.key});

  @override
  State<FullSetList> createState() => _FullSetListState();
}

class _FullSetListState extends State<FullSetList> {
  final _scryfallSingletonRef = ScryfallSingleton();
  final ScrollController _controller = ScrollController();
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
    return Container(
        height: 500,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: _fullSetData.length,
          shrinkWrap: true,
          prototypeItem: ListTile(
              title: Row(
            children: [
              Text(_fullSetData.data.first.name),
              Text(_fullSetData.data.first.code)
            ],
          )),
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Text(_fullSetData.data[index].name),
                  Text(_fullSetData.data[index].code)
                ],
              ),
            );
          },
        ));
  }
}
