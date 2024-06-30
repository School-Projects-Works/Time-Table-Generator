
import 'package:mongo_dart/mongo_dart.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/repo/config_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ConfigUsecase extends ConfigRepo {
  final Db db;
  ConfigUsecase({
    required this.db,
  });
  @override
  Future<(bool, ConfigModel?, String?)> addConfigurations(
      ConfigModel configurations) async {
    try {
      //delete all the configurations where the id is the same as the new configurations
      await db.collection('config').remove({'id': configurations.id});
      await db.collection('config').insert(configurations.toMap());

      return Future.value(
          (true, configurations, 'Configurations added successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }

  @override
  Future<(bool, ConfigModel?, String?)> deleteConfigurations(String id) async {
    try {
      await db.collection('config').remove({'id': id});
      return Future.value((true, null, 'Configurations deleted successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }

  @override
  Future<List<ConfigModel>> getConfigurations() async {
    try {
      final config = await db.collection('config').find().toList();
      return config.map((e) => ConfigModel.fromMap(e)).toList();
    } catch (e) {
      //print(e);
      return Future.value([]);
    }
  }

  @override
  Future<(bool, ConfigModel?, String?)> updateConfigurations(
      ConfigModel configurations) async {
    try {
      await db.collection('config').update(
            where.eq('id', configurations.id),
            configurations.toMap(),
          );
      return Future.value(
          (true, configurations, 'Configurations updated successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }
///chenge to firebase firestore

 Future<(bool, ConfigModel?, String?)> addConfigToFirebase(ConfigModel state)async {
 
  try {
     final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('config').doc(state.id).set(state.toMap());
    return (true, state, 'Configurations added successfully');
  } catch (e) {
    return (false, null, e.toString());
  }
 }
 Future<List<ConfigModel>> getConfigFromFirebase() async {
    try {
       final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final config = await firestore.collection('config').get();
      return config.docs.map((e) => ConfigModel.fromMap(e.data())).toList();
    } catch (e) {
      //print(e);
      return Future.value([]);
    }
  }
}
