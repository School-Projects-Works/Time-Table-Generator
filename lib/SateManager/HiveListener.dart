// ignore_for_file: file_names
import 'dart:math';

import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:aamusted_timetable_generator/Models/ClassCoursePair/ClassCoursePairModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/LiberalModel.dart';
import 'package:aamusted_timetable_generator/Models/LiberalTimePair/LiberalTimePairModel.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/Models/VenueTimePair/VenueTimePairModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import '../Models/Academic/AcademicModel.dart';
import '../Models/Config/ConfigModel.dart';
import '../Models/Config/PeriodModel.dart';
import '../Models/Table/TableModel.dart';

class HiveListener extends ChangeNotifier {
  List<String>? academicYearList = [];
  List<String>? get getAcademicYearList => academicYearList;
  ConfigModel currentConfig = ConfigModel();
  ConfigModel get getCurrentConfig => currentConfig;

  void updateConfigList() {
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      academicYearList!.clear();
      for (ConfigModel config in data) {
        academicYearList!.add(config.academicName!);
      }
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  List<AcademicModel> academicList = [];
  List<AcademicModel> get getAcademicList => academicList;

  String? _currentAcademicYear;

  String tStudents = 'Regular';
  String get targetedStudents => tStudents;

  String? monday, tuesday, wednesday, thursday, friday, saturday, sunday;
  String? get getMonday => monday;
  String? get getTuesday => tuesday;
  String? get getWednesday => wednesday;
  String? get getThursday => thursday;
  String? get getFriday => friday;
  String? get getSaturday => saturday;
  String? get getSunday => sunday;

  PeriodModel periodOne = PeriodModel(),
      periodTwo = PeriodModel(),
      periodThree = PeriodModel(),
      periodFour = PeriodModel(),
      breakTime = PeriodModel();
  PeriodModel get getPeriodOne => periodOne;
  PeriodModel get getPeriodTwo => periodTwo;
  PeriodModel get getPeriodThree => periodThree;
  PeriodModel get getPeriodFour => periodFour;
  PeriodModel get getBreakTime => breakTime;

  String? liberalCourseDay, liberalCoursePeriod;
  String? get getLiberalCourseDay => liberalCourseDay;
  String? get getLiberalCoursePeriod => liberalCoursePeriod;
  String? liberalLevel;
  String? get getLiberalLevel => liberalLevel;

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

  void updateCurrentConfig(ConfigModel config) {
    currentConfig = config;
    if (currentConfig.targetedStudents != null) {
      tStudents = currentConfig.targetedStudents!;
    } else {
      tStudents = 'Regular';
    }
    if (currentConfig.days != null && currentConfig.days!.isNotEmpty) {
      monday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Monday");
      tuesday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Tuesday");
      wednesday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Wednesday");
      thursday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Thursday");
      friday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Friday");
      saturday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Saturday");
      sunday = currentConfig.days!
          .firstWhereOrNull((element) => element == "Sunday");
    } else {
      monday = null;
      tuesday = null;
      wednesday = null;
      thursday = null;
      friday = null;
      saturday = null;
      sunday = null;
    }

    if (currentConfig.periods != null && currentConfig.periods!.isNotEmpty) {
      periodOne = PeriodModel.fromMap(currentConfig.periods!
          .firstWhereOrNull((element) => element['period'] == "1st Period"));
      periodTwo = PeriodModel.fromMap(currentConfig.periods!
          .firstWhereOrNull((element) => element['period'] == "2nd Period"));
      periodThree = PeriodModel.fromMap(currentConfig.periods!
          .firstWhereOrNull((element) => element['period'] == "3rd Period"));
      periodFour = PeriodModel.fromMap(currentConfig.periods!
          .firstWhereOrNull((element) => element['period'] == "4th Period"));
      breakTime = PeriodModel.fromMap(currentConfig.breakTime);
    } else {
      periodOne = PeriodModel().clear();
      periodTwo = PeriodModel().clear();
      periodThree = PeriodModel().clear();
      periodFour = PeriodModel().clear();
    }
    liberalCourseDay = currentConfig.liberalCourseDay;
    liberalCoursePeriod = currentConfig.liberalCoursePeriod != null
        ? currentConfig.liberalCoursePeriod!['period']
        : null;
    liberalLevel = currentConfig.liberalLevel;
    notifyListeners();
  }

  List<CourseModel> courseList = [];
  List<CourseModel> filteredCourses = [];
  List<CourseModel> selectedCourse = [];
  List<CourseModel> get getSelectedCourses => selectedCourse;
  List<CourseModel> get getFilteredCourses => filteredCourses;
  List<CourseModel> get getCourseList => courseList;
  void setCourseList(List<CourseModel> list) {
    var currentCourses =
        list.where((element) => element.targetStudents == tStudents).toList();
    courseList = currentCourses;
    filteredCourses = currentCourses;
    hasSpecialCourseError = currentCourses.any((element) =>
        element.specialVenue!.toLowerCase() != "no" && element.venues!.isEmpty);
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
              element.level!.toLowerCase().contains(value.toLowerCase()))
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

  setSpecialVenue(CourseModel course) {
    HiveCache.updateCourse(course);
    var data = HiveCache.getCourses(currentAcademicYear);
    setCourseList(data);
  }

  bool hasSpecialCourseError = false;
  bool get getHasSpecialCourseError => hasSpecialCourseError;

  deleteCourse(List<CourseModel> courses, BuildContext context) {
    for (var element in courses) {
      HiveCache.deleteCourse(element);
    }
    var data = HiveCache.getCourses(currentAcademicYear);
    if (data.isEmpty) {
      updateHasCourse(false);
    }
    setCourseList(data);
  }

  void clearCourses(BuildContext context) {
    for (var element in getCourseList) {
      HiveCache.deleteCourse(element);
    }
    updateHasCourse(false);
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
      updateHasClass(false);
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
    updateHasClass(false);
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
      updateHasVenue(false);
    }
    setVenueList(data);
  }

