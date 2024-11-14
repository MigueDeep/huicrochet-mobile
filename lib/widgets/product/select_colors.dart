import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final List<String> colorCodes;
  final ValueChanged<int> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colorCodes,
    required this.onColorSelected,
  });

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.colorCodes.isEmpty) {
      return Text(
        'Colores no disponibles',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

    return Row(
      children: List.generate(widget.colorCodes.length, (index) {
        final color = Color(int.parse(widget.colorCodes[index].replaceFirst('#', '0xff')));
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = index;
            });
            widget.onColorSelected(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Icon(
              _selectedColorIndex == index ? Icons.radio_button_checked : Icons.circle,
              color: color,
              size: 30,
            ),
          ),
        );
      }),
    );
  }
}
