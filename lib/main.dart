import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/auth/screens/login_screen.dart';
import 'package:huicrochet_mobile/modules/navigation/navigation.dart';
import 'package:huicrochet_mobile/modules/profile/address/addAdress_screen.dart';
import 'package:huicrochet_mobile/modules/profile/address/adresses_screen.dart';
import 'package:huicrochet_mobile/modules/profile/info_screen.dart';
import 'package:huicrochet_mobile/modules/profile/orderDetails_screen.dart';
import 'package:huicrochet_mobile/modules/profile/orders_screen.dart';
import 'package:huicrochet_mobile/modules/profile/profile_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/recoverPass1_screen.dart';
import 'package:huicrochet_mobile/modules/auth/screens/register_screen.dart';
import 'package:huicrochet_mobile/modules/profile/purchaseDetails.dart';
import 'package:huicrochet_mobile/widgets/splash_screen.dart';
import 'package:huicrochet_mobile/modules/home/home_screen.dart';
import 'package:huicrochet_mobile/modules/product/productDetail_screen.dart';
import 'package:huicrochet_mobile/modules/product/products_screen.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/shoppingcart_screen.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/mailing_address_cart.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/payment_methods.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/add_payment_method.dart';
import 'package:provider/provider.dart';
import 'package:huicrochet_mobile/modules/profile/my_payment_methods.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ErrorState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/navigation': (context) => const Navigation(),
          '/register': (context) => const RegisterScreen(),
          '/recoverpass1': (context) => const Recoverpass1Screen(),
          '/home': (context) => const HomeScreen(),
          '/product-detail': (context) => const ProductDetail(),
          '/products': (context) => const ProductsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/info': (context) => const InfoScreen(),
          '/addresses': (context) => const AddressesScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/addAddress': (context) => const AddadressScreen(),
          '/shopping-cart': (context) => const ShoppingcartScreen(),
          '/mailing-address': (context) => const MailingAddressCart(),
          '/orderDetails': (context) => const OrderDetailsScreen(),
          '/purchaseDetails': (context) => const PurchasedetailsScreen(),
          '/payment-methods': (context) => const PaymentMethods(),
          '/add-payment-method': (context) => const AddPaymentMethod(),
          '/my-payment-methods': (context) => const MyPaymentMethods()
        },
      ),
    );
  }
}
