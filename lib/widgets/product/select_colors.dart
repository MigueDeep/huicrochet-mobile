import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({super.key});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selectedColorIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = 0;
            });
          },
          child: Icon(
            _selectedColorIndex == 0 ? Icons.radio_button_checked : Icons.circle,
            color: Colors.black,
            size: 30,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = 1; 
            });
          },
          child: Icon(
            _selectedColorIndex == 1 ? Icons.radio_button_checked : Icons.circle,
            color: Colors.blue,
            size: 30,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = 2; 
            });
          },
          child: Icon(
            _selectedColorIndex == 2 ? Icons.radio_button_checked : Icons.circle,
            color: Colors.brown,
            size: 30,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = 3; 
            });
          },
          child: Icon(
            _selectedColorIndex == 3 ? Icons.radio_button_checked : Icons.circle,
            color: Colors.deepOrange,
            size: 30,
          ),
        ),
      ],
    );
  }
}
