import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';

class CityFilterPopupMenuButton extends StatelessWidget {
  final String? cityName;
  final List<City> cities;
  final void Function(City) onCitySelected;

  const CityFilterPopupMenuButton({
    super.key,
    this.cityName,
    required this.onCitySelected,
    required this.cities,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Row(
        children: [
          Text(cityName ?? 'All'),
          const SizedBox(width: 2.0),
          const Icon(Icons.filter_alt_outlined),
        ],
      ),
      itemBuilder: (_) => cities.map((city) {
        return PopupMenuItem(
          value: city,
          onTap: () => onCitySelected(city),
          child: Text(city.name),
        );
      }).toList(),
    );
  }
}
