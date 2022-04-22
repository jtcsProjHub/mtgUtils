/* This class represents the data that comes from/goes to the local sqflite database. 
I'm sticking to using that as the database instead of something lighter weight like Hive 
because I want to do more than simple name: value storage and mangement. I'd like to be able to 
perform my searches using the database ultimately. Otherwise I'd have to load my entire collection
into memory everytime I launched the program, which is obviously not desireable. */

class MtgCardDbEntity {
  static const fieldId = 'id';
  static const fieldName = 'name';
  static const fieldThumbnailUrl = 'thumbnail_url';
  static const fieldDescription = 'description';

  final int id;
  final String name;
  final String thumbnailUrl;
  final String description;

  const MtgCardDbEntity({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  MtgCardDbEntity.fromMap(Map<String, dynamic> map)
      : id = map[fieldId] as int,
        name = map[fieldName] as String,
        thumbnailUrl = map[fieldThumbnailUrl] as String,
        description = map[fieldDescription] as String;

  Map<String, dynamic> toMap() => {
        fieldId: id,
        fieldName: name,
        fieldThumbnailUrl: thumbnailUrl,
        fieldDescription: description,
      };
}