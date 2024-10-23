import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/shopping-cart');
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Icon(
            Icons.format_bold,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
