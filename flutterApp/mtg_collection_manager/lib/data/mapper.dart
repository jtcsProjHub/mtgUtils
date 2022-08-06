import 'package:mtg_collection_manager/data/database/entity/mtg_card_db_entity.dart';
import 'package:mtg_collection_manager/data/network/entity/mtg_card_entity.dart';
import 'package:mtg_collection_manager/domain/mtg_card.dart';

/* This file is going to have to diverge from the example a bit more than the others.
The main reason for me is that I want the data flow and relationships to be a 
bit different than the example. To me, the concrete class MtgCard is going to 
be the local class that is used for showing card information to a user. There are
fields that aren't needed by that class, but which are needed occassionally by
the program. 

I don't intend on there being a flow directly from API to local instance. I intend 
on the API creating a DB entity, and then working between that and the local
instance, along with whatever other classes are needed. There are going to
end up being multiple DB tables anyway. So my implementation is going to end up
with a different structure and mapping layer than the example I followed. */

class MapperException<From, To> implements Exception {
  final String message;

  const MapperException(this.message);

  @override
  String toString() {
    return 'Error when mapping class $From to $To: $message}';
  }
}

class Mapper {
  MtgCard toCard(MtgCardEntity entity) {
    try {
      return MtgCard(
        name: entity.name,
        convertedManaCost: entity.convertedManaCost,
        oracleText: entity.oracleText,
        power: entity.power,
        toughness: entity.toughness,
        type: entity.typeLine,
        colorIdentity: entity.colorIdentity,
        colorIndicator: entity.colorIdentity,
        colors: entity.colors,
        legalities: entity.legalities,
        manaCost: entity.manaCost,
      );
    } catch (e) {
      throw MapperException<MtgCardEntity, MtgCard>(e.toString());
    }
  }

  List<MtgCard> toMtgCard(List<MtgCardEntity> entities) {
    final List<MtgCard> cards = [];

    for (final entity in entities) {
      cards.add(toMtgCard(entity));
    }

    return cards;
  }

  MtgCard toCardFromDb(MtgCardDbEntity entity) {
    try {
      return MtgCard(
        name: entity.name,
        convertedManaCost: entity.convertedManaCost,
        oracleText: entity.oracleText,
        power: entity.power,
        toughness: entity.toughness,
        type: entity.typeLine,
        colorIdentity: entity.colorIdentity,
        colorIndicator: entity.colorIdentity,
        colors: entity.colors,
        legalities: entity.legalities,
        manaCost: entity.manaCost,
      );
    } catch (e) {
      throw MapperException<MtgCardDbEntity, MtgCard>(e.toString());
    }
  }

  List<MtgCard> toRecipesFromDb(List<MtgCardDbEntity> entities) {
    final List<MtgCard> cards = [];

    for (final entity in entities) {
      cards.add(toRecipeFromDb(entity));
    }

    return cards;
  }

  MtgCardDbEntity toRecipeDbEntity(MtgCard card) {
    try {
      return MtgCardDbEntity(
        name: card.name,
        colorIdentity: card.colorIdentity,
        colors: card.colors,
        convertedManaCost: card.convertedManaCost,
        imageUris: 
      );
    } catch (e) {
      throw MapperException<MtgCard, MtgCardDbEntity>(e.toString());
    }
  }

  List<RecipeDbEntity> toRecipesDbEntity(List<Recipe> entities) {
    final List<RecipeDbEntity> list = [];

    for (final entity in entities) {
      list.add(toRecipeDbEntity(entity));
    }

    return list;
  }
}
