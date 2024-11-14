import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final List<String> colorCodes;

  const ColorSelector({super.key, required this.colorCodes});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.colorCodes.isEmpty) {
      // Mostrar mensaje si no hay colores
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
