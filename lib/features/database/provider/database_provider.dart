import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

final dbFutureProvider = FutureProvider<Db>((ref) async {
  var db = Db("mongodb://localhost:27017/time_table");
  await db.open();
  ref.read(dbProvider.notifier).state = db;
  return db;
});

final dbProvider = StateProvider<Db>((ref) {
  var db = Db("mongodb://localhost:27017/time_table");
  return db;
});
