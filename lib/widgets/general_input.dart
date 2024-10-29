import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInput extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller;
  final Color borderColor;
  final Color cursorColor;
  final int? maxLength;
  final bool isNumeric;
  final bool isAlphabetic;

  const GeneralInput({
    super.key,
    required this.label,
    required this.inputType,
    required this.controller,
    this.borderColor = const Color.fromRGBO(130, 48, 56, 1),
    this.cursorColor = const Color.fromRGBO(130, 48, 56, 1),
    this.maxLength,
    this.isNumeric = false,
    this.isAlphabetic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: borderColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: cursorColor,
          keyboardType: isNumeric
              ? TextInputType.number
              : isAlphabetic
                  ? TextInputType.text
                  : inputType,
          inputFormatters: isNumeric
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : isAlphabetic
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ]
                  : [],
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: borderColor,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
