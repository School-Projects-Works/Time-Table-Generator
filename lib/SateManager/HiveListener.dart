// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../Models/Academic/AcademicModel.dart';

class HiveListener extends ChangeNotifier {
  List<AcademicModel> academicList = [];
  List<AcademicModel> get getAcademicList => academicList;

  String? _currentAcademicYear;
  void updateCurrentAcademicYear(String? value) {
    _currentAcademicYear = value;
    notifyListeners();
  }

  get currentAcademicYear => _currentAcademicYear;
  void setAcademicList(List<AcademicModel> list) {
    if (list.isNotEmpty) {
      academicList = list;
      academicList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      academicList = academicList.reversed.toList();
      _currentAcademicYear = list.first.name;
    }

    notifyListeners();
  }
}
