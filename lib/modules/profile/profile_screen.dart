import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName;
  String? userImg;

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImg');
    final imageName = imagePath?.split('/').last;
    final profileImage = 'http://${ip}:8080/$imageName';
    setState(() {
      fullName = prefs.getString('fullName');
      userImg = profileImage;
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No tienes sesión iniciada'),
            content: const Text('¿Quieres iniciar sesión'),
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
      getProfile();
    }
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
        automaticallyImplyLeading: false,
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              userImg ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                String initials =
                    fullName != null ? getInitials(fullName!) : '??';
                return CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                  child: Text(initials, style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            fullName ?? 'Cargando...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading: const Text('Mis ordenes',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            trailing: const Icon(Icons.local_shipping,
                color: Color.fromRGBO(130, 48, 56, 1)),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          const Divider(),
          ListTile(
            trailing: const Icon(Icons.person_outline,
                color: Color.fromRGBO(130, 48, 56, 1)),
            leading: const Text('Información personal',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushNamed(context, '/info');
            },
          ),
          const Divider(),
          ListTile(
            trailing: const Icon(Icons.location_on_outlined,
                color: Color.fromRGBO(130, 48, 56, 1)),
            leading: const Text('Direcciones',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushNamed(context, '/addresses');
            },
          ),
          const Divider(),
          ListTile(
            trailing: const Icon(Icons.credit_card,
                color: Color.fromRGBO(130, 48, 56, 1)),
            leading: const Text('Métodos de pago',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushNamed(context, '/my-payment-methods');
            },
          ),
          const Divider(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
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
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('token');
                  prefs.remove('fullName');
                  prefs.remove('userId');
                  prefs.remove('userImg');
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

