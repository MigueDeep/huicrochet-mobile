import 'package:flutter/material.dart';

class CategoryMenu extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  CategoryMenu({required this.categories, required this.onCategorySelected, required String selectedCategory});

  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  String selectedCategory = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.categories.map((categoryName) {
        bool isSelected = categoryName == selectedCategory;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedCategory = categoryName;
                });
                widget.onCategorySelected(categoryName);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
      }).toList(),
    );
  }
}
