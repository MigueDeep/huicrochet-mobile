import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/modules/auth/screens/login_screen.dart';
import 'package:huicrochet_mobile/modules/navigation/navigation.dart';
import 'package:huicrochet_mobile/modules/profile/addAdress_screen.dart';
import 'package:huicrochet_mobile/modules/profile/adresses_screen.dart';
import 'package:huicrochet_mobile/modules/profile/info_screen.dart';
import 'package:huicrochet_mobile/modules/profile/orderDetails_screen.dart';
import 'package:huicrochet_mobile/modules/profile/orders_screen.dart';
import 'package:huicrochet_mobile/modules/profile/profile_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass1_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass2_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass3_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/register_screen.dart';
import 'package:huicrochet_mobile/modules/profile/purchaseDetails.dart';
import 'package:huicrochet_mobile/widgets/splash_screen.dart';
import 'package:huicrochet_mobile/modules/home/home_screen.dart';
import 'package:huicrochet_mobile/modules/product/productDetail_screen.dart';
import 'package:huicrochet_mobile/modules/product/products_screen.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/shoppingcart_screen.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/mailing_address_cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/navigation': (context) => const Navigation(),
        '/register': (context) => const RegisterScreen(),
        '/recoverpass1': (context) => const Recoverpass1Screen(),
        '/recoverpass2': (context) => const Recoverpass2Screen(),
        '/recoverpass3': (context) => const Recoverpass3Screen(),
        '/home': (context) => const HomeScreen(),
        '/product-detail': (context) => const ProductDetail(),
        '/products': (context) => const ProductsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/info': (context) => const InfoScreen(),
        '/addresses': (context) => const AddressesScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/addAddress': (context) => const AddadressScreen(),
        '/shopping-cart': (context) => const ShoppingcartScreen(),
        '/mailing-address': (context) => const MailingAddressCart()
        '/orderDetails': (context) => const OrderDetailsScreen(),
        '/purchaseDetails': (context) => const PurchasedetailsScreen(),
      },
    );
  }
}
