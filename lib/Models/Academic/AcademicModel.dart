class AcademicModel{
  String ? id;
  String ? name;
  String ? startYear;
  String ? endYear;
  String ? semester;
  DateTime ? createdAt;

  AcademicModel({this.id, this.name, this.startYear, this.endYear, this.semester, this.createdAt});

  AcademicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startYear = json['startYear'];
    endYear = json['endYear'];
    semester = json['semester'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['startYear'] = startYear;
    data['endYear'] = endYear;
    data['semester'] = semester;
    data['createdAt'] = createdAt.toString();
    return data;
  }
}