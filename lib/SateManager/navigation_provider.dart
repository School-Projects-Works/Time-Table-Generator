// ignore_for_file: constant_identifier_names, file_names
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  double _sideWidth = 60;
  double get sideWidth => _sideWidth;
  void setSideWidth(double width) {
    _sideWidth = width;
    notifyListeners();
  }

  int _page = 0;
  int get page => _page;
  void setPage(int page) {
    _page = page;
    notifyListeners();
  }
}
