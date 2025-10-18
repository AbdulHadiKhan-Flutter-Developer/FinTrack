// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/customer_controller.dart';

import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/recyclebin_customer_widget.dart';

class RecyclebinCustomerScreen extends StatefulWidget {
  @override
  State<RecyclebinCustomerScreen> createState() =>
      _RecyclebinCustomerScreenState();
}

class _RecyclebinCustomerScreenState extends State<RecyclebinCustomerScreen> {
  CustomerController customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        centerTitle: true,
        title: Obx(
          () =>
              Text('Recyclebin (${customerController.recyclecustomer.length})'),
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
                if (customerController.recyclecustomer.isEmpty) {
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
                  itemCount: customerController.recyclecustomer.length,
                  itemBuilder: ((context, index) {
                    var recyclecustomer =
                        customerController.recyclecustomer[index];
                    return RecyclebinCustomerWidget(
                      customername: recyclecustomer.customerName,
                      customeramount: recyclecustomer.customerAmount,
                      customerphone: recyclecustomer.customerPhone,
                      customeraddress: recyclecustomer.customerAddress,
                      iseven: index % 2 == 0,
                      dateTime: recyclecustomer.date,
                      email: recyclecustomer.customerEmail,
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
