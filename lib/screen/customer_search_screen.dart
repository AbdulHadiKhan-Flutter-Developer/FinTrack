// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/customer_widget.dart';

class CustomerSearchScreen extends StatelessWidget {
  CustomerController customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.container,
        title: Text('Search Customer'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        color: AppConstant.container,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50.h,
                width: double.infinity.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(69, 176, 190, 197),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          cursorColor: AppConstant.secondaty,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Customer Name',
                          ),
                          onChanged: (value) {
                            customerController.searchCustomerByName(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (customerController.serchcustomer.isEmpty) {
                  return Center(
                    child: Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/search.png'),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: customerController.serchcustomer.length,
                  itemBuilder: (context, index) {
                    var customer = customerController.serchcustomer[index];
                    return CustomerWidget(
                      customername: customer.customerName,
                      customeramount: customer.customerAmount,
                      customerphone: customer.customerPhone,
                      customeraddress: customer.customerAddress,
                      iseven: index % 2 == 0,
                      dateTime: customer.date,
                      email: customer.customerEmail,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
