import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String? imageUrl;
  final String? fullName;

  UserProfile({this.imageUrl, this.fullName});
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Future<UserProfile?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('userImg');
    String? fullName = prefs.getString('fullName');

    if (imagePath != null) {
      final imageName = imagePath.split('/').last;
      final profileImage = 'http://${ip}:8080/$imageName';

      return UserProfile(imageUrl: profileImage, fullName: fullName);
    } else {
      return UserProfile(imageUrl: null, fullName: fullName);
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
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
            child: Icon(
              Icons.local_shipping,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          const SizedBox(width: 5),
          FutureBuilder<UserProfile?>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data != null) {
                UserProfile userProfile = snapshot.data!;

                if (userProfile.imageUrl != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      userProfile.imageUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        String initials = userProfile.fullName != null
                            ? getInitials(userProfile.fullName!)
                            : '??';
                        return CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(242, 148, 165, 1),
                          child: Text(initials,
                              style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  );
                } else {
                  String initials = userProfile.fullName != null
                      ? getInitials(userProfile.fullName!)
                      : 'H';
                  return CircleAvatar(
                    backgroundColor: const Color.fromRGBO(242, 148, 165, 1),
                    child:
                        Text(initials, style: TextStyle(color: Colors.white)),
                  );
                }
              } else {
                return const Icon(Icons.error, color: Colors.red);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

