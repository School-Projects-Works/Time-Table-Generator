import 'package:hive/hive.dart';

part 'LiberalTimePairModel.g.dart';

@HiveType(typeId: 7)
class LiberalTimePairModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? umiqueId;
  @HiveField(2)
  String? day;
  @HiveField(3)
  String? period;
  @HiveField(4)
  String? courseCode;
  @HiveField(5)
  String? level;
  @HiveField(6)
  String? lecturerName;
  @HiveField(7)
  String? lecturerEmail;
  @HiveField(8)
  String? lecturerPhone;

  LiberalTimePairModel(
      {this.id,
      this.umiqueId,
      this.day,
      this.period,
      this.courseCode,
      this.level,
      this.lecturerName,
      this.lecturerEmail,
      this.lecturerPhone});

  factory LiberalTimePairModel.fromJson(Map<String, dynamic> json) {
    return LiberalTimePairModel(
      id: json['id'],
      umiqueId: json['umiqueId'],
      day: json['day'],
      period: json['period'],
      courseCode: json['courseCode'],
      level: json['level'],
      lecturerName: json['lecturerName'],
      lecturerEmail: json['lecturerEmail'],
      lecturerPhone: json['lecturerPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['umiqueId'] = umiqueId;
    data['day'] = day;
    data['period'] = period;
    data['courseCode'] = courseCode;
    data['level'] = level;
    data['lecturerName'] = lecturerName;
    data['lecturerEmail'] = lecturerEmail;
    data['lecturerPhone'] = lecturerPhone;
    return data;
  }
}
