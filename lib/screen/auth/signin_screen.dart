// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udhar/controllers/auth_controller.dart';
import 'package:udhar/screen/auth/forgot_password_screen.dart';
import 'package:udhar/screen/auth/signup_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
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
                    controller: emailController,
                    textInputAction: TextInputAction.next,
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
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    cursorColor: AppConstant.secondaty,
                    style: TextStyle(color: AppConstant.secondaty),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAll(
                            ForgotPasswordScreen(),
                            transition: Transition.downToUp,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppConstant.error),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      await _authController.signinmthod(email, password);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: double.infinity.w,
                        color: AppConstant.primery,
                        child: Center(
                          child: Text(
                            'Signin',
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
                        'Don\'t have an account?',
                        style: TextStyle(color: AppConstant.secondaty),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(
                            SignupScreen(),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: Text(
                          'signup',
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
