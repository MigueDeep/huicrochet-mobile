import 'package:flutter/material.dart';

Widget categoryMenu(String categoryName) {
  bool isSelected = categoryName == 'Todas';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}