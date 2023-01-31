// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PeriodModel {
  String? period;
  String? startTime;
  String? endTime;
  PeriodModel({
    this.period,
    this.startTime,
    this.endTime,
  });

  PeriodModel copyWith({
    String? period,
    String? startTime,
    String? endTime,
  }) {
    return PeriodModel(
      period: period ?? this.period,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'period': period,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory PeriodModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return PeriodModel();
    }
    return PeriodModel(
      period: map['period'] != null ? map['period'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodModel.fromJson(String source) =>
      PeriodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PeriodModel(period: $period, startTime: $startTime, endTime: $endTime)';

  @override
  bool operator ==(covariant PeriodModel other) {
    if (identical(this, other)) return true;

    return other.period == period &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => period.hashCode ^ startTime.hashCode ^ endTime.hashCode;

  PeriodModel clear() {
    return PeriodModel(
      period: null,
      startTime: null,
      endTime: null,
    );
  }
}
