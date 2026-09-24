import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int id;
  final String name;
  final String? profileUrl;
  final String? knownForDepartment;
  final double? popularity;

  const Person({
    required this.id,
    required this.name,
    this.profileUrl,
    this.knownForDepartment,
    this.popularity,
  });

  String get formattedPopularity => popularity != null 
      ? '${popularity!.toStringAsFixed(1)}' 
      : 'N/A';

  @override
  List<Object?> get props => [id, name, profileUrl, knownForDepartment, popularity];
}