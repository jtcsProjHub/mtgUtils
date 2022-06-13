/* This class represents the data that comes from/goes to the local sqflite database. 
I'm sticking to using that as the database instead of something lighter weight like Hive 
because I want to do more than simple name: value storage and mangement. I'd like to be able to 
perform my searches using the database ultimately. Otherwise I'd have to load my entire collection
into memory everytime I launched the program, which is obviously not desireable. */

class MtgCardDbEntity {
  static const fieldName = 'card_name';
  static const fieldReleasedAt = 'released_at';
  static const fieldManaCost = 'mana_cost';
  static const fieldCmc = 'cmc';
  static const fieldTypeLine = 'type_line';
  static const fieldOracleText = 'oracle_text';
  static const fieldPower = 'power';
  static const fieldToughness = 'toughness';
  static const fieldColors = 'colors';
  static const fieldColorIdentity = 'color_identity';
  static const fieldLegalities = 'legalities';
  static const fieldImageUris = 'image_uris';
  static const fieldSetCode = 'set_code';
  static const fieldRarity = 'rarity';

  final String name;
  final String releasedAt;
  final String manaCost;
  final int convertedManaCost;
  final String typeLine;
  final String oracleText;
  final int power;
  final int toughness;
  final String colors;
  final String colorIdentity;
  final String legalities;
  final String imageUris;
  final String setCode;
  final String rarity;

  const MtgCardDbEntity({
    required this.name,
    required this.releasedAt,
    required this.manaCost,
    required this.convertedManaCost,
    required this.typeLine,
    required this.oracleText,
    required this.power,
    required this.toughness,
    required this.colors,
    required this.colorIdentity,
    required this.legalities,
    required this.imageUris,
    required this.setCode,
    required this.rarity,
  });

  MtgCardDbEntity.fromMap(Map<String, dynamic> map)
      : name = map[fieldName] as String,
        releasedAt = map[fieldReleasedAt] as String,
        manaCost = map[fieldManaCost] as String,
        convertedManaCost = map[fieldCmc] as int,
        typeLine = map[fieldTypeLine] as String,
        oracleText = map[fieldOracleText] as String,
        power = map[fieldPower] as int,
        toughness = map[fieldToughness] as int,
        colors = map[fieldColors] as String,
        colorIdentity = map[fieldColorIdentity] as String,
        legalities = map[fieldLegalities] as String,
        imageUris = map[fieldImageUris] as String,
        setCode = map[fieldSetCode] as String,
        rarity = map[fieldRarity] as String;

  Map<String, dynamic> toMap() => {
        fieldName: name,
        fieldReleasedAt: releasedAt,
        fieldManaCost: manaCost,
        fieldCmc: convertedManaCost,
        fieldTypeLine: typeLine,
        fieldOracleText: oracleText,
        fieldPower: power,
        fieldToughness: toughness,
        fieldColors: colors,
        fieldColorIdentity: colorIdentity,
        fieldLegalities: legalities,
        fieldImageUris: imageUris,
        fieldSetCode: setCode,
        fieldRarity: rarity,
      };
}
