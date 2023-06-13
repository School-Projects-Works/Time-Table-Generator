// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/Models/Class/class_model.dart';
import 'package:aamusted_timetable_generator/Models/ClassCoursePair/class_course_pair_model.dart';
import 'package:aamusted_timetable_generator/Models/Course/course_model.dart';
import 'package:aamusted_timetable_generator/Models/Course/liberal_model.dart';
import 'package:aamusted_timetable_generator/Models/LiberalTimePair/liberal_time_pair_model.dart';
import 'package:aamusted_timetable_generator/Models/Venue/venue_model.dart';
import 'package:aamusted_timetable_generator/Models/VenueTimePair/venue_time_pair_model.dart';
import 'package:aamusted_timetable_generator/SateManager/hive_cache.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import '../Constants/constant.dart';
import '../Models/Config/config_model.dart';
import '../Models/Config/period_model.dart';
import '../Models/Table/table_item_model.dart';
import '../Models/Table/table_model.dart';

class HiveListener extends ChangeNotifier {
  ConfigModel currentConfig = ConfigModel();
  ConfigModel get getCurrentConfig => currentConfig;
  List<ConfigModel> _configList = [];
  List<ConfigModel> get getConfigList => _configList;
  String? _currentAcademicYear = Constant.academicYear.first;
  String? get currentAcademicYear => _currentAcademicYear;
  String tStudents = Constant.studentTypes.first;
  String get targetedStudents => tStudents;

  List<CourseModel> allCourses = [];
  List<ClassModel> allClasses = [];
  List<LiberalModel> allLiberalCourses = [];

  String semester = Constant.semesters.first;
  get currentSemester => semester;

  TableModel? table;
  TableModel? get getTable => table;

  List<TableItemModel> tableItems = [];
  List<TableItemModel> get getTableItems => tableItems;
  List<TableItemModel> filteredTableItems = [];
  List<TableItemModel> get getFilteredTableItems => filteredTableItems;

  List<TableModel> listOfTables = [];
  List<TableModel> get getListOfTables => listOfTables;

  void repopulateData() {
    allCourses = HiveCache.getCourses();
    allClasses = HiveCache.getClasses();
    allLiberalCourses = HiveCache.getLiberals();
    var table = HiveCache.getTables();
    setClassList(allClasses);
    setCourseList(allCourses);
    updateCurrentConfig(currentConfig);
    setLiberalList(allLiberalCourses);
    setTable(table);
  }

  void updateCurrentSemester(String? sem) {
    if (sem != null && semester != sem) {
      semester = sem;
      //get configurations where semester is equal to current semester from list of configs
      currentConfig = _configList.firstWhereOrNull((element) =>
              element.academicSemester == semester &&
              element.academicYear == _currentAcademicYear &&
              element.targetedStudents == tStudents) ??
          ConfigModel();
      repopulateData();
    }
  }