  void clearVenues(BuildContext context) {
    for (var element in getVenues) {
      HiveCache.deleteVenue(element);
    }
    updateHasVenue(false);
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
    updateHasLiberal(false);
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
      updateHasLiberal(false);
    }
    setLiberalList(data);
  }

  void removeSelectedLiberal(List<LiberalModel> list) {
    selectedLiberal.removeWhere((element) => list.contains(element));
    notifyListeners();
  }

  List<VenueTimePairModel>? venueTimePairs;
  List<VenueTimePairModel>? get getVenueTimePairs => venueTimePairs;
  List<LiberalTimePairModel>? libTimePairs;
  List<LiberalTimePairModel>? get getLiberalTimePairs => libTimePairs;
  List<ClassCoursePairModel>? classCoursePairs;
  List<ClassCoursePairModel>? get getClassCoursePairs => classCoursePairs;
  List<TableModel>? tables;
  List<TableModel>? get getTables => tables;
  void generateTables() {
    tables = [];
    //clear Hive database where academic year is currentAcademicYear and target student is currentTargetStudent
    HiveCache.deleteTables(currentAcademicYear, tStudents);

    var days = currentConfig.days;
    var libLevel = currentConfig.liberalLevel;
    var periods = currentConfig.periods;
    var libDays = currentConfig.liberalCourseDay;
    var libPeriods = currentConfig.liberalCoursePeriod;
    venueTimePairs = getVTP(days, periods);
    //print('length of venueTimePairs: ${venueTimePairs!.length}');
    libTimePairs = getLTP(libDays, libPeriods);
    //print('length of libTimePairs: ${libTimePairs!.length}');
    classCoursePairs = getCCP();
    //print('length of classCoursePairs: ${classCoursePairs!.length}');

    //Now we have to generate all the possible combinations of the above
    //Now let sort the venueTimePairs from higher capacity to lower capacity
    venueTimePairs!.sort((a, b) =>
        int.parse(a.venueCapacity!).compareTo(int.parse(b.venueCapacity!)));
    //now reverse the list
    venueTimePairs = venueTimePairs!.reversed.toList();

    //now let randomly pick libTimePairs.length venueTimePairs with the highest capacity where the venueTimePairs day and period matches the libTimePairs day and period
    generateLiberalsTables();

    //now we get only regular classCoursePairs and create their tables
    // generateRegularTables(libLevel!, libDays!, libPeriods!['period']);
    generateSpecialVenueTable(libDays, libPeriods!['period'], libLevel);

    // HiveCache.addTables(tables);
    // tables = HiveCache.getTables(currentAcademicYear);
    notifyListeners();
  }

  List<VenueTimePairModel> getVTP(
      List<String>? days, List<Map<String, dynamic>>? periods) {
    List<VenueTimePairModel> venueTimePairs = [];
    for (var day in days!) {
      for (var period in periods!) {
        for (var venue in venueList) {
          VenueTimePairModel vtp = VenueTimePairModel();
          vtp.day = day;
          vtp.period = period['period'];
          vtp.id = '${venue.id}$day${period['period']}'.trimToLowerCase();
          vtp.venueId = venue.id;
          vtp.periodMap = period;
          vtp.isDisabilityAccessible = venue.isDisabilityAccessible;
          vtp.targetedStudents = tStudents;
          vtp.venueName = venue.name;
          vtp.venueCapacity = venue.capacity;
          vtp.academicYear = venue.academicYear;
          vtp.isSpecialVenue = venue.isSpecialVenue;

          venueTimePairs.add(vtp);
        }
      }
    }
    return venueTimePairs;
  }

  List<LiberalTimePairModel> getLTP(
    String? libDays,
    Map<String, dynamic>? libPeriods,
  ) {
    List<LiberalTimePairModel> libTimePairs = [];
    for (var lib in liberalList) {
      LiberalTimePairModel ltp = LiberalTimePairModel();
      ltp.day = libDays;
      ltp.period = libPeriods!['period'];
      ltp.courseCode = lib.code;
      ltp.courseTitle = lib.title;
      ltp.academicYear = lib.academicYear;
      ltp.id = '${lib.id}$libDays${libPeriods['period']}'.trimToLowerCase();
      ltp.lecturerName = lib.lecturerName;
      ltp.lecturerEmail = lib.lecturerEmail;
      ltp.level = liberalLevel;
      libTimePairs.add(ltp);
    }
    return libTimePairs;
  }

  List<ClassCoursePairModel> getCCP() {
    List<ClassCoursePairModel> classCoursePairs = [];
    for (var stuClass in classList) {
      List<CourseModel> courses = [];
      for (var course in courseList) {
        var depSimilarity = stuClass.department!
            .trimToLowerCase()
            .similarityTo(course.department!.trimToLowerCase());
        var levSimilarity = stuClass.level!
            .trimToLowerCase()
            .similarityTo(course.level!.trimToLowerCase());
        if (depSimilarity > 0.7 && levSimilarity > 0.8) {
          courses.add(course);
        }
      }
      if (courses.isNotEmpty) {
        for (CourseModel txt in courses) {
          CourseModel course = txt;
          if (course.code != null) {
            ClassCoursePairModel ccp = ClassCoursePairModel();
            ccp.classId = stuClass.id;
            ccp.courseCode = course.code;
            ccp.courseTitle = course.title;
            ccp.creditHours = course.creditHours;
            ccp.academicYear = course.academicYear;
            ccp.id = '${stuClass.id}${course.id}'.trimToLowerCase();
            ccp.courseId = course.id;
            ccp.className = stuClass.name;
            ccp.department = stuClass.department;
            ccp.classLevel = stuClass.level;
            ccp.venues = course.venues;
            ccp.lecturerName = course.lecturerName;
            ccp.lecturerEmail = course.lecturerEmail;
            ccp.specialVenue = course.specialVenue;
            ccp.classHasDisability = stuClass.hasDisability;
            ccp.classSize = stuClass.size;
            ccp.targetStudents = stuClass.targetStudents;
            classCoursePairs.add(ccp);
          }
        }
      } else {
        CustomDialog.showError(
            message:
                'No course found for ${stuClass.name} Please check the spelling of the Department and Level');
        break;
      }
    }

    return classCoursePairs;
  }

  void generateRegularTables(String libLevel, String libDay, String libPeriod) {
    //now we get only regular classCoursePairs and create their tables
    for (var classCoursePair in classCoursePairs!) {
      if (classCoursePair.isAssigned == false) {
        //check if it has a special Venue==================================
        if (classCoursePair.venues!.isNotEmpty) {
          //now we pick one venue from the list of venues and find it in the venueTimePairs
          var title = (classCoursePair.venues!..shuffle()).first;
          for (var vtp in venueTimePairs!) {
            if (title.trimToLowerCase() ==
                vtp.venueName.toString().trimToLowerCase()) {
              if (!(classCoursePair.classLevel!.trimToLowerCase() == libLevel &&
                  vtp.day == libDay &&
                  vtp.period == libPeriod)) {
                var table = returnTable(vtp, classCoursePair);
                tables!.add(table);
                vtp.isBooked = true;
                classCoursePair.isAssigned = true;
                break;
              }
            }
          }
        } else {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.isBooked == false &&
                venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                    'no') {
              if (!(classCoursePair.classLevel!.trimToLowerCase() == libLevel &&
                  venueTimePair.day == libDay &&
                  venueTimePair.period == libPeriod)) {
                //now we check if venue capacity and the class size are in the same range
                if (int.tryParse(venueTimePair.venueCapacity!)! >=
                        int.tryParse(classCoursePair.classSize!)! &&
                    int.tryParse(venueTimePair.venueCapacity!)! <=
                        int.tryParse(classCoursePair.classSize!)! + 30) {
                  //now we check if the class has disability and the venue is disability accessible
                  if (classCoursePair.classHasDisability
                          .toString()
                          .trimToLowerCase() ==
                      venueTimePair.isDisabilityAccessible
                          .toString()
                          .trimToLowerCase()) {
                    var table = returnTable(venueTimePair, classCoursePair);
                    tables!.add(table);
                    venueTimePair.isBooked = true;
                    classCoursePair.isAssigned = true;
                    break;
                  }
                }
              }
            }
          }
          if (!classCoursePair.isAssigned) {
            for (var venueTimePair in venueTimePairs!) {
              if (venueTimePair.isBooked == false &&
                  venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                      'no') {
                if (!(classCoursePair.classLevel!.trimToLowerCase() ==
                        libLevel &&
                    venueTimePair.day == libDay &&
                    venueTimePair.period == libPeriod)) {
                  //now we check if venue capacity and the class size are in the same range
                  if (int.tryParse(venueTimePair.venueCapacity!)! >=
                          int.tryParse(classCoursePair.classSize!)! &&
                      int.tryParse(venueTimePair.venueCapacity!)! <=
                          int.tryParse(classCoursePair.classSize!)! + 30) {
                    var table = returnTable(venueTimePair, classCoursePair);
                    tables!.add(table);
                    venueTimePair.isBooked = true;
                    classCoursePair.isAssigned = true;
                    break;
                  }
                }
              }
            }
          }
          if (!classCoursePair.isAssigned) {
            for (var venueTimePair in venueTimePairs!) {
              if (venueTimePair.isBooked == false &&
                  venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                      'no') {
                if (!(classCoursePair.classLevel!.trimToLowerCase() ==
                        libLevel &&
                    venueTimePair.day == libDay &&
                    venueTimePair.period == libPeriod)) {
                  var table = returnTable(venueTimePair, classCoursePair);
                  tables!.add(table);
                  venueTimePair.isBooked = true;
                  classCoursePair.isAssigned = true;
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  TableModel returnTable(
      VenueTimePairModel vtp, ClassCoursePairModel classCoursePair) {
    TableModel table = TableModel();
    table.id = '${classCoursePair.id}${vtp.id}'.trimToLowerCase();
    table.classId = classCoursePair.classId;
    table.courseId = classCoursePair.courseId;
    table.venueId = vtp.venueId;
    table.day = vtp.day;
    table.period = vtp.period;
    table.courseCode = classCoursePair.courseCode;
    table.courseTitle = classCoursePair.courseTitle;
    table.className = classCoursePair.className;
    table.venue = vtp.venueName;
    table.lecturerName = classCoursePair.lecturerName;
    table.lecturerEmail = classCoursePair.lecturerEmail;
    table.academicYear = classCoursePair.academicYear;
    table.isSpecialVenue = classCoursePair.specialVenue;
    table.classHasDisability = classCoursePair.classHasDisability;
    table.classSize = classCoursePair.classSize;
    table.targetStudents = classCoursePair.targetStudents;
    table.periodMap = vtp.periodMap;
    table.isSpecialVenue = vtp.isSpecialVenue;
    table.creditHours = classCoursePair.creditHours;
    table.venueCapacity = vtp.venueCapacity;
    table.venueHasDisability = vtp.isDisabilityAccessible;
    table.department = classCoursePair.department;
    table.classLevel = classCoursePair.classLevel;

    return table;
  }

  void generateLiberalsTables() {
    //now we check if day and period in vtp matches day and period in ltp
    for (var ltp in libTimePairs!) {
      for (var vtp in venueTimePairs!) {
        if (!vtp.isBooked && ltp.day == vtp.day && ltp.period == vtp.period) {
          TableModel table = TableModel();
          table.id = '${ltp.id}${vtp.id}';
          table.day = ltp.day;
          table.period = ltp.period;
          table.venue = vtp.venueName;
          table.venueCapacity = vtp.venueCapacity;
          table.academicYear = currentAcademicYear;
          table.venueId = vtp.venueId;
          table.courseCode = ltp.courseCode;
          table.courseTitle = ltp.courseTitle;
          table.lecturerName = ltp.lecturerName;
          table.lecturerEmail = ltp.lecturerEmail;
          table.isSpecialVenue = vtp.isSpecialVenue;
          table.periodMap = vtp.periodMap;
          table.classLevel = ltp.level;
          tables!.add(table);
          vtp.isBooked = true;
          break;
        }
      }
    }
  }

  void setTables(tb) {
    if (tb != null) {
      tables = tb;
    }
    notifyListeners();
  }

  void setTargetedStudents(value) {
    //set the targeted students and update configuration
    tStudents = value;
    notifyListeners();
  }

  void updateMonday(String s) {
    if (s.isNotEmpty) {
      monday = s;
    } else {
      monday = null;
    }
    notifyListeners();
  }

  void updateTuesday(String s) {
    if (s.isNotEmpty) {
      tuesday = s;
    } else {
      tuesday = null;
    }
    notifyListeners();
  }

  void updateWednesday(String s) {
    if (s.isNotEmpty) {
      wednesday = s;
    } else {
      wednesday = null;
    }
    notifyListeners();
  }

  void updateThursday(String s) {
    if (s.isNotEmpty) {
      thursday = s;
    } else {
      thursday = null;
    }
    notifyListeners();
  }

  void updateFriday(String s) {
    if (s.isNotEmpty) {
      friday = s;
    } else {
      friday = null;
    }
    notifyListeners();
  }

  void updateSaturday(String s) {
    if (s.isNotEmpty) {
      saturday = s;
    } else {
      saturday = null;
    }
    notifyListeners();
  }

  void updateSunday(String s) {
    if (s.isNotEmpty) {
      sunday = s;
    } else {
      sunday = null;
    }
    notifyListeners();
  }

  void updatePeriodOne(String s) {
    if (s.isNotEmpty) {
      periodOne.period = s;
    } else {
      periodOne = PeriodModel();
    }
    notifyListeners();
  }

  void updatePeriodTwo(String s) {
    if (s.isNotEmpty) {
      periodTwo.period = s;
    } else {
      periodTwo = PeriodModel();
    }
    notifyListeners();
  }

  void updatePeriodThree(String s) {
    if (s.isNotEmpty) {
      periodThree.period = s;
    } else {
      periodThree = PeriodModel();
    }
    notifyListeners();
  }

  void updatePeriodFour(String s) {
    if (s.isNotEmpty) {
      periodFour.period = s;
    } else {
      periodFour = PeriodModel();
    }
    notifyListeners();
  }

  void updatePeriodFive(String s) {
    if (s.isNotEmpty) {
      breakTime.period = s;
    } else {
      breakTime = PeriodModel();
    }
    notifyListeners();
  }

  void setPeriodOneStart(value) {
    periodOne.startTime = value;
    notifyListeners();
  }

  void setPeriodOneEnd(value) {
    periodOne.endTime = value;
    notifyListeners();
  }

  void setPeriodTwoStart(value) {
    periodTwo.startTime = value;
    notifyListeners();
  }

  void setPeriodTwoEnd(value) {
    periodTwo.endTime = value;
    notifyListeners();
  }

  void setPeriodThreeStart(value) {
    periodThree.startTime = value;
    notifyListeners();
  }

  void setPeriodThreeEnd(value) {
    periodThree.endTime = value;
    notifyListeners();
  }

  void setPeriodFourStart(value) {
    periodFour.startTime = value;
    notifyListeners();
  }

  void setPeriodFourEnd(value) {
    periodFour.endTime = value;
    notifyListeners();
  }

  void setPeriodFiveStart(value) {
    breakTime.startTime = value;
    notifyListeners();
  }

  void setPeriodFiveEnd(value) {
    breakTime.endTime = value;
    notifyListeners();
  }

  void saveConfig() {
    //save the configuration to the database
    //if the days are not empty
    currentConfig.days = [];
    if (monday != null) {
      currentConfig.days!.add(monday!);
    }
    if (tuesday != null) {
      currentConfig.days!.add(tuesday!);
    }
    if (wednesday != null) {
      currentConfig.days!.add(wednesday!);
    }
    if (thursday != null) {
      currentConfig.days!.add(thursday!);
    }
    if (friday != null) {
      currentConfig.days!.add(friday!);
    }
    if (saturday != null) {
      currentConfig.days!.add(saturday!);
    }
    if (sunday != null) {
      currentConfig.days!.add(sunday!);
    }
    //if period one is not empty and the start time and end time is not null
    currentConfig.periods = [];
    if (periodOne.period != null) {
      if (periodOne.startTime == null) {
        CustomDialog.showError(
            message: 'Please select the start time for Period One');
        return;
      } else if (periodOne.endTime == null) {
        CustomDialog.showError(
            message: 'Please select the end time for Period One');
        return;
      } else {
        currentConfig.periods!.add(periodOne.toMap());
      }
    }
    //if period two is not empty and the start time and end time is not null
    if (periodTwo.period != null) {
      if (periodTwo.startTime == null) {
        CustomDialog.showError(
            message: 'Please select the start time for Period Two');
        return;
      } else if (periodTwo.endTime == null) {
        CustomDialog.showError(
            message: 'Please select the end time for Period Two');
        return;
      } else {
        currentConfig.periods!.add(periodTwo.toMap());
      }
    }
    //if period three is not empty and the start time and end time is not null
    if (periodThree.period != null) {
      if (periodThree.startTime == null) {
        CustomDialog.showError(
            message: 'Please select the start time for Period Three');
        return;
      } else if (periodThree.endTime == null) {
        CustomDialog.showError(
            message: 'Please select the end time for Period Three');
        return;
      } else {
        currentConfig.periods!.add(periodThree.toMap());
      }
    }
    //if period four is not empty and the start time and end time is not null
    if (periodFour.period != null) {
      if (periodFour.startTime == null) {
        CustomDialog.showError(
            message: 'Please select the start time for Period Four');
        return;
      } else if (periodFour.endTime == null) {
        CustomDialog.showError(
            message: 'Please select the end time for Period Four');
        return;
      } else {
        currentConfig.periods!.add(periodFour.toMap());
      }
    }
    //if period five is not empty and the start time and end time is not null
    if (breakTime.period != null) {
      if (breakTime.startTime == null) {
        CustomDialog.showError(
            message: 'Please select the start time for Break Time');
        return;
      } else if (breakTime.endTime == null) {
        CustomDialog.showError(
            message: 'Please select the end time for Break Time');
        return;
      } else {
        currentConfig.breakTime = breakTime.toMap();
      }
    }

    //now check if config has at least one day and one period
    if (currentConfig.days == null || currentConfig.days!.isEmpty) {
      CustomDialog.showError(message: 'Please select at least one day');
    } else if (currentConfig.periods == null ||
        currentConfig.periods!.isEmpty) {
      CustomDialog.showError(message: 'Please select at least one period');
    } else {
      CustomDialog.showLoading(message: 'Saving Configuration... Please wait');
      //now we save the configuration and reload all the configurations
      HiveCache.addConfigurations(currentConfig);
      var data = HiveCache.getConfigList();
      if (data.isNotEmpty) {
        currentConfig = data.firstWhere(
            (element) =>
                element.academicName == _currentAcademicYear &&
                element.targetedStudents == tStudents,
            orElse: () => ConfigModel());
        if (currentConfig.id != null) {
          updateCurrentConfig(currentConfig);
        }
      }
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Configuration Saved Successfully');
    }
    notifyListeners();
  }

  void updateHasVenue(bool bool) {
    currentConfig.hasVenues = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void updateHasCourse(bool bool) {
    currentConfig.hasCourse = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void updateHasLiberal(bool bool) {
    currentConfig.hasLiberalCourse = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void updateHasClass(bool bool) {
    currentConfig.hasClass = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void setLiberalDay(String p1) {
    currentConfig.liberalCourseDay = p1;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void setLiberalPeriod(String p1) {
    currentConfig.liberalCoursePeriod =
        currentConfig.periods!.firstWhere((element) => element['period'] == p1);
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void setLiberalLevel(p0) {
    currentConfig.liberalLevel = p0;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      currentConfig = data.firstWhere(
          (element) =>
              element.academicName == _currentAcademicYear &&
              element.targetedStudents == tStudents,
          orElse: () => ConfigModel());
      if (currentConfig.id != null) {
        updateCurrentConfig(currentConfig);
      }
    }
    notifyListeners();
  }

  void updateTargetedStudents(value) {
    if (value != null) {
      tStudents = value;
      var data = HiveCache.getConfigList();
      if (data.isNotEmpty) {
        currentConfig = data.firstWhere(
            (element) =>
                element.academicName == _currentAcademicYear &&
                element.targetedStudents == tStudents,
            orElse: () => ConfigModel());
      }
    }

    notifyListeners();
  }

  void generateSpecialVenueTable(
      String? libDays, String? libPeriod, String? libLevel) {
    var specialClassCoursePair = classCoursePairs!
        .where((element) => element.venues!.isNotEmpty)
        .toList();
    print(specialClassCoursePair.length);
    for (ClassCoursePairModel ccp in specialClassCoursePair) {
      while (!ccp.isAssigned) {
        var venues = ccp.venues;
        Random random = Random();

        int index = random.nextInt(venues!.length);
        for (VenueTimePairModel vtp in venueTimePairs!) {
          if (vtp.venueName == venues[index]) {
            if (vtp.day == libDays &&
                vtp.period == libPeriod &&
                ccp.classLevel == libLevel) {
            } else {
              var table = returnTable(vtp, ccp);
              tables!.add(table);
              vtp.isBooked = true;
              ccp.isAssigned = true;
              break;
            }
          }
        }
      }
    }
  }
}
