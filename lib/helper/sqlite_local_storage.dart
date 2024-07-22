// class SQLiteDBProvider {
//   SQLiteDBProvider._();
//
//   static final SQLiteDBProvider db = SQLiteDBProvider._();
//
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) {
//       print(_database);
//       return _database;
//     }
//     _database = await initDB();
//     return _database;
//   }
//
//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "LocalBSCDB.db");
//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//       await db.execute("CREATE TABLE  shopping_cart ("
//           "id INTEGER,"
//           "service_provider_id INTEGER,"
//           "service_provider_name TEXT,"
//           "name TEXT,"
//           "image TEXT,"
//           "description TEXT,"
//           "discount_status TEXT,"
//           "count INTEGER,"
//           "price INTEGER,"
//           "discount_price INTEGER"
//           ")");
//
//       await db.execute("CREATE TABLE notifications ("
//           "id TEXT,"
//           "title TEXT,"
//           "tag TEXT,"
//           "value TEXT,"
//           "body TEXT,"
//           "large_icon TEXT,"
//           "color TEXT,"
//           "time TEXT,"
//           "read INTEGER"
//           ")");
//     });
//   }
//
//   newNotification(SMAIPopUpNotification notification) async {
//     Database? db = await database;
//
//     var raw = await db!.rawInsert(
//         "INSERT INTO notifications (id,title,tag,value,body,large_icon,color,time,read)"
//         " VALUES (?,?,?,?,?,?,?,?,?)",
//         [
//           notification.id,
//           notification.title,
//           notification.tag,
//           notification.value,
//           notification.body,
//           notification.largeIcon,
//           notification.color,
//           notification.time,
//           notification.read
//         ]);
//     return raw;
//   }
//
//   getSpecificNotification(String id) async {
//     Database? db = await database;
//     var res =
//         await db!.query("notifications", where: "id = ?", whereArgs: [id]);
//     if (res.length > 0) return SMAIPopUpNotification.fromMap(res.first);
//     return SMAIPopUpNotification(
//         id: "---",
//         title: "---",
//         tag: "---",
//         value: "---",
//         body: "---",
//         largeIcon: "---",
//         color: "---",
//         time: "---",
//         read: 0);
//   }
//
//   Future<List<SMAIPopUpNotification>> getAllNotifications() async {
//     Database? db = await database;
//     var res = await db!.query("notifications", orderBy: "time DESC");
//     List<SMAIPopUpNotification> list = res.isNotEmpty
//         ? res.map((c) => SMAIPopUpNotification.fromMap(c)).toList()
//         : [];
//     return list;
//   }
//
//   Future<List<SMAIPopUpNotification>>
//       getAllNonReadSMAIPopUpNotification() async {
//     Database? db = await database;
//     var res =
//         await db!.query("notifications", where: "read = ?", whereArgs: [0]);
//     List<SMAIPopUpNotification> list = res.isNotEmpty
//         ? res.map((c) => SMAIPopUpNotification.fromMap(c)).toList()
//         : [];
//     return list;
//   }
//
//   updateSpecificNotification(SMAIPopUpNotification notification) async {
//     Database? db = await database;
//     var res = await db!.update("notifications", notification.toMap(),
//         where: "id = ?", whereArgs: [notification.id]);
//     return res;
//   }
//
//   deleteAllNotifications() async {
//     Database? db = await database;
//     return db!.rawDelete("DELETE FROM notifications");
//   }
// }
