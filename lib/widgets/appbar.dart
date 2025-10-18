// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/auth_controller.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/screen/all_customer_screen.dart';
import 'package:udhar/screen/all_merchant_screen.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/utils/app_constant.dart';

class Appbar extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  CustomerController customerController = Get.put(CustomerController());
  MerchantController merchantController = Get.put(MerchantController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstant.container,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          Center(
            child: Text(
              'Welcomeback!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              authController.usershopname,
              style: TextStyle(
                color: AppConstant.primery,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Text(
              'Version: 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 11.sp),
            ),
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Get.offAll(HomeScreen());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 40.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(color: AppConstant.primery),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Icon(Icons.home_outlined, color: AppConstant.container),
                        SizedBox(width: 10.w),

                        Text(
                          'Home',
                          style: TextStyle(color: AppConstant.container),
                        ),
                        SizedBox(width: 180.w),

                        Icon(Icons.arrow_forward, color: AppConstant.container),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Get.offAll(AllMerchantScreen());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 40.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(color: AppConstant.primery),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.store_mall_directory_outlined,
                          color: AppConstant.container,
                        ),
                        SizedBox(width: 10.w),

                        Text(
                          'Merchant (${merchantController.merchants.length})',
                          style: TextStyle(color: AppConstant.container),
                        ),
                        SizedBox(width: 120.w),

                        Icon(Icons.arrow_forward, color: AppConstant.container),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Get.offAll(AllCustomerScreen());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 40.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(color: AppConstant.primery),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.people_alt_outlined,
                          color: AppConstant.container,
                        ),
                        SizedBox(width: 10.w),

                        Text(
                          'Customers (${customerController.customers.length})',
                          style: TextStyle(color: AppConstant.container),
                        ),
                        SizedBox(width: 110.w),

                        Icon(Icons.arrow_forward, color: AppConstant.container),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Spacer(),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Row(
              children: [
                Icon(Icons.logout_outlined, color: AppConstant.error),
                SizedBox(width: 5.w),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: AppConstant.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
