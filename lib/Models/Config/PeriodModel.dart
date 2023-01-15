// ignore_for_file: file_names

class PeriodModel {
  String? period;
  String? startTime;
  String? endTime;
  bool? isRegular;
  bool? isEvening;
  bool? isWeekend;

  PeriodModel({
    this.period,
    this.startTime,
    this.endTime,
    this.isRegular,
    this.isEvening,
    this.isWeekend,
  });

  PeriodModel.fromJson(Map<String, dynamic> json) {
    period = json['period'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isRegular = json['isRegular'];
    isEvening = json['isEvening'];
    isWeekend = json['isWeekend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['period'] = period;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['isRegular'] = isRegular;
    data['isEvening'] = isEvening;
    data['isWeekend'] = isWeekend;
    return data;
  }

  PeriodModel clear() {
    period = null;
    startTime = null;
    endTime = null;
    isRegular = null;
    isEvening = null;
    isWeekend = null;
    return this;
  }
}
