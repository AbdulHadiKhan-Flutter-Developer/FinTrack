// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/screen/merchant_search_screen.dart';
import 'package:udhar/screen/recyclebin_merchant_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/appbar.dart';
import 'package:udhar/widgets/merchant_widget.dart';

class AllMerchantScreen extends StatefulWidget {
  @override
  State<AllMerchantScreen> createState() => _AllMerchantScreenState();
}

class _AllMerchantScreenState extends State<AllMerchantScreen> {
  MerchantController merchantController = Get.put(MerchantController());
  @override
  void initState() {
    merchantController.fetchAllMerchants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        centerTitle: true,
        title: Obx(
          () => Text('Merchants (${merchantController.merchants.length})'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey, // underline color
            height: 1.0, // underline thickness
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  MerchantSearchScreen(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500),
                );
              },
              child: Icon(Icons.search_rounded),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  RecyclebinMerchantScreen(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500),
                );
              },
              child: Icon(Icons.recycling),
            ),
          ),
        ],
      ),
      drawer: Appbar(),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        color: AppConstant.container,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (merchantController.merchants.isEmpty) {
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
                  itemCount: merchantController.merchants.length,
                  itemBuilder: ((context, index) {
                    var merchant = merchantController.merchants[index];
                    return MerchantWidget(
                      merchantname: merchant.merchantName,
                      merchantamount: merchant.merchantAmount,
                      merchantphone: merchant.merchantPhone,
                      merchantaddress: merchant.merchantAddress,
                      iseven: index % 2 == 0,
                      dateTime: merchant.date,
                      merchantemail: merchant.merchantEmail,
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
