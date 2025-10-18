// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:udhar/controllers/auth_controller.dart';
import 'package:udhar/screen/auth/signin_screen.dart';
import 'package:udhar/utils/app_constant.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppConstant.container,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  height: 250.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: AppConstant.secondaty,
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: () async {
                      String email = emailController.text.trim();
                      await _authController.forgotmethod(email);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: double.infinity.w,
                        color: AppConstant.primery,
                        child: Center(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(color: AppConstant.container),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAll(
                      SigninScreen(),
                      transition: Transition.upToDown,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppConstant.secondaty),
                  ),
                ),
                SizedBox(height: 500.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
