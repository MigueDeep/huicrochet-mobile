import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/kernel/utils/dio_client.dart';
import 'package:huicrochet_mobile/modules/auth/datasource/user_auth_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/auth/repositories/user_auth_repository.dart';
import 'package:huicrochet_mobile/modules/auth/screens/login_screen.dart';
import 'package:huicrochet_mobile/modules/auth/use_cases/login_use_case.dart';
import 'package:huicrochet_mobile/modules/navigation/navigation.dart';
import 'package:huicrochet_mobile/modules/product/datasource/product_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/product/repositories/product_repository.dart';
import 'package:huicrochet_mobile/modules/product/use_cases/fetch_products_data.dart';
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
import 'package:huicrochet_mobile/payment-methods/datasource/payment_method_data_source.dart';
import 'package:huicrochet_mobile/payment-methods/repositories/payment_method_repository.dart';
import 'package:huicrochet_mobile/payment-methods/use_cases/create_payment.dart';
import 'package:huicrochet_mobile/payment-methods/use_cases/delete_payment.dart';
import 'package:huicrochet_mobile/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/payment-methods/use_cases/update_payment.dart';
import 'package:huicrochet_mobile/widgets/splash_screen.dart';
import 'package:huicrochet_mobile/modules/home/home_screen.dart';
import 'package:huicrochet_mobile/modules/product/screens/productDetail_screen.dart';
import 'package:huicrochet_mobile/modules/product/screens/products_screen.dart';
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
    final dioClient = Dio(BaseOptions(baseUrl: 'http://${ip}:8080/api-crochet'));
    final userRemoteDataSource = UserRemoteDataSourceImpl(dioClient: dioClient);
    final userRepository = UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
    final loginUseCase = LoginUseCase(userRepository: userRepository);


    final productRemoteDataSource = ProductRemoteDataSourceImpl(dioClient:dioClient);
    final productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
    final getProductsUseCase = FetchProductsData(repository: productRepository);

    final PaymentMethodRemoteDataSource = PaymentMethodRemoteDataSourceImpl(dioClient: dioClient);
    final PaymentMethodRepository = PaymentMethodRepositoryImpl(remoteDataSource: PaymentMethodRemoteDataSource);
    final getPaymentMethod = GetPayment(repository: PaymentMethodRepository);
    final createPaymentMethod = CreatePayment(repository: PaymentMethodRepository);
    final updatePaymentMethod = UpdatePayment(repository: PaymentMethodRepository);
    final deletePaymentMethod = DeletePayment(repository: PaymentMethodRepository);

    
    return Provider(create: (context) => ErrorState(),
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
           '/login': (context) => LoginScreen(loginUseCase: loginUseCase),
          '/navigation': (context) => const Navigation(),
          '/register': (context) => const RegisterScreen(),
          '/recoverpass1': (context) => const Recoverpass1Screen(),
          '/home': (context) => const HomeScreen(),
          '/product-detail': (context) => const ProductDetail(),
          '/products': (context) =>  ProductsScreen(getProductsUseCase: getProductsUseCase),
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
          '/my-payment-methods': (context)=> MyPaymentMethods(getPaymentMethod: getPaymentMethod)
        },
      ),
    );
         
       
    
  }
}
