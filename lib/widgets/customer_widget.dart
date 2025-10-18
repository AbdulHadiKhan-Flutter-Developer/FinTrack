// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/screen/customer_detail_screen.dart';

import 'package:udhar/utils/app_constant.dart';

class CustomerWidget extends StatelessWidget {
  CustomerController customerController = Get.put(CustomerController());
  final String customername;
  final int customeramount;
  final String customerphone;
  final String customeraddress;
  final bool iseven;
  final DateTime dateTime;
  final String email;

  CustomerWidget({
    super.key,
    required this.customername,
    required this.customeramount,
    required this.customerphone,
    required this.customeraddress,
    required this.iseven,
    required this.dateTime,
    required this.email,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),

      child: GestureDetector(
        onTap: () {
          Get.to(
            CustomerDetailScreen(
              customername: customername,
              customeramount: customeramount,
              customeraddress: customeraddress,
              customerphone: customerphone,
              dateTime: dateTime,
            ),
            transition: Transition.leftToRight,
            duration: Duration(microseconds: 500),
          );
        },
        child: Container(
          height: 70.h,
          width: double.infinity.w,
          decoration: BoxDecoration(
            color: iseven
                ? Colors.grey[200]
                : const Color.fromARGB(255, 207, 216, 221),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' $customername',
                      style: TextStyle(
                        color: AppConstant.secondaty,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await customerController.deletecustomermethod(
                          customername,
                          customeraddress,
                          customerphone,
                          customeramount,
                          dateTime,
                          email,
                        );
                        await customerController.fetchallcunstomersmethod();
                      },
                      child: Icon(
                        Icons.delete,
                        color: AppConstant.error,
                        size: 15.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ${customeramount} -/pkr',
                      style: TextStyle(
                        color: AppConstant.primery,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),

                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(dateTime),
                      style: TextStyle(
                        color: const Color.fromARGB(101, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
