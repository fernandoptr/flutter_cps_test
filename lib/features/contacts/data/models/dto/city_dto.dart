import '../../../domain/entities/entities.dart';

class CityDto extends City {
  const CityDto({required super.id, required super.name});

  factory CityDto.fromJson(Map<String, dynamic> json) {
    return CityDto(
      id: json['id'],
      name: json['name'],
    );
  }
}
