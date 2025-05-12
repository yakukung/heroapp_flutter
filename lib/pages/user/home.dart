import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/widgets/product/product_card.dart';
import 'package:flutter_application_1/widgets/search/search_sheet_box.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/app_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, dynamic>> products = [];
  List<bool> isFavoriteList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Appdata>(context, listen: false).fetchUserData();
    });

    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    const int maxRetries = 3;
    const Duration timeoutDuration = Duration(seconds: 10);
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        setState(() {
          isLoading = true;
          errorMessage = '';
        });

        final response = await http
            .get(Uri.parse('$API_ENDPOINT/product'))
            .timeout(timeoutDuration);

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            products = List<Map<String, dynamic>>.from(data);
            isFavoriteList = List<bool>.generate(
              products.length,
              (i) => products[i]['is_favorite'] == 1,
            );
            isLoading = false;
          });
          return;
        } else {
          setState(() {
            errorMessage = 'ไม่สามารถดึงข้อมูลได้ (${response.statusCode})';
            isLoading = false;
          });
          retryCount++;
        }
      } catch (e) {
        log('Product API error: $e (Attempt ${retryCount + 1}/$maxRetries)');
        setState(() {
          errorMessage = 'เกิดข้อผิดพลาด: ${e.toString()}';
          isLoading = false;
        });
        retryCount++;
      }

      if (retryCount < maxRetries) {
        log('Retrying in 2 seconds...');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (retryCount == maxRetries) {
      log('Failed to fetch products after $maxRetries attempts');
      setState(() {
        errorMessage = 'ไม่สามารถดึงข้อมูลได้หลังจากลอง $maxRetries ครั้ง';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A5DB9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'ลองใหม่',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : products.isEmpty
                ? const Center(
                  child: Text(
                    'ไม่มีข้อมูลผลิตภัณฑ์',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      const SearchSheetBox(),
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          const SizedBox(width: 35),
                          Text(
                            'ชีตใหม่ล่าสุด',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 25),
                            for (int i = 0; i < products.length; i++)
                              ProductCard(
                                product: Product(
                                  imageUrl:
                                      (products[i]['imageUrl'] != null)
                                          ? products[i]['imageUrl']
                                              .toString()
                                              .replaceAll('`', '')
                                              .trim()
                                          : null,
                                  title: products[i]['title'] ?? '',
                                  author: products[i]['author'] ?? '',
                                  rating:
                                      (products[i]['rating'] ?? 0).toDouble(),
                                  price: products[i]['price']?.toString() ?? '',
                                  isFavorite:
                                      isFavoriteList.length > i
                                          ? isFavoriteList[i]
                                          : false,
                                ),
                                onFavoriteTap: () {
                                  setState(() {
                                    if (isFavoriteList.length > i) {
                                      isFavoriteList[i] = !isFavoriteList[i];
                                    }
                                  });
                                },
                              ),
                            const SizedBox(width: 25),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
