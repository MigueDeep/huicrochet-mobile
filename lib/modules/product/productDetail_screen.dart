import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' as flutter_ui;
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/modules/product/entities/product.dart';
import 'package:huicrochet_mobile/widgets/product/select_colors.dart';
import 'package:huicrochet_mobile/widgets/product/user_comment.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<Product> product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = _getProductId().then((productId) {
      return _getProductById(productId);
    });
  }

  Future<String> _getProductId() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    return args?['productId'] ?? '';
  }

  Future<Product> _getProductById(String productId) async {
    final dioClient = DioClient(context);

    try {
      final response = await dioClient.dio.get('/product/getById/$productId');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final productData = jsonData['data'];
        return Product.fromJson(productData);
      } else {
        print('Error al obtener producto ${response.statusCode}');
        throw Exception('Error al obtener producto');
      }
    } on DioException catch (e) {
      String errorMessage = 'Error al obtener producto';
      if (e.response != null && e.response?.data != null) {
        try {
          final errorData = jsonDecode(e.response!.data);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = e.message ?? 'Error desconocido';
        }
      }
      print('Error de red $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Error desconocido ${e.toString()}');
      throw Exception('Error desconocido');
    }
  }

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
      // Aquí mandas a llamar al metodo que agrega el producto al carrito
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: product, // Usar el futuro `product` en lugar de 'productId'
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final productData = snapshot.data!;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (productData.items.isNotEmpty &&
                                productData.items[1].images.isNotEmpty)
                              ...productData.items[1].images.map((image) {
                                print(image.imageUri);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: flutter_ui.Image.network(
                                      image.imageUri, // Usar la imagen del item
                                      width: 320,
                                      height: 400,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return flutter_ui.Image.asset(
                                            width: 320,
                                            height: 400,
                                            fit: BoxFit.cover,
                                            'assets/snoopyAzul.jpg');
                                      },
                                    ),
                                  ),
                                );
                              }).toList()
                            else
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Text(
                                  'Imagen no disponible',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        Icons.maximize,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            productData.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Row(children: [
                            Text(
                              '4.5',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Icon(
                              Icons.star_half,
                              color: Colors.yellow,
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${productData.price}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              productData.description,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.black,
                                ),
                                Text(
                                  productData.categories[0].name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Colores',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ColorSelector(
                              colorCodes: productData.items.isNotEmpty
                                  ? productData.items
                                      .map((item) => item.color.colorCod)
                                      .toList()
                                  : [],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GeneralButton(
                        text: 'Agregar al carrito',
                        onPressed: () {
                          checkLoginStatus();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comentarios (3)',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CommentWidget(
                              username: 'Usuario123',
                              date: '20 de octubre, 2024',
                              description:
                                  '¡Me encanta este producto! Es de excelente calidad.',
                              rating: 4.5,
                            ),
                            CommentWidget(
                              username: 'MariaLopez',
                              date: '19 de octubre, 2024',
                              description:
                                  'Muy bueno, pero podría mejorar en algunos aspectos.',
                              rating: 3.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('No product data available'));
        }
      },
    );
  }
}