  void updateConfigList() {
    var data = HiveCache.getConfigList();
    _configList = data;
    currentConfig = data.firstWhere(
        (element) =>
            element.academicYear == _currentAcademicYear &&
            element.targetedStudents == tStudents &&
            element.academicSemester == semester,
        orElse: () => ConfigModel());
    if (currentConfig.id != null) {
      updateCurrentConfig(currentConfig);
    }

    notifyListeners();
  }

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
    if (value != null && _currentAcademicYear != value) {
      _currentAcademicYear = value;
      currentConfig = _configList.firstWhereOrNull((element) =>
              element.academicSemester == semester &&
              element.academicYear == _currentAcademicYear &&
              element.targetedStudents == tStudents) ??
          ConfigModel();
      repopulateData();
      notifyListeners();
    }
  }

  void updateCurrentConfig(ConfigModel config) {
    currentConfig = config;

    tStudents = currentConfig.targetedStudents ?? 'Regular';
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
    } else {
      periodOne = PeriodModel().clear();
      periodTwo = PeriodModel().clear();
      periodThree = PeriodModel().clear();
      periodFour = PeriodModel().clear();
    }
    //check if config has break
    if (currentConfig.breakTime != null) {
      breakTime = PeriodModel.fromMap(currentConfig.breakTime!);
    } else {
      breakTime = PeriodModel().clear();
    }
    liberalCourseDay = currentConfig.liberalCourseDay;
    liberalCoursePeriod = currentConfig.liberalCoursePeriod != null
        ? currentConfig.liberalCoursePeriod!['period']
        : null;
    liberalLevel = currentConfig.liberalLevel;
    //now we get all students class, venues, courses, liberal courses
    //for the academic year and target students

    notifyListeners();
  }

  List<CourseModel> currentCourseList = [];
  List<CourseModel> filteredCourses = [];
  List<CourseModel> selectedCourse = [];
  List<CourseModel> get getSelectedCourses => selectedCourse;
  List<CourseModel> get getFilteredCourses => filteredCourses;
  List<CourseModel> get getCourseList => currentCourseList;
  void setCourseList(List<CourseModel> list) {
    allCourses = list;
    var courses = list
        .where((element) =>
            element.targetStudents == tStudents &&
            element.academicYear == _currentAcademicYear &&
            element.academicSemester == semester)
        .toList();
    currentCourseList = courses;
    filteredCourses = courses;
    hasSpecialCourseError = courses.any((element) =>
        element.specialVenue!.toLowerCase() != "no" && element.venues!.isEmpty);
    selectedCourse = [];
    notifyListeners();
  }

  void filterCourses(String? value) {
    if (value == null || value.isEmpty) {
      filteredCourses = currentCourseList;
    } else {
      filteredCourses = currentCourseList
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
    allClasses = list;
    var incomingList = list
        .where((element) =>
            element.targetStudents == tStudents &&
            element.academicYear == _currentAcademicYear &&
            element.academicSemester == semester)
        .toList();
    filteredClass = incomingList;
    classList = incomingList;
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
    allLiberalCourses = list;
    var incomingList = list
        .where((element) =>
            element.academicYear == _currentAcademicYear &&
            element.academicSemester == semester &&
            element.targetStudents == tStudents)
        .toList();
    liberalList = incomingList;
    filteredLiberal = incomingList;
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
    var data = HiveCache.getCourses();
    setCourseList(data);
  }

  bool hasSpecialCourseError = false;
  bool get getHasSpecialCourseError => hasSpecialCourseError;

  deleteCourse(List<CourseModel> courses, BuildContext context) {
    for (var element in courses) {
      HiveCache.deleteCourse(element);
    }
    var data = HiveCache.getCourses();
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
    var data = HiveCache.getCourses();
    setCourseList(data);
  }

  void deleteClasses(
      List<ClassModel> getSelectedClasses, BuildContext context) {
    for (var element in getSelectedClasses) {
      HiveCache.deleteClass(element);
    }
    var data = HiveCache.getClasses();
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
    var data = HiveCache.getClasses();
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
    var data = HiveCache.getVenues();

    setVenueList(data);
  }

  void clearVenues(BuildContext context) {
    for (var element in getVenues) {
      HiveCache.deleteVenue(element);
    }

    var data = HiveCache.getVenues();
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
    var data = HiveCache.getLiberals();
    setLiberalList(data);
  }

  void deleteLiberal(
      List<LiberalModel> getSelectedLiberal, BuildContext context) {
    for (var element in getSelectedLiberal) {
      HiveCache.deleteLiberal(element);
    }
    var data = HiveCache.getLiberals();
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

  void generateTables() {
    CustomDialog.showLoading(message: 'Creating timetable... Please wait');

    List<TableItemModel> items = [];
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
    var libList = generateLiberalsTables();
    items.addAll(libList);
    //print('Before special length of tables is ${tables!.length}');
    //now we get only regular classCoursePairs and create their tables
    // generateRegularTables(libLevel!, libDays!, libPeriods!['period']);
    var speList =
        generateSpecialVenueTable(libDays, libPeriods!['period'], libLevel);
    items.addAll(speList);

    //now let generate the rest of the table
    var restList =
        generateRestOfTables(libDays, libPeriods['period'], libLevel);
    items.addAll(restList);
    if (items.isNotEmpty) {
      String id = '$_currentAcademicYear$semester$tStudents$tableType'
          .hashCode
          .toString();
      HiveCache.deleteTable(id);
      var table = TableModel(id: id, tableType: tableType)
        ..academicSemester = semester
        ..academicYear = _currentAcademicYear
        ..targetedStudents = tStudents
        ..config = currentConfig.toMap()
        ..configId = currentConfig.id
        ..tableItems = items.map((e) => e.toMap()).toList();
      HiveCache.saveTable(table);
    }
    //let get the tables from the cache
    var data = HiveCache.getTables();
    setTable(data);
    //print('length of tables: ${tables!.length}');
    //print('length of items: ${items.length}');

    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Timetable created successfully');
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
          vtp.academicYear = currentAcademicYear;
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
      for (var course in currentCourseList) {
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

  TableItemModel returnTable(
      VenueTimePairModel vtp, ClassCoursePairModel classCoursePair) {
    TableItemModel table = TableItemModel();
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

  List<TableItemModel> generateLiberalsTables() {
    //now we check if day and period in vtp matches day and period in ltp
    List<TableItemModel> items = [];
    for (var ltp in libTimePairs!) {
      for (var vtp in venueTimePairs!) {
        if (!vtp.isBooked && ltp.day == vtp.day && ltp.period == vtp.period) {
          TableItemModel table = TableItemModel();
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
          table.department = '';
          table.creditHours = '';
          table.targetStudents = targetedStudents;
          table.classHasDisability = '';
          table.classSize = '';
          table.venueHasDisability = vtp.isDisabilityAccessible;
          table.classId = '';
          table.courseId = ltp.id;
          table.className = '';
          items.add(table);
          vtp.isBooked = true;
          break;
        }
      }
    }
    return items;
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
      updateConfigList();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Configuration Saved Successfully');
    }
    notifyListeners();
  }

  void updateHasCourse(bool bool) {
    currentConfig.hasCourse = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();

    notifyListeners();
  }

  void updateHasLiberal(bool bool) {
    currentConfig.hasLiberalCourse = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();
    notifyListeners();
  }

  void updateHasClass(bool bool) {
    currentConfig.hasClass = bool;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();
    notifyListeners();
  }

  void setLiberalDay(String p1) {
    currentConfig.liberalCourseDay = p1;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();
    notifyListeners();
  }

  void setLiberalPeriod(String p1) {
    currentConfig.liberalCoursePeriod =
        currentConfig.periods!.firstWhere((element) => element['period'] == p1);
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();
    notifyListeners();
  }

  void setLiberalLevel(p0) {
    currentConfig.liberalLevel = p0;
    //now we save the configuration and reload all the configurations
    HiveCache.addConfigurations(currentConfig);
    HiveCache.addConfigurations(currentConfig);
    updateConfigList();
    notifyListeners();
  }

  void updateTargetedStudents(value) {
    if (value != null && tStudents != value) {
      tStudents = value!;
      //get configurations where semester is equal to current semester from list of configs
      currentConfig = _configList.firstWhereOrNull((element) =>
              element.academicSemester == semester &&
              element.academicYear == _currentAcademicYear &&
              element.targetedStudents == tStudents) ??
          ConfigModel();
      repopulateData();
      notifyListeners();
    }
  }

  List<TableItemModel> generateSpecialVenueTable(
      String? libDays, String? libPeriod, String? libLevel) {
    List<TableItemModel> items = [];
    var specialClassCoursePair = classCoursePairs!
        .where((element) => element.venues!.isNotEmpty)
        .toList();
    //print('Special Course Length: ${specialClassCoursePair.length}');
    for (ClassCoursePairModel ccp in specialClassCoursePair) {
      var venues = ccp.venues;

      for (String v in venues!) {
        if (!ccp.isAssigned) {
          for (VenueTimePairModel vtp in venueTimePairs!) {
            if (vtp.venueName == v) {
              if (!vtp.isBooked) {
                if (vtp.day == libDays &&
                    vtp.period == libPeriod &&
                    ccp.classLevel == libLevel) {
                } else {
                  if (!ccp.isAssigned) {
                    var table = returnTable(vtp, ccp);
                    items.add(table);
                    vtp.isBooked = true;
                    ccp.isAssigned = true;
                  }
                }
              }
            }
            if (ccp.isAssigned) {
              break;
            }
          }
        }
        if (ccp.isAssigned) {
          break;
        }
      }
    }
    return items;
  }

  List<TableItemModel> generateRestOfTables(
      String? libDays, String? libPeriod, String? libLevel) {
    List<TableItemModel> items = [];
    for (ClassCoursePairModel ccp in classCoursePairs!) {
      if (!ccp.isAssigned) {
        for (var venueTimePair in venueTimePairs!) {
          if (venueTimePair.isBooked == false &&
              venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                  'no') {
            if (!(ccp.classLevel!.trimToLowerCase() == libLevel &&
                venueTimePair.day == libDays &&
                venueTimePair.period == libPeriod)) {
              //now we check if venue capacity and the class size are in the same range
              if (int.tryParse(venueTimePair.venueCapacity!)! >=
                      int.tryParse(ccp.classSize!)! &&
                  int.tryParse(venueTimePair.venueCapacity!)! <=
                      int.tryParse(ccp.classSize!)! + 30) {
                //now we check if the class has disability and the venue is disability accessible
                if (ccp.classHasDisability.toString().trimToLowerCase() ==
                    venueTimePair.isDisabilityAccessible
                        .toString()
                        .trimToLowerCase()) {
                  var table = returnTable(venueTimePair, ccp);
                  items.add(table);
                  venueTimePair.isBooked = true;
                  ccp.isAssigned = true;
                  break;
                }
              }
            }
          }
        }
        if (!ccp.isAssigned) {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.isBooked == false &&
                venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                    'no') {
              if (!(ccp.classLevel!.trimToLowerCase() == libLevel &&
                  venueTimePair.day == libDays &&
                  venueTimePair.period == libPeriod)) {
                //now we check if venue capacity and the class size are in the same range
                if (int.tryParse(venueTimePair.venueCapacity!)! >=
                        int.tryParse(ccp.classSize!)! &&
                    int.tryParse(venueTimePair.venueCapacity!)! <=
                        int.tryParse(ccp.classSize!)! + 30) {
                  var table = returnTable(venueTimePair, ccp);
                  items.add(table);
                  venueTimePair.isBooked = true;
                  ccp.isAssigned = true;
                  break;
                }
              }
            }
          }
        }
        if (!ccp.isAssigned) {
          for (var venueTimePair in venueTimePairs!) {
            if (venueTimePair.isBooked == false &&
                venueTimePair.isSpecialVenue.toString().trimToLowerCase() ==
                    'no') {
              if (!(ccp.classLevel!.trimToLowerCase() == libLevel &&
                  venueTimePair.day == libDays &&
                  venueTimePair.period == libPeriod)) {
                var table = returnTable(venueTimePair, ccp);
                items.add(table);
                venueTimePair.isBooked = true;
                ccp.isAssigned = true;
                break;
              }
            }
          }
        }
      }
    }
    return items;
  }

  void exportTables() {
    //Export tables to firebase cloud Firestore

    notifyListeners();
  }

  String? filter;
  String? get getFilter => filter;
  void filterTableItems(String? value) {
    filter = value;
    if (value != null) {
      var check = value.trimToLowerCase();
      filteredTableItems = tableItems
          .where((element) =>
              element.classLevel.toString().trimToLowerCase() == check ||
              element.className.toString().trimToLowerCase() == check ||
              element.courseTitle
                  .toString()
                  .trimToLowerCase()
                  .contains(check) ||
              element.courseCode.toString().trimToLowerCase() == check ||
              element.lecturerName
                  .toString()
                  .trimToLowerCase()
                  .contains(check) ||
              element.venue.toString().trimToLowerCase().contains(check))
          .toList();
    } else {
      filteredTableItems = tableItems;
    }
    notifyListeners();
  }

  void setTable(List<TableModel>? data) {
    listOfTables = data ?? [];
    table = listOfTables.firstWhereOrNull((element) =>
        element.configId == currentConfig.id && element.tableType == tableType);
    tableItems = table != null && table!.tableItems != null
        ? table!.tableItems!.map((e) {
            return TableItemModel.fromMap(e);
          }).toList()
        : [];
    if (filter != null) {
      filterTableItems(filter);
    } else {
      filteredTableItems = tableItems;
      notifyListeners();
    }
  }

  String tableType = 'Provisional';
  String get getTableType => tableType;
  void setTableType(value) {
    if (value != null && tableType != value) {
      tableType = value;
      table = listOfTables.firstWhereOrNull((element) =>
          element.configId == currentConfig.id &&
          element.tableType == tableType);
      tableItems = table != null && table!.tableItems != null
          ? table!.tableItems!.map((e) {
              return TableItemModel.fromMap(e);
            }).toList()
          : [];
      filteredTableItems = tableItems;
      notifyListeners();
    }
  }

  void clearTable() {
    if (table != null) {
      HiveCache.deleteTable(table!.id!);
      var data = HiveCache.getTables();
      setTable(data);
    }
  }

  TableItemModel? selectedItem;
  TableItemModel? get getSelectItem => selectedItem;
  void setSelectedItem(TableItemModel? value) {
    selectedItem = value;
    notifyListeners();
  }

  void swapTableItems(TableItemModel? selectedItem, TableItemModel? newItem) {
    if (selectedItem != null) {
      var selectedIndex = tableItems.indexOf(selectedItem);
      var newIndex = tableItems.indexOf(newItem!);
      //swap the following values
      // venue, day, period, venueId, periodMap
      // and save them back to the database
      if (newItem.id != null || newItem.className != null) {
        var venue = selectedItem.venue;
        var day = selectedItem.day;
        var period = selectedItem.period;
        var venueId = selectedItem.venueId;
        var periodMap = selectedItem.periodMap;
        selectedItem.venue = newItem.venue;
        selectedItem.day = newItem.day;
        selectedItem.period = newItem.period;
        selectedItem.venueId = newItem.venueId;
        selectedItem.periodMap = newItem.periodMap;
        newItem.venue = venue;
        newItem.day = day;
        newItem.period = period;
        newItem.venueId = venueId;
        newItem.periodMap = periodMap;
        //put them back to the list of table items and save them back to the database

        tableItems[selectedIndex] = selectedItem;
        tableItems[newIndex] = newItem;
      } else {
        //just change the venue, day, period, venueId, periodMap of the selected item
        selectedItem.venue = newItem.venue;
        selectedItem.day = newItem.day;
        selectedItem.period = newItem.period;
        selectedItem.venueId = newItem.venueId;
        selectedItem.periodMap = newItem.periodMap;
        tableItems[selectedIndex] = selectedItem;
      }
      table!.tableItems = tableItems.map((e) {
        return e.toMap();
      }).toList();
      HiveCache.saveTable(table!);
      // get tables back
      var data = HiveCache.getTables();
      setTable(data);
      notifyListeners();
    }
  }
}
