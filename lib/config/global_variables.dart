import 'package:flutter/material.dart';
String ip = '34.203.104.87';

Color getColor(String key) {
  return colors[key] ?? Colors.transparent;
}
const Map<String, Color> colors = {
  'pink': Color.fromRGBO(242, 148, 165, 1),
  'violet': Color.fromARGB(255, 207, 82, 151),
  'brown': Color.fromRGBO(64, 47, 47, 1),
  'wine': Color.fromRGBO(130, 48, 56, 1),
  'gray': Color.fromRGBO(242, 242, 242, 1)
};