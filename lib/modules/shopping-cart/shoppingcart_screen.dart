import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/entities/cart.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/shopping-cart/mailing_address_cart.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/product/product_added_to_cart.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingcartScreen extends StatefulWidget {
  const ShoppingcartScreen({super.key, required this.getPaymentMethod});
  final GetPayment getPaymentMethod;

  @override
  State<ShoppingcartScreen> createState() => _ShoppingcartScreenState();
}

class _ShoppingcartScreenState extends State<ShoppingcartScreen> {
  final LoaderController _loaderController = LoaderController();
  late Cart shoppingCart = Cart('', false, 0, []);
  bool emptyCart = false;
  int quantityUpdate = 0;
  double total = 0;
  bool _isUpdating = false;

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No tienes sesión iniciada'),
            content: const Text('¿Quieres iniciar sesión?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/navigation');
                },
              ),
              TextButton(
                child: const Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      );
    } else {
      _loaderController.show(context);
      getShoppingCart();
    }
  }

  Future<void> getShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      final response =
          await dio.get('/shopping-cart/user/${prefs.getString('userId')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);

        setState(() {
          try {
            if (jsonData['error'] != null && jsonData['error']) {
              throw Exception(
                  'Error en la respuesta del backend: ${jsonData['message']}');
            }

            final data = jsonData['data'];
            if (data == null || data['cartItems'] == null) {
              emptyCart = true;
              shoppingCart = Cart('', false, 0, []);
            } else {
              final cart = Cart.fromJson(data);
              shoppingCart = cart;
              emptyCart = false;
            }

            _loaderController.hide();
          } catch (e) {
            setState(() {
              _loaderController.hide();
            });
          }
        });
      } else if (response.statusCode == 204) {
        setState(() {
          emptyCart = true;
          shoppingCart = Cart('', false, 0, []);
          _loaderController.hide();
        });
      } else {
        setState(() {
          _loaderController.hide();
        });
        final errorState = Provider.of<ErrorState>(context, listen: false);
        errorState
            .setError('Error al obtener el carrito: ${response.statusCode}');
        errorState.showErrorDialog(context);
      }
    } catch (e) {
      print('Error al obtener el carrito: $e');
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
      setState(() {
        _loaderController.hide();
      });
    }
  }

  Future<void> alertConfirm(String item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text(
              '¿Está seguro de que desea eliminar esta artículo de tu carrito de compras?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                updateCar(item, 0);
                _loaderController.show(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateCar(String id, int quantity) async {
    if (_isUpdating) return;
    _isUpdating = true;

    final dio = DioClient(context).dio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> data = shoppingCart.cartItems.map((item) {
      return {
        'itemId': item.item.id,
        'quantity': item.item.id == id ? quantity : item.quantity,
      };
    }).toList();
    try {
      final response = await dio.put(
        '/shopping-cart/update/shopping-cart/${prefs.getString('shoppingCartId')}',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        _loaderController.show(context);
        getShoppingCart();
      }
    } catch (e) {
      final errorState = Provider.of<ErrorState>(context, listen: false);

      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          String errorMessage =
              e.response?.data['message'] ?? 'Error desconocido';
          errorState.setError(errorMessage);
        } else {
          errorState.setError('Error de conexión');
        }
      } else {
        errorState.setError('Error inesperado: $e');
      }

      errorState.showErrorDialog(context);
    } finally {
      _isUpdating = false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mi carrito',
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (shoppingCart.cartItems.isEmpty || emptyCart)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'El carrito de compras está vacío, ¡ve a comprar!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          GeneralButton(
                            text: 'Ir al inicio',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/navigation');
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: shoppingCart.cartItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final cartItem = shoppingCart.cartItems[index];
                        final product = cartItem.item.product;
                        final color = cartItem.item.color.colorName;

                        return ProductAddedToCart(
                          image: cartItem.item.images.isNotEmpty
                              ? cartItem.item.images[0].imageUri
                              : 'assets/hellokitty.jpg',
                          productName: product.productName,
                          color: color,
                          quantity: cartItem.quantity,
                          price: product.price.toDouble(),
                          subColor: Color(int.parse(
                              "0xff${cartItem.item.color.colorCod.substring(1)}")),
                          onIncrement: () {
                            setState(() {
                              cartItem.quantity++;
                              Future.delayed(const Duration(milliseconds: 3000),
                                  () {
                                updateCar(cartItem.item.id, cartItem.quantity);
                              });
                            });
                          },
                          onDecrement: () {
                            setState(() {
                              if (cartItem.quantity > 1) {
                                cartItem.quantity--;
                                Future.delayed(
                                    const Duration(milliseconds: 3000), () {
                                  updateCar(
                                      cartItem.item.id, cartItem.quantity);
                                });
                              } else {
                                alertConfirm(cartItem.item.id);
                              }
                            });
                          },
                          onDelete: () {
                            setState(() {
                              alertConfirm(cartItem.item.id);
                            });
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          if (shoppingCart.total > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal (IVA incluido)',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                  Text(
                    '\$${shoppingCart.total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          if (shoppingCart.total > 0)
            Padding(
              padding: const EdgeInsets.all(20),
              child: GeneralButton(
                text: 'Continuar al pago',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MailingAddressCart(
                        shoppingCart: shoppingCart,
                        getPaymentMethod: widget.getPaymentMethod,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
