import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/entities/order.dart';
import 'package:huicrochet_mobile/modules/profile/orders/orderDetails_screen.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? name;
  String? userImg;
  final LoaderController _loaderController = LoaderController();

  bool emptyOrders = false;
  List<Order> ordersList = [];

  Future<void> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      final response =
          await dio.get('/order/user/${prefs.getString('userId')}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);

        if (jsonData['error'] != null && jsonData['error']) {
          throw Exception(
              'Error en la respuesta del backend: ${jsonData['message']}');
        }

        final data = jsonData['data'];
        setState(() {
          if (data == null || data.isEmpty) {
            emptyOrders = true;
            ordersList = [];
          } else {
            try {
              ordersList = List<Order>.from(
                  data.map((orderJson) => Order.fromJson(orderJson)));
              emptyOrders = false;
            } catch (e) {
              print('Error al mapear Order.fromJson: $e');
              rethrow;
            }
          }
        });
      } else if (response.statusCode == 204) {
        setState(() {
          emptyOrders = true;
          ordersList = [];
        });
      } else {
        throw Exception('Error al obtener las órdenes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las órdenes: $e');
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
    } finally {
      setState(() {
        _loaderController.hide();
      });
    }
  }

  String translateOrderState(String orderState) {
    switch (orderState) {
      case 'PENDING':
        return 'Pendiente';
      case 'PROCESSED':
        return 'En Proceso';
      case 'SHIPPED':
        return 'Enviado';
      case 'DELIVERED':
        return 'Entregado';
      default:
        return 'Desconocido';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      getProfile();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://${ip}:8080/$imageName';
    setState(() {
      name = prefs.getString('fullName')!;
      userImg = prefs.getString('userImg');
      userImg = profileImage;
    });
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Órdenes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                userImg ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  String initials = name != null ? getInitials(name!) : '??';
                  return CircleAvatar(
                    backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                    child:
                        Text(initials, style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              name ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Text(
                'Órdenes',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: colors['wine'],
                ),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ordersList.map((order) {
                  if (emptyOrders) {
                    return Center(
                      child: Text(
                        'No hay órdenes que mostrar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            id: order.id,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                order.shoppingCart.cartItems.isNotEmpty
                                    ? 'http://${ip}:8080/${order.shoppingCart.cartItems[0].item.images.isNotEmpty ? order.shoppingCart.cartItems[0].item.images[0].imageUri.split('/').last : 'placeholder.png'}'
                                    : 'assets/product1.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/product1.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.shoppingCart.cartItems.isNotEmpty
                                        ? order.shoppingCart.cartItems[0].item
                                            .product.productName
                                        : 'Producto',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    order.orderState == 'DELIVERED'
                                        ? 'Entregado el: ${order.estimatedDeliverDate != null ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              order.estimatedDeliverDate!,
                                            ),
                                          ) : 'En espera'}'
                                        : 'Fecha estimada: ${order.estimatedDeliverDate != null ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                order.estimatedDeliverDate!),
                                          ) : 'En espera'}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              translateOrderState(order.orderState),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
