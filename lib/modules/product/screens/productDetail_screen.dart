import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/product/providers/product_details_provider.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:huicrochet_mobile/widgets/product/product_detail_loading.dart';
import 'package:huicrochet_mobile/widgets/product/product_reviews.dart';
import 'package:huicrochet_mobile/widgets/product/product_stars_average.dart';
import 'package:huicrochet_mobile/widgets/product/select_colors.dart';
import 'package:huicrochet_mobile/widgets/product/user_comment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final LoaderController _loaderController = LoaderController();
  int _selectedIndex = 0;
  String _selectedItem = '';
  int _quantity = 0;
  bool _isAdded = false;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null) {
      final productId = args['productId'] ?? '';
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .fetchProductDetails(context, id: productId);
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
      addToShoppingCart();
    }
  }

  Future<void> addToShoppingCart() async {
    _loaderController.show(context);
    final dio = DioClient(context).dio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await dio.post(
        '/shopping-cart/${prefs.getString('shoppingCartId')}',
        data: {
          'itemId': _selectedItem,
          'quantity': _quantity,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isAdded = true;
        });
        _loaderController.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto agregado al carrito'),
            backgroundColor: Colors.blue,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _isAdded = false;
        });
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
      _loaderController.hide();

      errorState.showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final productId = args?['productId'] ?? '';
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .fetchProductDetails(context, id: productId);

    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const ProductDetailLoading();
        }

        if (provider.products.isEmpty) {
          return ProductDetailLoading();
        }

        var productData = provider.products[0];
        var itemData = provider.products;
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
                            if (itemData.isNotEmpty &&
                                itemData[_selectedIndex] != null)
                              ...itemData[_selectedIndex]['imageUris']
                                  .map<Widget>((imageUri) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imageUri ??
                                          '', // Aquí usamos el valor mapeado de imageUris
                                      width: 320,
                                      height: 400,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/snoopyAzul.jpg',
                                          width: 320,
                                          height: 400,
                                          fit: BoxFit.cover,
                                        );
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
                            productData['name'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          StarAverage(productId: productId),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${productData['price']}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              productData['description'],
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    productData['categoryNames']
                                        .toSet()
                                        .join(', '),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Colores',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            ColorSelector(
                              colorCodes: itemData[_selectedIndex]['colors'],
                              onColorSelected: (index) {
                                setState(() {
                                  _selectedIndex = index;
                                  _selectedItem =
                                      itemData[_selectedIndex]['itemId'];
                                  _quantity = 0;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Stock: ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              itemData[_selectedIndex]['stock'] >= 10
                                  ? 'Más de 10 piezas disponibles'
                                  : 'Compra ahora, solo ${itemData[_selectedIndex]['stock']} disponibles!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]!)),
                            child: IconButton(
                              onPressed: _decrementQuantity,
                              icon: Icon(Icons.remove),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '$_quantity',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]!)),
                            child: IconButton(
                              onPressed:
                                  _quantity < itemData[_selectedIndex]['stock']
                                      ? _incrementQuantity
                                      : null,
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor:
                                _isAdded ? Colors.green : colors['violet'],
                          ),
                          onPressed: _quantity > 0 && !_isAdded
                              ? () {
                                  if (_selectedItem == '') {
                                    setState(() {
                                      _selectedItem =
                                          _selectedItem = itemData[0]['itemId'];
                                    });
                                  }
                                  checkLoginStatus();
                                }
                              : null,
                          child: Row(
                            key: const ValueKey('animated_icon'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _isAdded
                                    ? Icon(Icons.check,
                                        key: const ValueKey('check_icon'),
                                        color: Colors.white)
                                    : Icon(Icons.shopping_cart,
                                        key: const ValueKey('cart_icon'),
                                        color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isAdded
                                    ? 'Agregado al carrito'
                                    : 'Agregar al carrito',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProductReviews(productId: productId)
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
