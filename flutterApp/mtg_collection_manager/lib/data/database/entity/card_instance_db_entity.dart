/* This class represents the top level data in the program for representing a 
specific instance of a card from a given set, of a specific printing. It 
contains no stats. That information is held in the card_data table and is
loaded in the MtgCardDbEntity class. */

import 'dart:ffi';

class CardInstanceDbEntity {
  static const fieldMultiverseId = "multiverse_id";
  static const fieldCardName = "card_name";
  static const fieldSetCode = "set_code";
  static const fieldQuantity = "quantity";
  static const fieldReleasedAt = "released_at";

  static const fieldImageUriSmall = "image_uri_small";
  static const fieldImageUriNormal = "image_uri_normal";
  static const fieldImageUriLarge = "image_uri_large";
  static const fieldImageUriPng = "image_uri_png";
  static const fieldImageUriArtCrop = "image_uri_art_crop";
  static const fieldImageUriBorderCrop = "image_uri_border_crop";

  static const fieldImageLocalSmall = "image_local_small";
  static const fieldImageLocalNormal = "image_local_normal";
  static const fieldImageLocalLarge = "image_local_large";
  static const fieldImageLocalPng = "image_local_png";
  static const fieldImageLocalArtCrop = "image_local_art_crop";
  static const fieldImageLocalBorderCrop = "image_local_border_crop";

  final int multiverseId;
  final String name;
  final String setCode;
  final int quantity;
  final String releasedAt;

  final String imageUriSmall;
  final String imageUriNormal;
  final String imageUriLarge;
  final String imageUriPng;
  final String imageUriArtCrop;
  final String imageUriBorderCrop;

  final String imageLocalSmall;
  final String imageLocalNormal;
  final String imageLocalLarge;
  final String imageLocalPng;
  final String imageLocalArtCrop;
  final String imageLocalBorderCrop;

  const CardInstanceDbEntity({
    required this.multiverseId,
    required this.name,
    required this.setCode,
    required this.quantity,
    required this.releasedAt,
    required this.imageUriSmall,
    required this.imageUriNormal,
    required this.imageUriLarge,
    required this.imageUriPng,
    required this.imageUriArtCrop,
    required this.imageUriBorderCrop,
    required this.imageLocalSmall,
    required this.imageLocalNormal,
    required this.imageLocalLarge,
    required this.imageLocalPng,
    required this.imageLocalArtCrop,
    required this.imageLocalBorderCrop,
  });

  CardInstanceDbEntity.fromMap(Map<String, dynamic> map)
      : multiverseId = map[fieldMultiverseId] as int,
        name = map[fieldCardName] as String,
        setCode = map[fieldSetCode] as String,
        quantity = map[fieldQuantity] as int,
        releasedAt = map[fieldReleasedAt] as String,
        imageUriSmall = map[fieldImageUriSmall] as String,
        imageUriNormal = map[fieldImageUriNormal] as String,
        imageUriLarge = map[fieldImageUriLarge] as String,
        imageUriPng = map[fieldImageUriPng] as String,
        imageUriArtCrop = map[fieldImageUriArtCrop] as String,
        imageUriBorderCrop = map[fieldImageUriBorderCrop] as String,
        imageLocalSmall = map[fieldImageLocalSmall] as String,
        imageLocalNormal = map[fieldImageLocalNormal] as String,
        imageLocalLarge = map[fieldImageLocalLarge] as String,
        imageLocalPng = map[fieldImageLocalPng] as String,
        imageLocalArtCrop = map[fieldImageLocalArtCrop] as String,
        imageLocalBorderCrop = map[fieldImageLocalBorderCrop] as String;

  Map<String, dynamic> toMap() => {
        fieldMultiverseId: multiverseId,
        fieldCardName: name,
        fieldSetCode: setCode,
        fieldQuantity: quantity,
        fieldReleasedAt: releasedAt,
        fieldImageUriSmall: imageUriSmall,
        fieldImageUriNormal: imageUriNormal,
        fieldImageUriLarge: imageUriLarge,
        fieldImageUriPng: imageUriPng,
        fieldImageUriArtCrop: imageUriArtCrop,
        fieldImageUriBorderCrop: imageUriBorderCrop,
        fieldImageLocalSmall: imageLocalSmall,
        fieldImageLocalNormal: imageLocalNormal,
        fieldImageLocalLarge: imageLocalLarge,
        fieldImageLocalPng: imageLocalPng,
        fieldImageLocalArtCrop: imageLocalArtCrop,
        fieldImageLocalBorderCrop: imageLocalBorderCrop,
      };
}
