// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../Models/Academic/AcademicModel.dart';

class HiveListener extends ChangeNotifier {
  List<AcademicModel> academicList = [];
  List<AcademicModel> get getAcademicList => academicList;

  void setAcademicList(List<AcademicModel> list) {
    academicList = list;
    notifyListeners();
  }
}
