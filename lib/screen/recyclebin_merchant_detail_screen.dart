// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable, use_build_context_synchronously, use_key_in_widget_constructors, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/screen/merchant_info_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/merchant_dues_widget.dart';

class RecyclebinMerchantDetailScreen extends StatefulWidget {
  final String merchantname;
  int merchantamount;
  final String merchantphone;
  final String merchantaddress;
  final DateTime dateTime;

  RecyclebinMerchantDetailScreen({
    super.key,
    required this.merchantname,
    required this.merchantphone,
    required this.merchantaddress,
    required this.dateTime,
    required this.merchantamount,
  });

  @override
  State<RecyclebinMerchantDetailScreen> createState() =>
      _RecyclebinMerchantDetailScreenState();
}

class _RecyclebinMerchantDetailScreenState
    extends State<RecyclebinMerchantDetailScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  MerchantController merchantController = Get.put(MerchantController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      merchantController.totalamount.value = widget.merchantamount;
      merchantController.fetchrecyclemerchantdues(widget.merchantname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(
              HomeScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: AppConstant.container,
        title: Text(widget.merchantname),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Get.off(
                  MerchantInfoScreen(
                    merchantaddress: widget.merchantaddress,
                    merchantname: widget.merchantname,
                    merchantphone: widget.merchantphone,
                    merchantamount: widget.merchantamount,
                    dateTime: widget.dateTime,
                  ),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500),
                );
              },
              icon: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        color: AppConstant.container,
        child: Column(
          children: [
            Divider(),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'Total Amount',
                style: TextStyle(
                  color: AppConstant.secondaty,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Obx(
              () => Text(
                '${merchantController.totalamount.value}-/Pkr',
                style: TextStyle(
                  color: AppConstant.primery,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.h),

            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'ENTRIES',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                  Text(
                    'Due',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),

                  Text(
                    'Paid',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (merchantController.recyclemerchntdue.isEmpty) {
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
                  itemCount: merchantController.recyclemerchntdue.length,
                  itemBuilder: ((context, index) {
                    var recyclemerchantdue =
                        merchantController.recyclemerchntdue[index];
                    return MerchantDuesWidget(
                      merchantdueUid: recyclemerchantdue.merchantUid,
                      merchantname: recyclemerchantdue.merchantName,
                      dueamount: recyclemerchantdue.dueAmount,
                      paidamount: recyclemerchantdue.paidAmount,

                      iseven: index % 2 == 0,
                      dateTime: recyclemerchantdue.date,
                      items: recyclemerchantdue.items,
                      imageurl: recyclemerchantdue.imageurl,
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
