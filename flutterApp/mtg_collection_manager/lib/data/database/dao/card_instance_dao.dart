// lib/data/database/dao/recipe_dao.dart

import 'package:mtg_collection_manager/data/database/dao/card_instance_table_def.dart';
import 'package:mtg_collection_manager/data/database/entity/card_instance_db_entity.dart';

class CardInstanceDao extends CardInstanceBaseDao {
  Future<List<CardInstanceDbEntity>> selectAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(CardInstanceBaseDao.cardTableName);
    return List.generate(
        maps.length, (i) => CardInstanceDbEntity.fromMap(maps[i]));
  }

  Future<void> insertAll(List<CardInstanceDbEntity> assets) async {
    final db = await getDatabase();
    final batch = db.batch();

    for (final asset in assets) {
      batch.insert(CardInstanceBaseDao.cardTableName, asset.toMap());
    }

    await batch.commit();
  }
}
