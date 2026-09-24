import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/config/app_config.dart';

part 'person_model.g.dart';

@JsonSerializable()
class PersonModel extends Equatable {
  final int id;
  final String name;
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  final double? popularity;

  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
    this.popularity,
  });

  String get fullProfileUrl => profilePath != null 
      ? '${AppConfig.imageBaseUrl}/w185$profilePath' 
      : 'https://via.placeholder.com/185x278';

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);

  @override
  List<Object?> get props => [id, name, profilePath, knownForDepartment, popularity];
}