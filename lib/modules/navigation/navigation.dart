import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/home/home_screen.dart';
import 'package:huicrochet_mobile/modules/product/products_screen.dart';
import 'package:huicrochet_mobile/modules/profile/adresses_screen.dart';
import 'package:huicrochet_mobile/modules/profile/orders_screen.dart';
import 'package:huicrochet_mobile/modules/profile/profile_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProductsScreen(),
    OrdersScreen(),
    ProfileScreen()
  ];
  void _onItemTapped(int index) {
    //Indicar un cambio en el estado de la aplicación
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_outlined),
            label: 'Productos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Órdenes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(242, 148, 165, 1),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
