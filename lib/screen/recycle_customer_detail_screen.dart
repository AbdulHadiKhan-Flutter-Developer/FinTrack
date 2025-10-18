// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/screen/customer_info_screen.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/customer_debt_widget.dart';

class RecycleCustomerDetailScreen extends StatefulWidget {
  final String customername;
  int customeramount;
  final String customerphone;
  final String customeraddress;
  final DateTime dateTime;

  RecycleCustomerDetailScreen({
    super.key,
    required this.customername,
    required this.customeramount,
    required this.customeraddress,
    required this.customerphone,
    required this.dateTime,
  });

  @override
  State<RecycleCustomerDetailScreen> createState() =>
      _RecycleCustomerDetailScreenState();
}

class _RecycleCustomerDetailScreenState
    extends State<RecycleCustomerDetailScreen> {
  TextEditingController amountController = TextEditingController();

  TextEditingController itemController = TextEditingController();

  CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.totalamount.value = widget.customeramount;
      customerController.fetchrecyclecustomerdues(widget.customername);
    });
    super.initState();
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
        title: Text(widget.customername),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Get.off(
                  CustomerInfoScreen(
                    customeraddress: widget.customeraddress,
                    customername: widget.customername,
                    customerphone: widget.customerphone,
                    customeramount: widget.customeramount,
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
                '${customerController.totalamount.value}-/Pkr',
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
                    'YOU GAVE',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),

                  Text(
                    'YOU GOT',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (customerController.recyclecustomerdue.isEmpty) {
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
                  itemCount: customerController.recyclecustomerdue.length,
                  itemBuilder: ((context, index) {
                    var customer = customerController.recyclecustomerdue[index];
                    return CustomerDebtWidget(
                      customerdebtUid: customer.customerdebtUid,
                      customername: customer.customerName,
                      debtamount: customer.debtAmount,
                      subdebtamount: customer.subdebtAmount,
                      imageurl: customer.imageurl,

                      iseven: index % 2 == 0,
                      dateTime: customer.date,
                      items: customer.items,
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
