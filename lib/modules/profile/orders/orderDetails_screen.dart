import 'dart:convert';
import 'package:flutter/material.dart' as flutter_ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/custom_progress_line.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String id;
  const OrderDetailsScreen({super.key, required this.id});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _loaderController = LoaderController();
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      getOrder();
    });
  }

  Future<void> getOrder() async {
    final dio = DioClient(context).dio;

    try {
      final response = await dio.get('/order/${widget.id}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);

        if (jsonData['error'] != null && jsonData['error']) {
          throw Exception(
              'Error en la respuesta del backend: ${jsonData['message']}');
        }

        setState(() {
          data = jsonData['data'] ?? {};
          _loaderController.hide();
        });
      } else if (response.statusCode == 204) {
        print('No se encontraron órdenes');
        setState(() {
          _loaderController.hide();
        });
      } else {
        throw Exception('Error al obtener la órden: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las órdenes: $e');
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(
        e is DioException && e.response?.statusCode == 400
            ? e.response?.data['message'] ?? 'Error desconocido'
            : 'Error de conexión',
      );
      errorState.showErrorDialog(context);
      setState(() {
        _loaderController.hide();
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Detalles de la Orden'),
        automaticallyImplyLeading: true,
      ),
      body: data == null || data.isEmpty
          ? const Center(child: Text('No se encontraron datos'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estado del Pedido',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        translateOrderState(data['orderState']),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 80,
                  ),
                  child: CustomProgressLine(orderState: data['orderState']),
                ),
                const Divider(height: 32, thickness: 1),
                // Sección de productos
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data['orderDetails']['products'].length,
                          itemBuilder: (context, index) {
                            final product =
                                data['orderDetails']['products'][index];
                            var productName =
                                product['item']['product']['productName'];
                            final color = product['item']['color']['colorName'];
                            final price = product['item']['product']['price'];
                            final quantity = product['quantity'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: flutter_ui.Image.network(
                                      product['item']['images'] != null &&
                                              product['item']['images']
                                                  .isNotEmpty
                                          ? 'http://${ip}:8080/${product['item']['images'][0]['imageUri'].split('/').last}'
                                          : 'not found',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return flutter_ui.Image.asset(
                                          'assets/product1.png',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '$color x$quantity',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 32, thickness: 1),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '${data['orderDetails']['user']['fullName']} '
                            '${data['orderDetails']['shippingAddress']['phoneNumber']}',
                            style:
                                TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${data['orderDetails']['shippingAddress']['street']} '
                              '${data['orderDetails']['shippingAddress']['number']} '
                              '${data['orderDetails']['shippingAddress']['city']}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                          ),
                          Text(
                            '\$${data['totalPrice']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32, thickness: 1),
                      const Text(
                        'Otra Información',
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Número de Pedido',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Row(
                            children: [
                              Text(
                                data['id'].substring(0, 8),
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: data['id'].substring(0, 8)));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Copiado al portapapeles')),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha del Pedido: ${data['orderDate']}',
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
