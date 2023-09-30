import 'dart:io';
import 'package:aamusted_timetable_generator/data/repos/database_repo.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/configs/configuration_model.dart';


class DatabaseUseCase extends DatabaseRepo{
  @override
  Future<void> init()async {
     String path = Directory('${Directory.current.path}/database').path;
    await Hive.initFlutter(path);

    //register adapters
    //config config adapter
     Hive.registerAdapter(ConfigurationModelAdapter());
    
  }

}