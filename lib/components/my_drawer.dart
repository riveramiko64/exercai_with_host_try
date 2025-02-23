import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exercai_with_host_try/login_register_pages/login.dart';
import 'package:exercai_with_host_try/main.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onTap: () => login(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //drawer header
              DrawerHeader(
                child: Icon(
                  Icons.favorite, // Change this icon if you want
                  color: Colors.white, // Change the color of the icon
                  size: 64, // Adjust the size if needed
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              //home tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white, // Change the color of the icon
                  ),
                  title: Text(
                    "H O M E",
                    style: TextStyle(color: Colors.white), // Change text color if needed
                  ),
                  onTap: () {
                    //this is already home screen so just pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              //profile tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white, // Change the color of the icon
                  ),
                  title: Text(
                    "P R O F I L E",
                    style: TextStyle(color: Colors.white), // Change text color if needed
                  ),
                  onTap: () {
                    //this is already home screen so just pop the drawer
                    Navigator.pop(context);

                    //navigate to profile page
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              //user tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Colors.white, // Change the color of the icon
                  ),
                  title: Text(
                    "U S E R S",
                    style: TextStyle(color: Colors.white), // Change text color if needed
                  ),
                  onTap: () {
                    //this is already home screen so just pop the drawer
                    Navigator.pop(context);

                    //navigate to users page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.insert_chart,
                    color: Colors.white, // Change the color of the icon
                  ),
                  title: Text(
                    "P R O G R E S S   T R A C K I N G",
                    style: TextStyle(color: Colors.white), // Change text color if needed
                  ),
                  onTap: () {
                    //this is already home screen so just pop the drawer
                    Navigator.pop(context);

                    //navigate to users page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),
            ],
          ),

          //logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white, // Change the color of the icon
              ),
              title: Text(
                "L O G O U T",
                style: TextStyle(color: Colors.white), // Change text color if needed
              ),
              onTap: () {
                //this is already home screen so just pop the drawer
                Navigator.pop(context);

                //logout
                logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}