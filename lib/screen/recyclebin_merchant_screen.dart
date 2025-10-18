// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/recyclebin_merchant_widget.dart';

class RecyclebinMerchantScreen extends StatefulWidget {
  @override
  State<RecyclebinMerchantScreen> createState() =>
      _RecyclebinMerchantScreenState();
}

class _RecyclebinMerchantScreenState extends State<RecyclebinMerchantScreen> {
  MerchantController merchantController = Get.put(MerchantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        centerTitle: true,
        title: Obx(
          () =>
              Text('Recyclebin (${merchantController.recyclemerchant.length})'),
        ),
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
        color: AppConstant.container,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (merchantController.recyclemerchant.isEmpty) {
                  return Center(
                    child: Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/isempty.png'),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: merchantController.recyclemerchant.length,
                  itemBuilder: ((context, index) {
                    var recyclemerchant =
                        merchantController.recyclemerchant[index];
                    return RecyclebinMerchantWidget(
                      merchantname: recyclemerchant.merchantName,
                      merchantamount: recyclemerchant.merchantAmount,
                      merchantphone: recyclemerchant.merchantPhone,
                      merchantaddress: recyclemerchant.merchantAddress,
                      merchantemail: recyclemerchant.merchantEmail,
                      iseven: index % 2 == 0,
                      dateTime: recyclemerchant.date,
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
