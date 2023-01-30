// ignore_for_file: file_names
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Class/ClassModel.dart';
import 'package:aamusted_timetable_generator/Models/ClassCoursePair/ClassCoursePairModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Models/Course/LiberalModel.dart';
import 'package:aamusted_timetable_generator/Models/LiberalTimePair/LiberalTimePairModel.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/Models/VenueTimePair/VenueTimePairModel.dart';
import 'package:aamusted_timetable_generator/SateManager/ConfigDataFlow.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/Academic/AcademicModel.dart';
import '../Models/Config/ConfigModel.dart';
import '../Models/Table/TableModel.dart';

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
    hasSpecialCourseError = list.any((element) =>
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

  List<VenueTimePairModel>? venueTimePairs;
  List<VenueTimePairModel>? get getVenueTimePairs => venueTimePairs;
  List<LiberalTimePairModel>? libTimePairs;
  List<LiberalTimePairModel>? get getLiberalTimePairs => libTimePairs;
  List<ClassCoursePairModel>? classCoursePairs;
  List<ClassCoursePairModel>? get getClassCoursePairs => classCoursePairs;
  List<TableModel>? tables;
  List<TableModel>? get getTables => tables;
  void generateTables(ConfigModel config) {
    tables = [];

    var days = config.days;
    var libLevel = config.liberalLevel;
    var periods = config.periods;
    var libDays = config.liberalCourseDay;
    var libPeriods = config.liberalCoursePeriod;
    venueTimePairs = getVTP(days, periods);
    // print('length of venueTimePairs: ${venueTimePairs!.length}');
    libTimePairs = getLTP(libDays, libPeriods);
    // print('length of libTimePairs: ${libTimePairs!.length}');
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
    generateRegularTables(libLevel!, libDays!['day'], libPeriods!['period']);

    //now let generate only evening students table
    generateEveningTables(libLevel, libDays['day'], libPeriods['period']);

    //now let generate only weekend students tables
    generateWeekendTable(libLevel, libDays['day'], libPeriods['period']);

    //now let save tables into the database
    HiveCache.addTables(tables);
    tables = HiveCache.getTables(currentAcademicYear);
    notifyListeners();
  }

  List<VenueTimePairModel> getVTP(
      List<Map<String, dynamic>>? days, List<Map<String, dynamic>>? periods) {
    List<VenueTimePairModel> venueTimePairs = [];
    for (var day in days!) {
      for (var period in periods!) {
        for (var venue in venueList) {
          VenueTimePairModel vtp = VenueTimePairModel();
          vtp.day = day['day'];
          vtp.period = period['period'];
          vtp.id =
              '${venue.id}${day['day']}${period['period']}'.trimToLowerCase();
          vtp.venueId = venue.id;
          vtp.dayMap = day;
          vtp.periodMap = period;
          vtp.isDisabilityAccessible = venue.isDisabilityAccessible;
          vtp.reg = day['isRegular'] == true && period['isRegular'] == true;
          vtp.eve = day['isEvening'] == true && period['isEvening'] == true;
          vtp.wnd = day['isWeekend'] == true && period['isWeekend'] == true;
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
    Map<String, dynamic>? libDays,
    Map<String, dynamic>? libPeriods,
  ) {
    List<LiberalTimePairModel> libTimePairs = [];
    for (var lib in liberalList) {
      LiberalTimePairModel ltp = LiberalTimePairModel();
      ltp.day = libDays!['day'];
      ltp.period = libPeriods!['period'];
      ltp.courseCode = lib.code;
      ltp.courseTitle = lib.title;
      ltp.academicYear = lib.academicYear;
      ltp.id =
          '${lib.id}${libDays['day']}${libPeriods['period']}'.trimToLowerCase();
      ltp.lecturerName = lib.lecturerName;
      ltp.lecturerEmail = lib.lecturerEmail;
      ltp.level = lib.level;
      libTimePairs.add(ltp);
    }
    return libTimePairs;
  }

  List<ClassCoursePairModel> getCCP() {
    List<ClassCoursePairModel> classCoursePairs = [];
    for (var stuClass in classList) {
      var courses = courseList
          .where((element) =>
              element.department!.trimToLowerCase() ==
                  stuClass.department!.trimToLowerCase() &&
              element.level!.trim() == stuClass.level!.trim())
          .toList();
      for (var txt in courses) {
        CourseModel course = courseList.firstWhere(
            (element) =>
                element.code.toString().trimToLowerCase() ==
                txt.toString().trimToLowerCase(),
            orElse: () => CourseModel());
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
          ccp.classType = stuClass.type;

          classCoursePairs.add(ccp);
        }
      }
    }

    return classCoursePairs;
  }

  void generateRegularTables(String libLevel, String libDay, String libPeriod) {
    //now we get only regular classCoursePairs and create their tables
    for (var classCoursePair in classCoursePairs!) {
      if ((classCoursePair.classType!.trimToLowerCase().startsWith('r') ||
              classCoursePair.classType!.trimToLowerCase() == 'regular') &&
          classCoursePair.isAssigned == false) {
        //check if it has a special Venue==================================
        if (classCoursePair.venues!.isNotEmpty) {
          //now we pick one venue from the list of venues and find it in the venueTimePairs
          var title = (classCoursePair.venues!..shuffle()).first;
          for (var vtp in venueTimePairs!) {
            if (title.trimToLowerCase() ==
                vtp.venueName.toString().trimToLowerCase()) {
              if (!vtp.isBooked && vtp.reg == true) {
                if (!(classCoursePair.classLevel!.trimToLowerCase() ==
                        libLevel &&
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
          }
        } else {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.reg == true &&
                venueTimePair.isBooked == false &&
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
              if (venueTimePair.reg == true &&
                  venueTimePair.isBooked == false &&
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
              if (venueTimePair.reg == true &&
                  venueTimePair.isBooked == false &&
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

  TableModel returnTable(vtp, classCoursePair) {
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
    table.classType = classCoursePair.classType;
    table.dayMap = vtp.dayMap;
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
          table.dayMap = vtp.dayMap;
          table.classLevel = ltp.level;
          tables!.add(table);
          vtp.isBooked = true;
          break;
        }
      }
    }
  }

  void generateEveningTables(String libLevel, libDay, libPeriod) {
    //now we get only evening classCoursePairs and create their tables
    for (var classCoursePair in classCoursePairs!) {
      if ((classCoursePair.classType!.trimToLowerCase().startsWith('e') ||
              classCoursePair.classType!.trimToLowerCase() == 'evening') &&
          classCoursePair.isAssigned == false) {
        //check if it has a special Venue==================================
        if (classCoursePair.venues!.isNotEmpty) {
          //now we pick one venue from the list of venues and find it in the venueTimePairs
          var title = (classCoursePair.venues!..shuffle()).first;
          for (var vtp in venueTimePairs!) {
            if (title.trimToLowerCase() ==
                vtp.venueName.toString().trimToLowerCase()) {
              if (!vtp.isBooked && vtp.eve == true) {
                if (!(classCoursePair.classLevel!.trimToLowerCase() ==
                        libLevel &&
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
          }
        } else {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.eve == true &&
                venueTimePair.isBooked == false &&
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
              if (venueTimePair.eve == true &&
                  venueTimePair.isBooked == false &&
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
              if (venueTimePair.eve == true &&
                  venueTimePair.isBooked == false &&
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

  void generateWeekendTable(String libLevel, libDay, libPeriod) {
    //now we get only weekend classCoursePairs and create their tables
    for (var classCoursePair in classCoursePairs!) {
      if ((classCoursePair.classType!.trimToLowerCase().startsWith('w') ||
              classCoursePair.classType!.trimToLowerCase() == 'weekend') &&
          classCoursePair.isAssigned == false) {
        //check if it has a special Venue==================================
        if (classCoursePair.venues!.isNotEmpty) {
          //now we pick one venue from the list of venues and find it in the venueTimePairs
          var title = (classCoursePair.venues!..shuffle()).first;
          for (var vtp in venueTimePairs!) {
            if (title.trimToLowerCase() ==
                vtp.venueName.toString().trimToLowerCase()) {
              if (!vtp.isBooked && vtp.wnd == true) {
                if (!(classCoursePair.classLevel!.trimToLowerCase() ==
                        libLevel &&
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
          }
        } else {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.wnd == true &&
                venueTimePair.isBooked == false &&
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
              if (venueTimePair.wnd == true &&
                  venueTimePair.isBooked == false &&
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
              if (venueTimePair.wnd == true &&
                  venueTimePair.isBooked == false &&
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

  void setTables(tb) {
    if (tb != null) {
      tables = tb;
    }
    notifyListeners();
  }
}
