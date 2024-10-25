import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Perfil'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
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
          Divider(),
          ListTile(
            leading: Text('Mis ordenes',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            trailing: Icon(Icons.local_shipping,
                color: Color.fromRGBO(130, 48, 56, 1)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/orders');
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.person_outline,
                color: Color.fromRGBO(130, 48, 56, 1)),
            leading: Text('Información personal',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/info');
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.location_on_outlined,
                color: Color.fromRGBO(130, 48, 56, 1)),
            leading: Text('Direcciones',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/addresses');
            },
          ),
          Divider(),
          ListTile(
            trailing:
                Icon(Icons.credit_card, color: Color.fromRGBO(130, 48, 56, 1)),
            leading: Text('Métodos de pago',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromRGBO(130, 48, 56, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/addresses');
            },
          ),
          Divider(),
          Spacer(),
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
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Cerrar sesión',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poppins')),
                )),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
