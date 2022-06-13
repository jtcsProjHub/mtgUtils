// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mtg_card_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MtgCardListResponse _$MtgCardListResponseFromJson(Map<String, dynamic> json) =>
    MtgCardListResponse(
      object: json['object'] as String,
      totalCards: json['total_cards'] as int,
      hasMore: json['has_more'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => MtgCardEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MtgCardListResponseToJson(
        MtgCardListResponse instance) =>
    <String, dynamic>{
      'object': instance.object,
      'total_cards': instance.totalCards,
      'has_more': instance.hasMore,
      'data': instance.data,
    };

ColorsEntity _$ColorsEntityFromJson(Map<String, dynamic> json) => ColorsEntity(
      colors:
          (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ColorsEntityToJson(ColorsEntity instance) =>
    <String, dynamic>{
      'colors': instance.colors,
    };

ColorIdentityEntity _$ColorIdentityEntityFromJson(Map<String, dynamic> json) =>
    ColorIdentityEntity(
      colorIdentity: (json['color_identity'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ColorIdentityEntityToJson(
        ColorIdentityEntity instance) =>
    <String, dynamic>{
      'color_identity': instance.colorIdentity,
    };

LegalitiesEntity _$LegalitiesEntityFromJson(Map<String, dynamic> json) =>
    LegalitiesEntity(
      legalitites: Map<String, String>.from(json['legalitites'] as Map),
    );

Map<String, dynamic> _$LegalitiesEntityToJson(LegalitiesEntity instance) =>
    <String, dynamic>{
      'legalitites': instance.legalitites,
    };

ImageUriEntity _$ImageUriEntityFromJson(Map<String, dynamic> json) =>
    ImageUriEntity(
      imageUris: Map<String, String>.from(json['image_uris'] as Map),
    );

Map<String, dynamic> _$ImageUriEntityToJson(ImageUriEntity instance) =>
    <String, dynamic>{
      'image_uris': instance.imageUris,
    };

MtgCardEntity _$MtgCardEntityFromJson(Map<String, dynamic> json) =>
    MtgCardEntity(
      name: json['name'] as String,
      releasedAt: json['released_at'] as String,
      manaCost: json['mana_cost'] as String,
      convertedManaCost: json['cmc'] as int,
      typeLine: json['type_line'] as String,
      oracleText: json['oracle_text'] as String,
      power: json['power'] as int,
      toughness: json['toughness'] as int,
      colors: ColorsEntity.fromJson(json['colors'] as Map<String, dynamic>),
      colorIdentity: ColorIdentityEntity.fromJson(
          json['color_identity'] as Map<String, dynamic>),
      legalities:
          LegalitiesEntity.fromJson(json['legalities'] as Map<String, dynamic>),
      imageUris:
          ImageUriEntity.fromJson(json['image_uris'] as Map<String, dynamic>),
      setCode: json['set'] as String,
      rarity: json['rarity'] as String,
    );

Map<String, dynamic> _$MtgCardEntityToJson(MtgCardEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'released_at': instance.releasedAt,
      'mana_cost': instance.manaCost,
      'cmc': instance.convertedManaCost,
      'type_line': instance.typeLine,
      'oracle_text': instance.oracleText,
      'power': instance.power,
      'toughness': instance.toughness,
      'colors': instance.colors.toJson(),
      'color_identity': instance.colorIdentity.toJson(),
      'legalities': instance.legalities.toJson(),
      'image_uris': instance.imageUris.toJson(),
      'set': instance.setCode,
      'rarity': instance.rarity,
    };
