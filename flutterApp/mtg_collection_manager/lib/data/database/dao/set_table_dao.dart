import 'package:mtg_collection_manager/data/database/dao/set_table_def.dart';
import 'package:mtg_collection_manager/data/database/entity/set_db_entity.dart';

class SetTableDao extends SetBaseDao {
  Future<List<SetDbEntity>> selectAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(SetBaseDao.tableName);
    return List.generate(maps.length, (i) => SetDbEntity.fromMap(maps[i]));
  }

  Future<void> insertAll(List<SetDbEntity> assets) async {
    final db = await getDatabase();
    final batch = db.batch();

    for (final asset in assets) {
      batch.insert(SetBaseDao.tableName, asset.toMap());
    }

    await batch.commit();
  }
}
