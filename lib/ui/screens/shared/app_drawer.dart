import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/session_manager.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
                builder: (context) {
                  AppUser u = SessionManager.user!;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          foregroundImage: AssetImage(u.userData.imageResourcePath),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${u.userData.nickname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("${u.userData.email}"),
                          ],
                        )
                      ],
                    ),
                  );
                }
            ),
            Divider(height: 0),
            ListTile(
              title: Text("Edit Profile", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, size: 20),
              leading: Icon(Icons.person_outline),
              onTap: () async {
                await Navigator.pushNamed(context, RouteNames.profileScreen);
                setState(() {});
              },
            ),
            Divider(height: 10),
            ListTile(
              title: Text("Change Password", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, size: 20),
              leading: Icon(Icons.lock_outline),
            ),
            Divider(height: 10),
            ListTile(
              title: Text("Update Vehicle", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_outlined, size: 20),
              leading: Icon(Icons.directions_bus_outlined),
            ),
            Divider(height: 10),
            Spacer(),
            ListTile(
              title: Text("Logout", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.logout, color: Colors.red, size: 20),
              onTap: ()=> SessionManager.logout(),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
