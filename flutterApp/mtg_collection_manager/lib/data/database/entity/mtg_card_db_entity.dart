/* This class represents the data that comes from/goes to the local sqflite database. 
I'm sticking to using that as the database instead of something lighter weight like Hive 
because I want to do more than simple name: value storage and mangement. I'd like to be able to 
perform my searches using the database ultimately. Otherwise I'd have to load my entire collection
into memory everytime I launched the program, which is obviously not desireable. 

The specific object here represents the programs representation of a cards raw stats.
Specific instances that we have from a specific set or certain printing are in a different class. */

import 'dart:ffi';

class MtgCardDbEntity {
  static const fieldName = 'card_name';
  static const fieldManaCost = 'mana_cost';
  static const fieldColors = 'colors';
  static const fieldColorIdentity = 'color_identity';
  static const fieldCmc = 'cmc';
  static const fieldPower = 'power';
  static const fieldToughness = 'toughness';
  static const fieldProducedMana = 'produced_mana';
  static const fieldTypeLine = 'type_line';
  static const fieldOracleText = 'oracle_text';
  static const fieldRarity = 'rarity';
  static const fieldRulings = 'rulings';

  // I thought about it for a while, and realistically these need to be
  // separate columns in the DB because I can't actually search within
  // JSON as part of a query for SQLite. Since filtering by format is
  // so common, it made sense for each format legality to be its own
  // column then.
  static const fieldLegalStandard = "legal_standard";
  static const fieldLegalFuture = "legal_future";
  static const fieldLegalHistoric = "legal_historic";
  static const fieldLegalGladiator = "legal_gladiator";
  static const fieldLegalPioneer = "legal_pioneer";
  static const fieldLegalExplorer = "legal_explorer";
  static const fieldLegalModern = "legal_modern";
  static const fieldLegalLegacy = "legal_legacy";
  static const fieldLegalPauper = "legal_pauper";
  static const fieldLegalVintage = "legal_vintage";
  static const fieldLegalPenny = "legal_penny";
  static const fieldLegalCommander = "legal_commander";
  static const fieldLegalBrawl = "legal_brawl";
  static const fieldLegalHistoricBrawl = "legal_historicbrawl";
  static const fieldLegalAlchemy = "legal_alchemy";
  static const fieldLegalPauperCommander = "legal_paupercommander";
  static const fieldLegalDuel = "legal_duel";
  static const fieldLegalOldSchool = "legal_oldschool";
  static const fieldLegalPremodern = "legal_premodern";

  final String name;
  final String manaCost;
  final String colors;
  final String colorIdentity;
  final int convertedManaCost;
  final int power;
  final int toughness;
  final String producedMana;
  final String typeLine;
  final String oracleText;
  final String rarity;
  final String rulings;

  // Spent a while trying to figure out how to make this stupidly long list
  // of formats into a map<String, Bool>, but the conversion functions
  // below toMap and fromMap really didn't like that. After some failed
  // Google searches, well, we'll just do it this silly way for now
  // and move on.
  final Bool legalStandard;
  final Bool legalFuture;
  final Bool legalHistoric;
  final Bool legalGladiator;
  final Bool legalPioneer;
  final Bool legalExplorer;
  final Bool legalModern;
  final Bool legalLegacy;
  final Bool legalPauper;
  final Bool legalVintage;
  final Bool legalPenny;
  final Bool legalCommander;
  final Bool legalBrawl;
  final Bool legalHistoricBrawl;
  final Bool legalAlchemy;
  final Bool legalPauperCommander;
  final Bool legalDuel;
  final Bool legalOldSchool;
  final Bool legalPremodern;

