import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/home/home_screen.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/product/screens/products_screen.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/shoppingCart_screen.dart';
import 'package:huicrochet_mobile/modules/profile/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navigation extends StatefulWidget {
  const Navigation(
      {super.key, required this.getPaymentMethod, this.initialIndex = 0});
  final GetPayment getPaymentMethod;
  final int initialIndex;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const HomeScreen(),
      const ProductsScreen(),
      ShoppingcartScreen(getPaymentMethod: widget.getPaymentMethod),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/PhYarn.svg',
                width: 30,
                height: 30,
                color: _selectedIndex == 1
                    ? const Color.fromRGBO(242, 148, 165, 1)
                    : Colors.grey,
              ),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(242, 148, 165, 1),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
