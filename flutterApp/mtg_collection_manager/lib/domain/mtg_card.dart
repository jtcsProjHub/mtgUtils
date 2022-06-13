Map<String, bool> legalityMap = {
  "standard": false,
  "future": false,
  "historic": false,
  "gladiator": false,
  "pioneer": false,
  "modern": false,
  "legacy": false,
  "pauper": false,
  "vintage": false,
  "penny": false,
  "commander": false,
  "brawl": false,
  "historicbrawl": false,
  "alchemy": false,
  "paupercommander": false,
  "duel": false,
  "oldschool": false,
  "premodern": false
};

class CardVariation {
  String setId;
  String collectorId;
  int quantity;

  CardVariation(
      {required this.setId, required this.collectorId, required this.quantity});
}

class MtgCard {
  final String name;
  final String type;
  final String oracleText;

  final String manaCost;
  final int convertedManaCost;
  final List<String> colors;
  final List<String> colorIndicator;
  final List<String> colorIdentity;

  final int power;
  final int toughness;

  final Map<String, bool> legalities;
  List<CardVariation> variationsOwned = List.empty();

  MtgCard(
      {required this.name,
      required this.type,
      required this.oracleText,
      required this.manaCost,
      required this.convertedManaCost,
      required this.colors,
      required this.colorIdentity,
      required this.colorIndicator,
      required this.power,
      required this.toughness,
      required this.legalities});
}
