import 'package:flutter/material.dart';

class DisciplineModel {
  final String id;
  final String name;
  final String category; // 'LAUF', 'SPRUNG', 'WURF'
  final IconData icon;
  bool isEnabled;

  DisciplineModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.isEnabled = true,
  });

  DisciplineModel copyWith({
    String? name,
    String? category,
    IconData? icon,
    bool? isEnabled,
  }) {
    return DisciplineModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'isEnabled': isEnabled,
      };

  factory DisciplineModel.fromJson(Map<String, dynamic> json) {
    // Map category to icon
    final cat = json['category'] as String? ?? 'LAUF';
    IconData iconData = Icons.directions_run;
    if (cat == 'SPRUNG') iconData = Icons.height;
    if (cat == 'WURF') iconData = Icons.fitness_center;

    return DisciplineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: cat,
      icon: iconData,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  static List<DisciplineModel> defaultDisciplines() => [
        DisciplineModel(
          id: 'd1',
          name: '100m Sprint',
          category: 'LAUF',
          icon: Icons.directions_run,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd2',
          name: 'Weitsprung',
          category: 'SPRUNG',
          icon: Icons.height,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd3',
          name: 'Kugelstoßen',
          category: 'WURF',
          icon: Icons.fitness_center,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd4',
          name: '3.000m Ausdauerlauf',
          category: 'LAUF',
          icon: Icons.timer,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd5',
          name: 'Hochsprung',
          category: 'SPRUNG',
          icon: Icons.airline_seat_legroom_extra,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd6',
          name: 'Speerwurf',
          category: 'WURF',
          icon: Icons.sports_kabaddi,
          isEnabled: true,
        ),
        DisciplineModel(
          id: 'd7',
          name: '400m Staffellauf',
          category: 'LAUF',
          icon: Icons.speed,
          isEnabled: false,
        ),
        DisciplineModel(
          id: 'd8',
          name: 'Schlauchballwurf',
          category: 'WURF',
          icon: Icons.sports_baseball,
          isEnabled: true,
        ),
      ];
}
