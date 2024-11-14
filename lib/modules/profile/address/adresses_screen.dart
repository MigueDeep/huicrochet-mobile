import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/user.dart';
import 'package:huicrochet_mobile/modules/profile/address/editAddress_screen.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> addresses = [];
  String? name;
  String? userImg;
  final LoaderController _loaderController = LoaderController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loaderController.show(context);
      getProfile();
      getShippingAddresses();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildProfileImage() {
    if (userImg != null && userImg!.startsWith('data:image')) {
      String base64Image = userImg!.split(',').last;
      Uint8List imageBytes = base64Decode(base64Image);
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(imageBytes),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/logo.png'),
      );
    }
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('fullName')!;
      userImg = prefs.getString('userImg');
    });
  }

  Future<void> getShippingAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient(context).dio;

    try {
      final response =
          await dio.get('/shipping-address/user/${prefs.getString('userId')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data);
        setState(() {
          try {
            final dataList = jsonData['data'] as List;
            addresses = dataList.map((address) {
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
            _loaderController.hide();
          } catch (e) {
            print('Error específico al mapear los datos: $e');
            final errorState = Provider.of<ErrorState>(context, listen: false);
            errorState.setError('Error al procesar las direcciones.');
            errorState.showErrorDialog(context);
            setState(() {
              _loaderController.hide();
            });
          }
        });
      } else if (response.statusCode == 204) {
        setState(() {
          _loaderController.hide();
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
        _loaderController.hide();
      });
    }
  }

  Future<void> alertConfirm(String address) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text(
              '¿Está seguro de que desea eliminar esta dirección de envío?'),
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

  Future<void> alertConfirmDefault(String address) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text(
              '¿Está seguro de que desea hacer esta dirección predeterminada?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                defaultAddress(address);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> defaultAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dio = DioClient(context).dio;
    try {
      final response = await dio.put(
          '/shipping-address/default/${prefs.getString('userId')}/$address');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dirección de envío predeterminada'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),
            _buildProfileImage(),
            SizedBox(height: 10),
            Text(
              name!,
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
                        Container(
                          decoration: BoxDecoration(
                            border: address.defaultAddress
                                ? Border.all(
                                    color:
                                        const Color.fromRGBO(242, 148, 165, 1),
                                    width: 2.0)
                                : null,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (address.defaultAddress)
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                242, 148, 165, 1),
                                            borderRadius:
                                                BorderRadius.circular(4.0)),
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 2),
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
                                        builder: (context) => EditadressScreen(
                                          address: address.id ?? '',
                                        ),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    setState(() {
                                      alertConfirm(address.id ?? '');
                                    });
                                  } else if (value == 'default') {
                                    setState(() {
                                      alertConfirmDefault(address.id ?? '');
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
                                    if (!address.defaultAddress)
                                      PopupMenuItem(
                                        value: 'default',
                                        child: Text('Hacer predeterminada'),
                                      ),
                                  ];
                                },
                                icon:
                                    Icon(Icons.more_horiz, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  const SizedBox(height: 30),
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
