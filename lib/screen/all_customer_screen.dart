// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/screen/customer_search_screen.dart';
import 'package:udhar/screen/recyclebin_customer_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/appbar.dart';
import 'package:udhar/widgets/customer_widget.dart';

class AllCustomerScreen extends StatefulWidget {
  @override
  State<AllCustomerScreen> createState() => _AllCustomerScreenState();
}

class _AllCustomerScreenState extends State<AllCustomerScreen> {
  CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        centerTitle: true,
        title: Obx(
          () => Text('Customers (${customerController.customers.length})'),
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
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  CustomerSearchScreen(),
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
                  RecyclebinCustomerScreen(),
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
                if (customerController.customers.isEmpty) {
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
                  itemCount: customerController.customers.length,
                  itemBuilder: ((context, index) {
                    var customer = customerController.customers[index];
                    return CustomerWidget(
                      customername: customer.customerName,
                      customeramount: customer.customerAmount,
                      customerphone: customer.customerPhone,
                      customeraddress: customer.customerAddress,
                      iseven: index % 2 == 0,
                      dateTime: customer.date,
                      email: customer.customerEmail,
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
