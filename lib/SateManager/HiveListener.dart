// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/LiberialModel.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
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

  List<CourseModel> courseList = [];
  List<CourseModel> filterdCourses = [];
  List<CourseModel> selectedCourse = [];
  List<CourseModel> get getSelectedCourses => selectedCourse;
  List<CourseModel> get getFilterdCourses => filterdCourses;
  List<CourseModel> get getCourseList => courseList;
  void setCourseList(List<CourseModel> list) {
    courseList = list;
    filterdCourses = list;
    selectedCourse = [];
    notifyListeners();
  }

  void filterCourses(String? value) {
    if (value == null || value.isEmpty) {
      filterdCourses = courseList;
    } else {
      filterdCourses = courseList
          .where((element) =>
              element.title!.toLowerCase().contains(value.toLowerCase()) ||
              element.code!.toLowerCase().contains(value.toLowerCase()) ||
              element.department!.toLowerCase().contains(value.toLowerCase()) ||
              element.lecturerName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<ClassModel> classList = [];
  List<ClassModel> filteredClass = [];
  List<ClassModel> selectedClasses = [];
  List<ClassModel> get getSelectedClasses => selectedClasses;
  List<ClassModel> get getFilteredClass => filteredClass;
  List<ClassModel> get getClassList => classList;
  void setClassList(List<ClassModel> list) {
    classList = list;
    filteredClass = list;
    selectedClasses = [];
    notifyListeners();
  }

  void filterClass(String? value) {
    if (value == null || value.isEmpty) {
      filteredClass = classList;
    } else {
      filteredClass = classList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()) ||
              element.level!.toLowerCase().contains(value.toLowerCase()) ||
              element.type!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<VenueModel> venueList = [];
  List<VenueModel> filteredVenue = [];
  List<VenueModel> selectedVenue = [];
  List<VenueModel> get getSelectedVenues => selectedVenue;
  List<VenueModel> get getFilteredVenue => filteredVenue;
  List<VenueModel> get getVenues => venueList;
  void setVenueList(List<VenueModel> list) {
    venueList = list;
    filteredVenue = list;
    selectedVenue = [];
    notifyListeners();
  }

  void filterVenue(String? value) {
    if (value == null || value.isEmpty) {
      filteredVenue = venueList;
    } else {
      filteredVenue = venueList
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<LiberialModel> liberialList = [];
  List<LiberialModel> filteredLiberial = [];
  List<LiberialModel> selectedLiberial = [];
  List<LiberialModel> get getSelectedLiberials => selectedLiberial;
  List<LiberialModel> get getFilteredLiberial => filteredLiberial;
  List<LiberialModel> get getLiberials => liberialList;
  void setLiberialList(List<LiberialModel> list) {
    liberialList = list;
    filteredLiberial = list;
    selectedLiberial = [];
    notifyListeners();
  }

  void filterLiberial(String? value) {
    if (value == null || value.isEmpty) {
      filteredLiberial = liberialList;
    } else {
      filteredLiberial = liberialList
          .where((element) =>
              element.code!.toLowerCase().contains(value.toLowerCase()) ||
              element.title!.toLowerCase().contains(value.toLowerCase()) ||
              element.lecturerName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  setSpecialVenue(CourseModel course, p0) {
    course.specialVenue = p0;
    HiveCache.updateCourse(course);
    var data = HiveCache.getCourses(currentAcademicYear);
    setCourseList(data);
  }

  deleteCourse(List<CourseModel> courses) {
    for (var element in courses) {
      HiveCache.deleteCourse(element);
    }
    var data = HiveCache.getCourses(currentAcademicYear);
    setCourseList(data);
  }

  void clearCourses() {
    for (var element in getCourseList) {
      HiveCache.deleteCourse(element);
    }
    var data = HiveCache.getCourses(currentAcademicYear);
    setCourseList(data);
  }

  void deleteClasses(List<ClassModel> getSelectedClasses) {
    for (var element in getSelectedClasses) {
      HiveCache.deleteClass(element);
    }
    var data = HiveCache.getClasses(currentAcademicYear);
    setClassList(data);
  }

  void addSelectedClass(List<ClassModel> classItem) {
    if (classItem.length == 1) {
      if (selectedClasses.contains(classItem[0])) {
        selectedClasses.remove(classItem[0]);
      } else {
        selectedClasses.add(classItem[0]);
      }
    } else if (classItem.length > 1) {
      if (selectedClasses.length == classItem.length) {
        selectedClasses.clear();
      } else {
        selectedClasses.clear();
        selectedClasses.addAll(classItem);
      }
    }
    notifyListeners();
  }

  void removeSelectedClass(List<ClassModel> classItem) {
    selectedClasses.removeWhere((element) => classItem.contains(element));
    notifyListeners();
  }

  void clearClasses() {
    for (var element in getClassList) {
      HiveCache.deleteClass(element);
    }
    var data = HiveCache.getClasses(currentAcademicYear);
    setClassList(data);
  }

  void addSelectedCourses(List<CourseModel> getFilterdCourses) {
    if (getFilterdCourses.length == 1) {
      if (selectedCourse.contains(getFilterdCourses[0])) {
        selectedCourse.remove(getFilterdCourses[0]);
      } else {
        selectedCourse.add(getFilterdCourses[0]);
      }
    } else if (getFilterdCourses.length > 1) {
      if (selectedCourse.length == getFilterdCourses.length) {
        selectedCourse.clear();
      } else {
        selectedCourse.clear();
        selectedCourse.addAll(getFilterdCourses);
      }
    }
    notifyListeners();
  }

  void removeSelectedCourses(List<CourseModel> list) {
    selectedCourse.removeWhere((element) => list.contains(element));
    notifyListeners();
  }

  void addSelectedVenues(List<VenueModel> venueItems) {
    if (venueItems.length == 1) {
      if (selectedVenue.contains(venueItems[0])) {
        selectedVenue.remove(venueItems[0]);
      } else {
        selectedVenue.add(venueItems[0]);
      }
    } else if (venueItems.length > 1) {
      if (selectedVenue.length == venueItems.length) {
        selectedVenue.clear();
      } else {
        selectedVenue.clear();
        selectedVenue.addAll(venueItems);
      }
    }
    notifyListeners();
  }

  void removeSelectedVenues(List<VenueModel> list) {
    selectedVenue.removeWhere((element) => list.contains(element));
    notifyListeners();
  }

  void deleteVenues(List<VenueModel> getSelectedVenues) {
    for (var element in getSelectedVenues) {
      HiveCache.deleteVenue(element);
    }
    var data = HiveCache.getVenues(currentAcademicYear);
    setVenueList(data);
  }

  void clearVenues() {
    for (var element in getVenues) {
      HiveCache.deleteVenue(element);
    }
    var data = HiveCache.getVenues(currentAcademicYear);
    setVenueList(data);
  }

  void addSelectedLiberials(List<LiberialModel> items) {
    if (items.length == 1) {
      if (selectedLiberial.contains(items[0])) {
        selectedLiberial.remove(items[0]);
      } else {
        selectedLiberial.add(items[0]);
      }
    } else if (items.length > 1) {
      if (selectedLiberial.length == items.length) {
        selectedLiberial.clear();
      } else {
        selectedLiberial.clear();
        selectedLiberial.addAll(items);
      }
    }
    notifyListeners();
  }

  void clearLiberial() {
    for (var element in getLiberials) {
      HiveCache.deleteLiberial(element);
    }
    var data = HiveCache.getLiberials(currentAcademicYear);
    setLiberialList(data);
  }

  void deleteLiberial(List<LiberialModel> getSelectedLiberial) {
    for (var element in getSelectedLiberial) {
      HiveCache.deleteLiberial(element);
    }
    var data = HiveCache.getLiberials(currentAcademicYear);
    setLiberialList(data);
  }

  void removeSelectedLiberial(List<LiberialModel> list) {
    selectedLiberial.removeWhere((element) => list.contains(element));
    notifyListeners();
  }
}
