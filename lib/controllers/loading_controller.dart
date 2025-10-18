import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isloading = false.obs;

  void showloading() => isloading.value = true;
  void dismissloading() => isloading.value = false;
}
