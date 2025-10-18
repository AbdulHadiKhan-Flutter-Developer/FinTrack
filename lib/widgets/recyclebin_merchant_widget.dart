// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/screen/recyclebin_merchant_detail_screen.dart';

import 'package:udhar/utils/app_constant.dart';

class RecyclebinMerchantWidget extends StatelessWidget {
  MerchantController merchanController = Get.put(MerchantController());
  final String merchantname;
  final int merchantamount;
  final String merchantphone;
  final String merchantaddress;
  final bool iseven;
  final DateTime dateTime;
  final String merchantemail;

  RecyclebinMerchantWidget({
    super.key,
    required this.merchantname,
    required this.merchantamount,
    required this.merchantphone,
    required this.merchantaddress,
    required this.iseven,
    required this.dateTime,
    required this.merchantemail,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),

      child: GestureDetector(
        onTap: () {
          Get.to(
            RecyclebinMerchantDetailScreen(
              merchantname: merchantname,
              merchantamount: merchantamount,
              merchantaddress: merchantaddress,
              merchantphone: merchantphone,
              dateTime: dateTime,
            ),
            transition: Transition.leftToRight,
            duration: Duration(microseconds: 500),
          );
        },
        child: Container(
          height: 90.h,
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
                GestureDetector(
                  onTap: () async {
                    merchanController.restorerecyclebin(
                      merchantname,
                      merchantaddress,
                      merchantphone,
                      merchantamount,
                      dateTime,
                      merchantemail,
                    );
                    await merchanController.fetchAllMerchants();
                  },
                  child: Icon(Icons.restore, color: Colors.grey, size: 18.sp),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' $merchantname',
                      style: TextStyle(
                        color: AppConstant.secondaty,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        merchanController.deleterecyclebin(merchantname);
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
                      ' ${merchantamount} -/pkr',
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
