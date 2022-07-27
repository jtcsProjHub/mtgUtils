/* This class holds the set data information. It's just a couple of basics that
would end up having to get repeated a number of times if we didn't just
store it once here */

import 'dart:ffi';

class SetDbEntity {
  static const fieldSetCode = "set_code";
  static const fieldSetName = "set_name";
  static const fieldScryfallUri = "scryfall_uri";
  static const fieldReleasedAt = "released_at";
  static const fieldIconSvgUri = "icon_svg_uri";
  static const fieldIconSvgLocalPath = "icon_svg_local_path";

  final String setCode;
  final String setName;
  final String scryfallUri;
  final String releasedAt;
  final String iconSvgUri;
  final String iconSvgLocalPath;

  const SetDbEntity({
    required this.setCode,
    required this.setName,
    required this.scryfallUri,
    required this.releasedAt,
    required this.iconSvgUri,
    required this.iconSvgLocalPath,
  });

  SetDbEntity.fronMap(Map<String, dynamic> map)
      : setCode = map[fieldSetCode] as String,
        setName = map[fieldSetName] as String,
        scryfallUri = map[fieldScryfallUri] as String,
        releasedAt = map[fieldReleasedAt] as String,
        iconSvgUri = map[fieldIconSvgUri] as String,
        iconSvgLocalPath = map[fieldIconSvgLocalPath] as String;

  Map<String, dynamic> toMap() => {
        fieldSetCode: setCode,
        fieldSetName: setName,
        fieldScryfallUri: scryfallUri,
        fieldReleasedAt: releasedAt,
        fieldIconSvgUri: iconSvgUri,
        fieldIconSvgLocalPath: iconSvgLocalPath,
      };
}
