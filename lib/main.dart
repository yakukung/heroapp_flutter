import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/pages/intro.dart';
import 'package:flutter_application_1/pages/user/community.dart';
import 'package:flutter_application_1/pages/user/favorite.dart';
import 'package:flutter_application_1/pages/user/home.dart';
import 'package:flutter_application_1/pages/user/profile.dart';
import 'package:flutter_application_1/pages/user/upload.dart';
import 'package:flutter_application_1/services/navigation_service.dart';
import 'package:flutter_application_1/widgets/layout/main_sidebar.dart';
import 'package:flutter_application_1/widgets/navigation/navbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/app_data.dart';
import 'package:flutter_application_1/widgets/navigation/navbottom.dart';

Future<void> main() async {
  await GetStorage.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(NavigationService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();
    final dynamic uid = storage.read('uid');
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Appdata())],
      child: GetMaterialApp(
        title: 'heroapp Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          fontFamily: 'SukhumvitSet',
        ),
        home: uid == null ? IntroPage() : MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationService navService = Get.find<NavigationService>();
    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      UploadPage(),
      CommunityPage(),
      ProfilePage(),
    ];

    return Obx(
      () => Scaffold(
        appBar: NavbarUser(),
        drawer: SideBar(),
        body: pages[navService.currentIndex.value],
        bottomNavigationBar: NavBottom(),
      ),
    );
  }
}
