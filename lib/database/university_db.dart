import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/model/university_item.dart';

class UniversityDB {
  String dbName;

  UniversityDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(UniversityItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('universities');

    Future<int> keyID = store.add(db, {
      'name': item.name,
      'rank': item.rank,
      'country': item.country,
      'score': item.score
    });

    db.close();
    return keyID;
  }

  Future<List<UniversityItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('universities');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('rank', false)]));

    List<UniversityItem> universities = [];

    for (var record in snapshot) {
      // Try to convert 'rank' to int, default to 0 if invalid
      int rank = 0;
      if (record['rank'] != null) {
        try {
          rank = int.parse(record['rank'].toString());
        } catch (e) {
          print("Error parsing rank: ${record['rank']}");
        }
      }

      // Try to convert 'score' to double, default to 0.0 if invalid
      double score = 0.0;
      try {
        score = double.parse(record['score'].toString());
      } catch (e) {
        print("Error parsing score: ${record['score']}");
      }

      UniversityItem item = UniversityItem(
        keyID: record.key,
        name: record['name'].toString(),
        rank: rank,
        country: record['country'].toString(),
        score: score,
      );
      universities.add(item);
    }
    db.close();
    return universities;
  }

  deleteData(UniversityItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('universities');
    store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, item.keyID)));
    db.close();
  }

  updateData(UniversityItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('universities');

    store.update(
        db,
        {
          'name': item.name,
          'rank': item.rank,
          'country': item.country,
          'score': item.score
        },
        finder: Finder(filter: Filter.equals(Field.key, item.keyID))
    );

    db.close();
  }
}
