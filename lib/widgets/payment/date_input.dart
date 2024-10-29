import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';

class DateInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const DateInput({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  void _selectMonthYear(BuildContext context) {
    showMonthPicker(
      context,
      onSelected: (month, year) {
        if (month != null && year != null) {
          setState(() {
            widget.controller.text = "$month/$year";
          });
        }
      },
      initialSelectedMonth: DateTime.now().month,
      initialSelectedYear: DateTime.now().year,
      firstYear: 2024,
      lastYear: 2034,
      selectButtonText: 'Aceptar', 
      cancelButtonText: 'Cancelar', 
      highlightColor: const Color.fromRGBO(242, 148, 165, 1),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      contentBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.grey[200],
     
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color.fromRGBO(130, 48, 56, 1),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectMonthYear(context), 
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              cursorColor: const Color.fromRGBO(130, 48, 56, 1),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(130, 48, 56, 1),
                    width: 2.0,
                  ),
                ),
                hintText: 'MM/YYYY',
              ),
              keyboardType: TextInputType.none,
            ),
          ),
        ),
      ],
    );
  }
}
