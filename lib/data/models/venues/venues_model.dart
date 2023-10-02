// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hive/hive.dart';
part 'venues_model.g.dart';
@HiveType(typeId: 15)
class VenuesModel {
  @HiveField(0)
  String? venueName;
  @HiveField(1)
  String? isSpecial;
  @HiveField(2)
  String? capacity;
  @HiveField(3)
  String? isDisabledFriendly;
  VenuesModel({
    this.venueName,
    this.isSpecial,
    this.capacity,
    this.isDisabledFriendly,
  });

  VenuesModel copyWith({
    String? venueName,
    String? isSpecial,
    String? capacity,
    String? isDisabledFriendly,
  }) {
    return VenuesModel(
      venueName: venueName ?? this.venueName,
      isSpecial: isSpecial ?? this.isSpecial,
      capacity: capacity ?? this.capacity,
      isDisabledFriendly: isDisabledFriendly ?? this.isDisabledFriendly,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'venueName': venueName,
      'isSpecial': isSpecial,
      'capacity': capacity,
      'isDisabledFriendly': isDisabledFriendly,
    };
  }

  factory VenuesModel.fromMap(Map<String, dynamic> map) {
    return VenuesModel(
      venueName: map['venueName'] != null ? map['venueName'] as String : null,
      isSpecial: map['isSpecial'] != null ? map['isSpecial'] as String : null,
      capacity: map['capacity'] != null ? map['capacity'] as String : null,
      isDisabledFriendly: map['isDisabledFriendly'] != null ? map['isDisabledFriendly'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VenuesModel.fromJson(String source) => VenuesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VenuesModel(venueName: $venueName, isSpecial: $isSpecial, capacity: $capacity, isDisabledFriendly: $isDisabledFriendly)';
  }

  @override
  bool operator ==(covariant VenuesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.venueName == venueName &&
      other.isSpecial == isSpecial &&
      other.capacity == capacity &&
      other.isDisabledFriendly == isDisabledFriendly;
  }

  @override
  int get hashCode {
    return venueName.hashCode ^
      isSpecial.hashCode ^
      capacity.hashCode ^
      isDisabledFriendly.hashCode;
  }
}
