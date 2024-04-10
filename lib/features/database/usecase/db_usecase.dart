import 'dart:io';
import 'package:aamusted_timetable_generator/features/tables/data/lcc_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../allocations/data/classes/class_model.dart';
import '../../allocations/data/courses/courses_model.dart';
import '../../allocations/data/lecturers/lecturer_model.dart';
import '../../configurations/data/config/config_model.dart';
import '../../liberal/data/liberal/liberal_model.dart';
import '../../tables/data/ltp_model.dart';
import '../../tables/data/tables_model.dart';
import '../../venues/data/venue_model.dart';
import '../repo/db_repo.dart';

class DatabaseUseCase extends DatabaseRepository {
  @override
  Future<void> init() async {
    String path = Directory('${Directory.current.path}/database').path;
    await Hive.initFlutter(path);
    //confi models
    Hive.registerAdapter(ConfigModelAdapter());
    await Hive.openBox<ConfigModel>('config');

    Hive.registerAdapter(ClassModelAdapter());
    await Hive.openBox<ClassModel>('classes');

    Hive.registerAdapter(CourseModelAdapter());
    await Hive.openBox<CourseModel>('courses');

    Hive.registerAdapter(LecturerModelAdapter());
    await Hive.openBox<LecturerModel>('lecturers');

    //register venue adapter
    Hive.registerAdapter(VenueModelAdapter());
    await Hive.openBox<VenueModel>('venues');

    //register Liberal Studies adapter
    Hive.registerAdapter(LiberalModelAdapter());
    await Hive.openBox<LiberalModel>('liberal');


    //register LTP adapter(Liberal time pair)
    Hive.registerAdapter(LTPModelAdapter());
    await Hive.openBox<LTPModel>('ltp');

    //register LCCP adapter(Lecture course class pair)
    Hive.registerAdapter(LCCPModelAdapter());
    await Hive.openBox<LCCPModel>('lccp');

    //register tables adapter
    Hive.registerAdapter(TablesModelAdapter());
    await Hive.openBox<TablesModel>('tables');
  }
}
