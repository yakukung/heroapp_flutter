import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/app_data.dart';
import 'package:provider/provider.dart';

class NavbarUser extends StatelessWidget implements PreferredSizeWidget {
  const NavbarUser({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<Appdata>(context);

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,

      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 32),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ยินดีต้อนรับ',
                style: TextStyle(
                  color: Color(0xFFB2B2B2),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                appData.username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child:
                  appData.profileImage.isNotEmpty
                      ? Image.network(
                        appData.profileImage,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/images/default/avatar.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
