import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PurchasedetailsScreen extends StatefulWidget {
  const PurchasedetailsScreen({super.key});

  @override
  _PurchasedetailsScreenState createState() => _PurchasedetailsScreenState();
}

class _PurchasedetailsScreenState extends State<PurchasedetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la compra'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/navigation');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  //aqui va el otro widget
                  const SizedBox(height: 32),
                  // Sección de productos
                  const Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/hellokitty.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Peluche Hello Kitty',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rosa x1',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'MXN125.00',
                              style: TextStyle(
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
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/bolsa.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Bolso de hombro con solapa de PU con compartimento',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'MXN125.00',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'MXN577.00',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                      ),
                      onPressed: () => {},
                      child: const Text('Confirmar y pagar',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Poppins')),
                    )),
                const SizedBox(height: 16),
                const Divider(height: 32, thickness: 1),
                const SizedBox(height: 16),
                const Text(
                  'Resúmen de la orden',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Ava Johnson 7772378162',
                      style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Av. Coahuila 475 Col. Pablo T. B. En una reja negra justo en la curva...',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.credit_card, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Método de pago: Mastercard con terminación 578',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
