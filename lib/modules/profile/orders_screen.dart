import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
        ),
        title: Text('Órdenes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Ava Johnson',
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
                      onTap: () {},
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
