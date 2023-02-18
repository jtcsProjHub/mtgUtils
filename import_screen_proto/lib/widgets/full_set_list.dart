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
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
  }

  // Grabs the full MTG set list for display
  Future<PaginableList<MtgSet>> _mtgSetList() async {
    final setList = await _scryfallSingletonRef.apiClient.getAllSets();
    return setList;
  }

  // Actually builds out the scrollable list from the paginated set data
  Widget _buildListView(PaginableList<MtgSet> setData) {
    return Container(
        height: 500,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: setData.length,
          shrinkWrap: true,
          prototypeItem: ListTile(
              title: Row(
            children: [
              Text(setData.data.first.name),
              Text(setData.data.first.code)
            ],
          )),
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Text(setData.data[index].name),
                  Text(setData.data[index].code)
                ],
              ),
            );
          },
        ));
  }
}
