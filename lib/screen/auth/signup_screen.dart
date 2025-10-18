// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udhar/controllers/auth_controller.dart';
import 'package:udhar/screen/auth/signin_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  TextEditingController shopnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                    controller: shopnameController,
                    textInputAction: TextInputAction.next,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Shop Name',
                      prefixIcon: Icon(Icons.shop_2_outlined),
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
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      prefixIcon: Icon(Icons.call_outlined),
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
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
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
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password_outlined),
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
                      String shopsname = shopnameController.text.trim();
                      String phone = phoneController.text.trim();
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      await _authController.sigupmethod(
                        email,
                        password,
                        shopsname,
                        phone,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: double.infinity.w,
                        color: AppConstant.primery,
                        child: Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(color: AppConstant.container),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: AppConstant.secondaty),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(
                            SigninScreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: Text(
                          'signin',
                          style: TextStyle(color: AppConstant.error),
                        ),
                      ),
                    ],
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
