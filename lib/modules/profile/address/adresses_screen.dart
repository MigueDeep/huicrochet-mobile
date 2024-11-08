import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/user.dart';
import 'package:huicrochet_mobile/modules/profile/address/editAddress_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> addresses = [];
  String name = 'Cargando...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfile();
    getShippingAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    getProfile();
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;
    try {
      final response =
          await dio.get('/auth/findById/${prefs.getString('userId')}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.data);
        setState(() {
          name = jsonData['data']['fullName'];
        });
      }
    } catch (e) {
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
    }
  }

  Future<void> getShippingAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      final response =
          await dio.get('/shipping-address/user/${prefs.getString('userId')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);

        print("Respuesta recibida:");
        print(jsonData);

        setState(() {
          try {
            final dataList = jsonData['data'] as List;
            print("Lista de direcciones:");
            print(dataList);

            addresses = dataList.map((address) {
              print("Procesando dirección con datos:");
              print(address);

              final userMap = address['user'] ?? {};

              return Address(
                address['id']?.toString() ?? '',
                address['state']?.toString() ?? 'Desconocido',
                address['city']?.toString() ?? 'Desconocida',
                address['zipCode']?.toString() ?? '',
                address['district']?.toString() ?? '',
                address['street']?.toString() ?? '',
                address['number']?.toString() ?? '',
                address['phoneNumber']?.toString() ?? '',
                address['defaultAddress'] == true,
                address['status'] == true,
                User(
                  userMap['id']?.toString() ?? '',
                  userMap['fullName']?.toString() ?? 'Sin nombre',
                  userMap['email']?.toString() ?? 'Sin email',
                  DateTime.tryParse(userMap['birthday']?.toString() ?? '') ??
                      DateTime.now(),
                  userMap['status'] == true,
                  userMap['blocked'] == true,
                  userMap['image']?.toString(),
                ),
              );
            }).toList();

            print('Direcciones cargadas:');
            print(addresses);
            isLoading = false;
          } catch (e) {
            print('Error específico al mapear los datos: $e');
            final errorState = Provider.of<ErrorState>(context, listen: false);
            errorState.setError('Error al procesar las direcciones.');
            errorState.showErrorDialog(context);
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    } catch (e) {
      print('Error al obtener las direcciones: $e');
      final errorState = Provider.of<ErrorState>(context, listen: false);
      errorState.setError(e is DioException && e.response?.statusCode == 400
          ? e.response?.data['message'] ?? 'Error desconocido'
          : 'Error de conexión');
      errorState.showErrorDialog(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> alertConfirm(String address) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar esta dirección?'),
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
                deleteAddress(address);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAddress(String address) async {
    final dio = DioClient(context).dio;
    try {
      final response = await dio.put('/shipping-address/disable/$address');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dirección de envío eliminada'),
            backgroundColor: Colors.blue,
          ),
        );
        getShippingAddresses();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/navigation');
          },
        ),
        title: Text('Direcciones'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 32),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
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
                      'Direcciones',
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
                        for (var address in addresses)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${address.number} ${address.street}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${address.zipCode} ${address.city} ${address.state}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditadressScreen(
                                              address: address.id ?? '',
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        setState(() {
                                          alertConfirm(address.id ?? '');
                                        });
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Editar'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Eliminar'),
                                        ),
                                      ];
                                    },
                                    icon: Icon(Icons.more_horiz,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addAddress');
                            },
                            child: const Text(
                              'Agregar dirección',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(130, 48, 56, 1),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
