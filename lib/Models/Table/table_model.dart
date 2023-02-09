// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'table_model.g.dart';

@HiveType(typeId: 5)
class TableModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? configId;
  @HiveField(2)
  String? academicYear;
  @HiveField(3)
  String? academicSemester;
  @HiveField(4)
  String? targetedStudents;
  @HiveField(5)
  Map<String, dynamic>? config;
  @HiveField(6)
  List<Map<String, dynamic>>? tableItems;
  @HiveField(7)
  String? tableType;
  @HiveField(8)
  String? tableSchoolName;
  @HiveField(9)
  String? tableDescription;
  @HiveField(10)
  String? tableFooter;
  @HiveField(11)
  String? signature;

  TableModel({
    this.id,
    this.configId,
    this.academicYear,
    this.academicSemester,
    this.targetedStudents,
    this.config,
    this.tableItems,
    this.tableType,
    this.tableSchoolName,
    this.tableDescription,
    this.tableFooter,
    this.signature,
  });

  TableModel copyWith({
    String? id,
    String? configId,
    String? academicYear,
    String? academicSemester,
    String? targetedStudents,
    Map<String, dynamic>? config,
    List<Map<String, dynamic>>? tableItems,
    String? tableType,
    String? tableSchoolName,
    String? tableDescription,
    String? tableFooter,
    String? signature,
  }) {
    return TableModel(
      id: id ?? this.id,
      configId: configId ?? this.configId,
      academicYear: academicYear ?? this.academicYear,
      academicSemester: academicSemester ?? this.academicSemester,
      targetedStudents: targetedStudents ?? this.targetedStudents,
      config: config ?? this.config,
      tableItems: tableItems ?? this.tableItems,
      tableType: tableType ?? this.tableType,
      tableSchoolName: tableSchoolName ?? this.tableSchoolName,
      tableDescription: tableDescription ?? this.tableDescription,
      tableFooter: tableFooter ?? this.tableFooter,
      signature: signature ?? this.signature,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'configId': configId,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
      'targetedStudents': targetedStudents,
      'config': config,
      'tableItems': tableItems,
      'tableType': tableType,
      'tableSchoolName': tableSchoolName,
      'tableDescription': tableDescription,
      'tableFooter': tableFooter,
      'signature': signature,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'] as String?,
      configId: map['configId'] as String?,
      academicYear: map['academicYear'] as String?,
      academicSemester: map['academicSemester'] as String?,
      targetedStudents: map['targetedStudents'] as String?,
      config: map['config'] as Map<String, dynamic>?,
      tableItems: map['tableItems'] as List<Map<String, dynamic>>?,
      tableType: map['tableType'] as String?,
      tableSchoolName: map['tableSchoolName'] as String?,
      tableDescription: map['tableDescription'] as String?,
      tableFooter: map['tableFooter'] as String?,
      signature: map['signature'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TableModel.fromJson(String source) =>
      TableModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TableModel(id: $id, configId: $configId, academicYear: $academicYear, academicSemester: $academicSemester, targetedStudents: $targetedStudents, config: $config, tableItems: $tableItems, tableType: $tableType, tableSchoolName: $tableSchoolName, tableDescription: $tableDescription, tableFooter: $tableFooter)';
  }

  @override
  bool operator ==(covariant TableModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.configId == configId &&
        other.academicYear == academicYear &&
        other.academicSemester == academicSemester &&
        other.targetedStudents == targetedStudents &&
        mapEquals(other.config, config) &&
        listEquals(other.tableItems, tableItems) &&
        other.tableType == tableType &&
        other.tableSchoolName == tableSchoolName &&
        other.tableDescription == tableDescription &&
        other.tableFooter == tableFooter &&
        other.signature == signature;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        configId.hashCode ^
        academicYear.hashCode ^
        academicSemester.hashCode ^
        targetedStudents.hashCode ^
        config.hashCode ^
        tableItems.hashCode ^
        tableType.hashCode ^
        tableSchoolName.hashCode ^
        tableDescription.hashCode ^
        tableFooter.hashCode ^
        signature.hashCode;
  }
}
