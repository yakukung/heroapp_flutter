import 'package:get/get.dart';

class NavigationService extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      print('เปลี่ยนไปหน้า index: $index');
    } else {
      print('กดซ้ำที่หน้าเดิม index: $index');
    }
  }
}
