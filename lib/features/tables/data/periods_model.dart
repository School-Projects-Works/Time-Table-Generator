import 'dart:convert';


class PeriodModel {
  String period;
  String startTime;
  String endTime;
  int position;
  bool isBreak;
  PeriodModel({
    required this.period,
     this.startTime = '',
     this.endTime= '',
    required this.position,
     this.isBreak=false,
  });

  PeriodModel copyWith({
    String? period,
    String? startTime,
    String? endTime,
    int? position,
    bool? isBreak,
  }) {
    return PeriodModel(
      period: period ?? this.period,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      position: position ?? this.position,
      isBreak: isBreak ?? this.isBreak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'startTime': startTime,
      'endTime': endTime,
      'position': position,
      'isBreak': isBreak,
    };
  }

  factory PeriodModel.fromMap(Map<String, dynamic> map) {
    return PeriodModel(
      period: map['period'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      position: map['position']?.toInt() ?? 0,
      isBreak: map['isBreak'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodModel.fromJson(String source) => PeriodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PeriodModel(period: $period, startTime: $startTime, endTime: $endTime, position: $position, isBreak: $isBreak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PeriodModel &&
      other.period == period &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.position == position &&
      other.isBreak == isBreak;
  }

  @override
  int get hashCode {
    return period.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      position.hashCode ^
      isBreak.hashCode;
  }
}
