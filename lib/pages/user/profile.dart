import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/app_data.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Consumer<Appdata>(
        builder: (context, appData, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 32),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child:
                        appData.profileImage.isNotEmpty
                            ? Image.network(
                              appData.profileImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              'assets/images/default/avatar.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  appData.username.isNotEmpty ? appData.username : 'ชื่อผู้ใช้',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  appData.email.isNotEmpty
                      ? appData.email
                      : 'example@email.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text(
                      'แก้ไขโปรไฟล์',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A5DB9),
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('ออกจากระบบ'),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
