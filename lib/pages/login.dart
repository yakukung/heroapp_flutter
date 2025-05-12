import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/services/app_data.dart';
import 'package:flutter_application_1/services/navigation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  String errorText = '';
  bool isLoading = false;
  TextEditingController usernameOrEmailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  void dispose() {
    usernameOrEmailCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 80,
          left: 40,
          right: 40,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ยินดีต้อนรับ',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
            ),
            Text(
              'เข้าสู่ระบบของคุณ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6E6E6E),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: usernameOrEmailCtl,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEBEBED),
                hintText: 'ชื่อผู้ใช้ หรือ อีเมล',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                errorText: errorText.isNotEmpty ? errorText : null,
              ),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordCtl,
              obscureText: _obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEBEBED),
                hintText: 'รหัสผ่าน',
                hintStyle: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                errorText: errorText.isNotEmpty ? errorText : null,
              ),
              style: const TextStyle(
                fontFamily: 'SukhumvitSet',
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    log('Forgot password tapped');
                  },
                  child: Text(
                    'ลืมรหัสผ่าน?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: isLoading ? null : login,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2A5DB9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Color(0xFFEBEBED),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                  ),
                ),
                const Text(
                  'หรือ ดำเนินต่อด้วยวิธีอื่น',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Color(0xFFEBEBED),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: const EdgeInsets.only(left: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Google Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 24,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo/google-icon-logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120),
            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'หากคุณยังไม่มีบัญชี?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterPage());
                  },
                  child: Text(
                    'สมัครสมาชิกใหม่',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1F8CE2),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF1F8CE2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    if (usernameOrEmailCtl.text.isEmpty || passwordCtl.text.isEmpty) {
      setState(() {
        errorText = 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน';
      });
      showErrorDialog('ข้อมูลไม่ครบถ้วน', 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน');
      return;
    }

    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      log('Login API at $API_ENDPOINT/auth/login');
      final response = await http.post(
        Uri.parse('$API_ENDPOINT/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usernameOrEmail': usernameOrEmailCtl.text.trim(),
          'password': passwordCtl.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['uid'] == null) {
          log('Error: uid is null in response');
          return;
        }
        final int uid = int.tryParse(jsonResponse['uid'].toString()) ?? 0;
        final GetStorage gs = GetStorage();
        gs.write('uid', uid);
        log('GetStorage: uid=$uid saved');

        if (!mounted) return;
        final appData = Provider.of<Appdata>(context, listen: false);
        await appData.fetchUserData();

        // Reset navigation index to 0 (HomePage)
        final NavigationService navService = Get.find<NavigationService>();
        navService.currentIndex.value = 0;

        // Navigate to MainPage instead of HomePage
        Get.offAll(() => const MainPage());
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorText = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
        });
        showErrorDialog(
          'เข้าสู่ระบบไม่สำเร็จ',
          'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
        );
      }
    } catch (e) {
      log('Login error: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้';
      });
      showErrorDialog(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ กรุณาลองใหม่ในภายหลัง',
      );
    }
  }

  void showErrorDialog(String title, String message) {
    Get.defaultDialog(
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDEEEF),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(18),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFF92A47),
              size: 48,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SukhumvitSet',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'SukhumvitSet',
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF92A47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text('ตกลง'),
            ),
          ),
        ],
      ),
      radius: 45,
      backgroundColor: Colors.white,
      barrierDismissible: false,
    );
  }
}
