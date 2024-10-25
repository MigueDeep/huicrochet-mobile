import 'package:flutter/material.dart';

class SelectAddressCard extends StatefulWidget {
  final String name;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectAddressCard({
    super.key,
    required this.name,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectAddressCard> createState() => _SelectAddressCardState();
}

class _SelectAddressCardState extends State<SelectAddressCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95, 
        child: Card(
          color: widget.isSelected
              ? const Color.fromRGBO(242, 148, 165, 0.35)
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( 
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      widget.isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: widget.isSelected
                          ? Color.fromRGBO(242, 148, 165, 1)
                          : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