  const MtgCardDbEntity({
    required this.name,
    required this.colors,
    required this.colorIdentity,
    required this.manaCost,
    required this.convertedManaCost,
    required this.power,
    required this.toughness,
    required this.producedMana,
    required this.typeLine,
    required this.oracleText,
    required this.rarity,
    required this.rulings,
    required this.legalStandard,
    required this.legalFuture,
    required this.legalHistoric,
    required this.legalGladiator,
    required this.legalPioneer,
    required this.legalExplorer,
    required this.legalModern,
    required this.legalLegacy,
    required this.legalPauper,
    required this.legalVintage,
    required this.legalPenny,
    required this.legalCommander,
    required this.legalBrawl,
    required this.legalHistoricBrawl,
    required this.legalAlchemy,
    required this.legalPauperCommander,
    required this.legalDuel,
    required this.legalOldSchool,
    required this.legalPremodern,
  });

  MtgCardDbEntity.fromMap(Map<String, dynamic> map)
      : name = map[fieldName] as String,
        manaCost = map[fieldManaCost] as String,
        convertedManaCost = map[fieldCmc] as int,
        typeLine = map[fieldTypeLine] as String,
        oracleText = map[fieldOracleText] as String,
        power = map[fieldPower] as int,
        toughness = map[fieldToughness] as int,
        colors = map[fieldColors] as String,
        colorIdentity = map[fieldColorIdentity] as String,
        producedMana = map[fieldProducedMana] as String,
        rulings = map[fieldRulings] as String,
        rarity = map[fieldRarity] as String,
        legalStandard = map[fieldLegalStandard] as Bool,
        legalFuture = map[fieldLegalFuture] as Bool,
        legalHistoric = map[fieldLegalHistoric] as Bool,
        legalGladiator = map[fieldLegalGladiator] as Bool,
        legalPioneer = map[fieldLegalPioneer] as Bool,
        legalExplorer = map[fieldLegalExplorer] as Bool,
        legalModern = map[fieldLegalModern] as Bool,
        legalLegacy = map[fieldLegalLegacy] as Bool,
        legalPauper = map[fieldLegalPauper] as Bool,
        legalVintage = map[fieldLegalVintage] as Bool,
        legalPenny = map[fieldLegalPenny] as Bool,
        legalCommander = map[fieldLegalCommander] as Bool,
        legalBrawl = map[fieldLegalBrawl] as Bool,
        legalHistoricBrawl = map[fieldLegalHistoricBrawl] as Bool,
        legalAlchemy = map[fieldLegalAlchemy] as Bool,
        legalPauperCommander = map[fieldLegalPauperCommander] as Bool,
        legalDuel = map[fieldLegalDuel] as Bool,
        legalOldSchool = map[fieldLegalOldSchool] as Bool,
        legalPremodern = map[fieldLegalPremodern] as Bool;

  Map<String, dynamic> toMap() => {
        fieldName: name,
        fieldManaCost: manaCost,
        fieldColors: colors,
        fieldColorIdentity: colorIdentity,
        fieldCmc: convertedManaCost,
        fieldPower: power,
        fieldToughness: toughness,
        fieldProducedMana: producedMana,
        fieldTypeLine: typeLine,
        fieldOracleText: oracleText,
        fieldRarity: rarity,
        fieldRulings: rulings,
        fieldLegalStandard: legalStandard as Int,
        fieldLegalFuture: legalFuture as Int,
        fieldLegalHistoric: legalHistoric as Int,
        fieldLegalGladiator: legalGladiator as Int,
        fieldLegalPioneer: legalPioneer as Int,
        fieldLegalExplorer: legalExplorer as Int,
        fieldLegalModern: legalModern as Int,
        fieldLegalLegacy: legalLegacy as Int,
        fieldLegalPauper: legalPauper as Int,
        fieldLegalVintage: legalVintage as Int,
        fieldLegalPenny: legalPenny as Int,
        fieldLegalCommander: legalCommander as Int,
        fieldLegalBrawl: legalBrawl as Int,
        fieldLegalHistoricBrawl: legalHistoricBrawl as Int,
        fieldLegalAlchemy: legalAlchemy as Int,
        fieldLegalPauperCommander: legalPauperCommander as Int,
        fieldLegalDuel: legalDuel as Int,
        fieldLegalOldSchool: legalOldSchool as Int,
        fieldLegalPremodern: legalPremodern as Int,
      };
}
