class DaysModel {
  String? day;
  bool? isRegular;
  bool? isEvening;
  bool? isWeekend;

  DaysModel({
    this.day,
    this.isRegular,
    this.isEvening,
    this.isWeekend,
  });

  DaysModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    isRegular = json['isRegular'];
    isEvening = json['isEvening'];
    isWeekend = json['isWeekend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['isRegular'] = isRegular;
    data['isEvening'] = isEvening;
    data['isWeekend'] = isWeekend;
    return data;
  }

  DaysModel clear() {
    day = null;
    isRegular = null;
    isEvening = null;
    isWeekend = null;
    return this;
  }
}
