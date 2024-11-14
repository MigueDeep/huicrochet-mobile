import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
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

  final orders = [
    {
      'id': 1,
      'product_name': 'Pavoreal de crochet',
      'date': 'Llega el 20 de Octubre ',
      'status': 'Enviado',
      'img': 'assets/product1.png',
      'total': 120.00,
    },
    {
      'id': 2,
      'product_name': 'Hello Kitty de crochet',
      'date': 'Entre el 15 de Octubre del 2024',
      'status': 'Entregado',
      'total': 120.00,
      'img': 'assets/hellokitty.jpg',
    },
    {
      'id': 3,
      'product_name': 'Sueter Azul rayado',
      'date': 'Entregado del 20 de Agosto del 2024',
      'status': 'Entregado',
      'total': 120.00,
      'img': 'assets/sueterazul.jpg',
    },
    {
      'id': 4,
      'product_name': 'Bolso beige grandre',
      'date': 'Entregado el 5 de Agosto del 2024',
      'status': 'Entregado',
      'total': 120.00,
      'img': 'assets/bolsa.jpg',
    },
  ];

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
    _loaderController.hide();
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
                  color: Color.fromRGBO(130, 48, 56, 1),
                ),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var order in orders)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/orderDetails');
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  order['img'] as String,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['product_name'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      order['date'] as String,
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
                                order['status'] as String,
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
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
