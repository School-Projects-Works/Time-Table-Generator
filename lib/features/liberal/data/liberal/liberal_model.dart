import 'package:hive/hive.dart';
part 'liberal_model.g.dart';

@HiveType(typeId: 5)
class LiberalModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? lecturerId;
  @HiveField(4)
  String? lecturerName;
  @HiveField(5)
  String? lecturerEmail;
  @HiveField(6)
  String? year;
  @HiveField(7)
  String? studyMode;
  @HiveField(8)
  String? semester;
  LiberalModel({
    this.id,
    this.code,
    this.title,
    this.lecturerId,
    this.lecturerName,
    this.lecturerEmail,
    this.year,
    this.studyMode,
    this.semester,
  });

}
