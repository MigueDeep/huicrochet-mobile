import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/widgets/select_colors.dart';
import 'package:huicrochet_mobile/widgets/user_comment.dart';
import 'package:huicrochet_mobile/widgets/general_button.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/product1.png', // Primera imagen hardcodeada
                            width: 320,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/snoopyAzul.jpg', // Segunda imagen hardcodeada
                            width: 320,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/hellokitty.jpg', // Tercera imagen hardcodeada
                            width: 320,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Puedes seguir añadiendo más imágenes de esta forma
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
                  children: [
                    Text(
                      'Producto 1',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 200),
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
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$99.50',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur adipiscing elit velit, nullam cum litora aptent curabitur ultrices curae sollicitudin imperdiet, faucibus pulvinar potenti purus turpis massa varius. Ligula diam hac nunc sodales conubia hendrerit dictum.',
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
                            Icons.home,
                            color: Colors.black,
                          ),
                          Text(
                            'Hogar',
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
                      ColorSelector(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GeneralButton(
                  text: 'Agregar al carrito',
                  onPressed: () {},
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
  }
}
