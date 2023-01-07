
import 'package:flutter/material.dart';

import '../Models/Academic/AcademicModel.dart';
class MongoListener extends ChangeNotifier{
  List<AcademicModel>academicList=[];
  List<AcademicModel>get getAcademicList=>academicList;
  void setAcademicList(List<AcademicModel>list){
    academicList=list;
    notifyListeners();
  }
}