// ignore_for_file: must_be_immutable, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/utils/app_constant.dart';

class CustomerInfoScreen extends StatelessWidget {
  final String customername;
  int customeramount;
  final String customerphone;
  final String customeraddress;
  final DateTime dateTime;

  CustomerController customerController = Get.put(CustomerController());

  CustomerInfoScreen({
    super.key,
    required this.customername,
    required this.customerphone,
    required this.customeraddress,
    required this.dateTime,
    required this.customeramount,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        title: Text('${customername} Info'),
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
                    'Customer Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${customername}',
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
                      ' ${customerController.totalamount} -/Pkr',
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
                    'Customer Phone:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${customerphone}',
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
                    'Customer Address:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    ' ${customeraddress}',
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
