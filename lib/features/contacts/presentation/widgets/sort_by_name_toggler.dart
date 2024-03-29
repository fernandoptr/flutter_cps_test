import 'package:flutter/material.dart';

class SortByNameToggler extends StatelessWidget {
  final bool isSortAscByName;
  final void Function() onSortByNameToggled;

  const SortByNameToggler({
    super.key,
    required this.isSortAscByName,
    required this.onSortByNameToggled,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onSortByNameToggled,
      icon: Row(
        children: [
          Text(isSortAscByName ? 'A-Z' : 'Z-A'),
          const SizedBox(width: 2.0),
          Transform.flip(
            flipY: isSortAscByName,
            child: const Icon(Icons.sort),
          ),
        ],
      ),
    );
  }
}
