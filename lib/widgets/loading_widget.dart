import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:udhar/controllers/loading_controller.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  final loadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!loadingController.isloading.value) return const SizedBox.shrink();

      return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/animations/liquid loader 01.json',
          width: 120.w,
          height: 120.h,
        ),
      );
    });
  }
}
