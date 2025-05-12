import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/intro.dart';
import 'package:flutter_application_1/services/app_data.dart';
import 'package:flutter_application_1/services/navigation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Get.find<NavigationService>();

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<Appdata>(
            builder: (context, appData, child) {
              return DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF2A5DB9)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child:
                            appData.profileImage.isNotEmpty
                                ? Image.network(
                                  appData.profileImage,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  'assets/images/default/avatar.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      appData.username.isNotEmpty
                          ? appData.username
                          : 'ชื่อผู้ใช้',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      appData.email.isNotEmpty
                          ? appData.email
                          : 'example@email.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color:
                  Get.find<NavigationService>().currentIndex.value == 0
                      ? Color(0xFF2A5DB9)
                      : Color(0xFFBDBDBD),
            ),
            title: Text(
              'หน้าหลัก',
              style: TextStyle(
                color:
                    Get.find<NavigationService>().currentIndex.value == 0
                        ? Color(0xFF2A5DB9)
                        : Colors.black,
              ),
            ),
            onTap: () {
              Get.find<NavigationService>().changeIndex(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star_rounded,
              color:
                  navigationService.currentIndex == 1
                      ? Color(0xFF2A5DB9)
                      : Color(0xFFBDBDBD),
            ),
            title: Text(
              'ชีตโปรด',
              style: TextStyle(
                color:
                    navigationService.currentIndex == 1
                        ? Color(0xFF2A5DB9)
                        : Colors.black,
              ),
            ),
            onTap: () {
              navigationService.changeIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_alt_rounded,
              color:
                  navigationService.currentIndex == 3
                      ? Color(0xFF2A5DB9)
                      : Color(0xFFBDBDBD),
            ),
            title: Text(
              'คอมมูนิตี้',
              style: TextStyle(
                color:
                    navigationService.currentIndex == 3
                        ? Color(0xFF2A5DB9)
                        : Colors.black,
              ),
            ),
            onTap: () {
              navigationService.changeIndex(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color:
                  navigationService.currentIndex == 4
                      ? Color(0xFF2A5DB9)
                      : Color(0xFFBDBDBD),
            ),
            title: Text(
              'โปรไฟล์',
              style: TextStyle(
                color:
                    navigationService.currentIndex == 4
                        ? Color(0xFF2A5DB9)
                        : Colors.black,
              ),
            ),
            onTap: () {
              navigationService.changeIndex(4);
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('ออกจากระบบ'),
            onTap: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const SizedBox(),
                ),
              ),
              Container(
                height: 350,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 60),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const Text(
                      'ยืนยันออกจากระบบ',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'คุณต้องการออกจากระบบใช่ไหม?',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            GetStorage().erase();
                            Get.offAll(() => IntroPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'ออกจากระบบ',
                              style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFF92A47),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
