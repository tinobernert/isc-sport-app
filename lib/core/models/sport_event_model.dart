import 'discipline_model.dart';
import 'student_result_model.dart';

class SportEventModel {
  final String id;
  String name;
  String description;
  String block; // 'A', 'B', 'C'
  DateTime date;
  bool isCurrent;
  List<DisciplineModel> disciplines;
  List<StudentResultModel> results;

  SportEventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.block,
    required this.date,
    required this.isCurrent,
    List<DisciplineModel>? disciplines,
    List<StudentResultModel>? results,
  })  : disciplines = disciplines ?? DisciplineModel.defaultDisciplines(),
        results = results ?? StudentResultModel.sampleResults();

  SportEventModel copyWith({
    String? name,
    String? description,
    String? block,
    DateTime? date,
    bool? isCurrent,
    List<DisciplineModel>? disciplines,
    List<StudentResultModel>? results,
  }) {
    return SportEventModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      block: block ?? this.block,
      date: date ?? this.date,
      isCurrent: isCurrent ?? this.isCurrent,
      disciplines: disciplines ?? this.disciplines.map((d) => d.copyWith()).toList(),
      results: results ?? this.results,
    );
  }
}
