// ignore_for_file: must_be_immutable, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/utils/app_constant.dart';

class MerchantInfoScreen extends StatelessWidget {
  final String merchantname;
  int merchantamount;
  final String merchantphone;
  final String merchantaddress;
  final DateTime dateTime;

  MerchantController merchantController = Get.put(MerchantController());
  MerchantInfoScreen({
    super.key,
    required this.merchantname,
    required this.merchantphone,
    required this.merchantaddress,
    required this.dateTime,
    required this.merchantamount,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        title: Text('${merchantname} Info'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey, // underline color
            height: 1.0, // underline thickness
          ),
        ),
      ),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Merchant Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${merchantname}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppConstant.primery,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Row(
                  children: [
                    Text(
                      'Total Debt:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      ' ${merchantController.totalamount} -/Pkr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppConstant.error,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              Row(
                children: [
                  Text(
                    'Merchant Phone:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${merchantphone}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppConstant.primery,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              Row(
                children: [
                  Text(
                    'Merchant Address:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${merchantaddress}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              Row(
                children: [
                  Text(
                    'CreatedAt:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppConstant.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
