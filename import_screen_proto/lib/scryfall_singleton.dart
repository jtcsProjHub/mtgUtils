import 'package:scryfall_api/scryfall_api.dart';

class ScryfallSingleton {
  var apiClient = ScryfallApiClient();
  static final ScryfallSingleton _singleton = ScryfallSingleton._internal();

  factory ScryfallSingleton() {
    return _singleton;
  }

  ScryfallSingleton._internal();
}
