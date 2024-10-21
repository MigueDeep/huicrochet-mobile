import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
}
