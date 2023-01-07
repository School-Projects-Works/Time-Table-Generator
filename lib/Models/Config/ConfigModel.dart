class ConfigModel{
  String? id;
  String? academicName;
  String? academicYear;
  String? academicSemester;
  List<Map<String,dynamic>>?days;
  List<Map<String,dynamic>>?periods;

  ConfigModel({
    this.id,
    this.academicName,
    this.academicYear,
    this.academicSemester,
    this.days,
    this.periods,
  });

  factory ConfigModel.fromJson(Map<String,dynamic> json){
    return ConfigModel(
      id: json['id'],
      academicName: json['academicName'],
      academicYear: json['academicYear'],
      academicSemester: json['academicSemester'],
      days: json['days'],
      periods: json['periods'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'academicName': academicName,
      'academicYear': academicYear,
      'academicSemester': academicSemester,
      'days': days,
      'periods': periods,
    };
  }
}