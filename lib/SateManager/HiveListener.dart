// ignore_for_file: file_names
import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/LiberalModel.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/SateManager/ConfigDataFlow.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<CourseModel> filteredCourses = [];
  List<CourseModel> selectedCourse = [];
  List<CourseModel> get getSelectedCourses => selectedCourse;
  List<CourseModel> get getFilteredCourses => filteredCourses;
  List<CourseModel> get getCourseList => courseList;
  void setCourseList(List<CourseModel> list) {
    courseList = list;
    filteredCourses = list;
    selectedCourse = [];
    notifyListeners();
  }

  void filterCourses(String? value) {
    if (value == null || value.isEmpty) {
      filteredCourses = courseList;
    } else {
      filteredCourses = courseList
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

  List<LiberalModel> liberalList = [];
  List<LiberalModel> filteredLiberal = [];
  List<LiberalModel> selectedLiberal = [];
  List<LiberalModel> get getSelectedLiberals => selectedLiberal;
  List<LiberalModel> get getFilteredLiberal => filteredLiberal;
  List<LiberalModel> get getLiberals => liberalList;
  void setLiberalList(List<LiberalModel> list) {
    liberalList = list;
    filteredLiberal = list;
    selectedLiberal = [];
    notifyListeners();
  }

  void filterLiberal(String? value) {
    if (value == null || value.isEmpty) {
      filteredLiberal = liberalList;
    } else {
      filteredLiberal = liberalList
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

  deleteCourse(List<CourseModel> courses, BuildContext context) {
    for (var element in courses) {
      HiveCache.deleteCourse(element);
    }
    var data = HiveCache.getCourses(currentAcademicYear);
    if (data.isEmpty) {
      Provider.of<ConfigDataFlow>(context, listen: false)
          .updateHasCourse(false);
    }
    setCourseList(data);
  }

  void clearCourses(BuildContext context) {
    for (var element in getCourseList) {
      HiveCache.deleteCourse(element);
    }
    Provider.of<ConfigDataFlow>(context, listen: false).updateHasCourse(false);
    var data = HiveCache.getCourses(currentAcademicYear);
    setCourseList(data);
  }

  void deleteClasses(
      List<ClassModel> getSelectedClasses, BuildContext context) {
    for (var element in getSelectedClasses) {
      HiveCache.deleteClass(element);
    }
    var data = HiveCache.getClasses(currentAcademicYear);
    if (data.isEmpty) {
      Provider.of<ConfigDataFlow>(context, listen: false).updateHasClass(false);
    }
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

  void clearClasses(BuildContext context) {
    for (var element in getClassList) {
      HiveCache.deleteClass(element);
    }
    Provider.of<ConfigDataFlow>(context, listen: false).updateHasClass(false);
    var data = HiveCache.getClasses(currentAcademicYear);
    setClassList(data);
  }

  void addSelectedCourses(List<CourseModel> getFilteredCourses) {
    if (getFilteredCourses.length == 1) {
      if (selectedCourse.contains(getFilteredCourses[0])) {
        selectedCourse.remove(getFilteredCourses[0]);
      } else {
        selectedCourse.add(getFilteredCourses[0]);
      }
    } else if (getFilteredCourses.length > 1) {
      if (selectedCourse.length == getFilteredCourses.length) {
        selectedCourse.clear();
      } else {
        selectedCourse.clear();
        selectedCourse.addAll(getFilteredCourses);
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

  void deleteVenues(List<VenueModel> getSelectedVenues, BuildContext context) {
    for (var element in getSelectedVenues) {
      HiveCache.deleteVenue(element);
    }
    var data = HiveCache.getVenues(currentAcademicYear);
    if (data.isEmpty) {
      Provider.of<ConfigDataFlow>(context, listen: false).updateHasVenue(false);
    }
    setVenueList(data);
  }

  void clearVenues(BuildContext context) {
    for (var element in getVenues) {
      HiveCache.deleteVenue(element);
    }
    Provider.of<ConfigDataFlow>(context, listen: false).updateHasVenue(false);
    var data = HiveCache.getVenues(currentAcademicYear);
    setVenueList(data);
  }

  void addSelectedLiberals(List<LiberalModel> items) {
    if (items.length == 1) {
      if (selectedLiberal.contains(items[0])) {
        selectedLiberal.remove(items[0]);
      } else {
        selectedLiberal.add(items[0]);
      }
    } else if (items.length > 1) {
      if (selectedLiberal.length == items.length) {
        selectedLiberal.clear();
      } else {
        selectedLiberal.clear();
        selectedLiberal.addAll(items);
      }
    }
    notifyListeners();
  }

  void clearLiberal(BuildContext context) {
    for (var element in getLiberals) {
      HiveCache.deleteLiberal(element);
    }
    Provider.of<ConfigDataFlow>(context, listen: false).updateHasLiberal(false);
    var data = HiveCache.getLiberals(currentAcademicYear);
    setLiberalList(data);
  }

  void deleteLiberal(
      List<LiberalModel> getSelectedLiberal, BuildContext context) {
    for (var element in getSelectedLiberal) {
      HiveCache.deleteLiberal(element);
    }
    var data = HiveCache.getLiberals(currentAcademicYear);
    if (data.isEmpty) {
      Provider.of<ConfigDataFlow>(context, listen: false)
          .updateHasLiberal(false);
    }
    setLiberalList(data);
  }

  void removeSelectedLiberal(List<LiberalModel> list) {
    selectedLiberal.removeWhere((element) => list.contains(element));
    notifyListeners();
  }
}
