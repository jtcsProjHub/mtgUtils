import 'package:scryfall_api/scryfall_api.dart';

class ScryfallSingleton {
  var apiClient = ScryfallApiClient();
  static final ScryfallSingleton _singleton = ScryfallSingleton._internal();

  factory ScryfallSingleton() {
    return _singleton;
  }

  // Realized that the client actually wants to be told to close
  dispose() {
    apiClient.close();
  }

  ScryfallSingleton._internal();
}
