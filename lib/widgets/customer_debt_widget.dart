// ignore_for_file: unnecessary_brace_in_string_interps, sized_box_for_whitespace, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/utils/app_constant.dart';

class CustomerDebtWidget extends StatefulWidget {
  final String customername;
  final int debtamount;
  final int subdebtamount;
  final String customerdebtUid;
  String? imageurl;
  final bool iseven;
  final DateTime dateTime;
  final String items;

  CustomerDebtWidget({
    super.key,
    required this.customerdebtUid,
    required this.customername,
    required this.debtamount,
    required this.subdebtamount,
    this.imageurl,

    required this.iseven,
    required this.dateTime,
    required this.items,
  });

  @override
  State<CustomerDebtWidget> createState() => _CustomerDebtWidgetState();
}

class _CustomerDebtWidgetState extends State<CustomerDebtWidget> {
  CustomerController customerController = Get.put(CustomerController());

  TextEditingController amountController = TextEditingController();

  TextEditingController itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 70.h,
          width: double.infinity.w,
          color: Colors.grey[200],
          child: Row(
            children: [
              Container(
                height: 70.h,
                width: 140.w,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(widget.dateTime),
                            style: TextStyle(
                              color: const Color.fromARGB(101, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          if (widget.debtamount > 0)
                            GestureDetector(
                              onTap: () {
                                adddebt(context);
                              },
                              child: Icon(Icons.edit, size: 15),
                            ),
                          if (widget.subdebtamount > 0)
                            GestureDetector(
                              onTap: () {
                                subdebt(context);
                              },
                              child: Icon(Icons.edit, size: 15),
                            ),
                        ],
                      ),
                      Text(
                        widget.items,
                        style: TextStyle(
                          color: AppConstant.secondaty,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          imagepreview(context);
                        },
                        child: widget.imageurl != null
                            ? Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.imageurl!),
                                    fit: BoxFit.fill,
                                  ),
                                  border: Border.all(
                                    color: AppConstant.secondaty,
                                  ),
                                ),
                              )
                            : Text('no bill image'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 70.h,
                width: 110.w,
                color: const Color.fromARGB(95, 175, 76, 76),
                child: Center(
                  child: Text(
                    'Rs: ${widget.debtamount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppConstant.error,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70.h,
                  width: 109.w,
                  color: const Color.fromARGB(95, 84, 175, 76),
                  child: Center(
                    child: Text(
                      'Rs: ${widget.subdebtamount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: AppConstant.primery,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  adddebt(BuildContext context) {
    amountController.text = widget.debtamount.toString();
    itemController.text = widget.items.toString();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppConstant.container,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      '+ Debt',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: itemController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Item1 \n Item2 \n Item3',
                        prefixIcon: Icon(Icons.inventory),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: AppConstant.secondaty,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: amountController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        prefixIcon: Padding(
                          padding: EdgeInsetsGeometry.all(12),
                          child: Text(
                            'Rs',
                            style: TextStyle(
                              color: AppConstant.secondaty,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: AppConstant.secondaty,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () async {
                        String item = itemController.text.trim();
                        int amount = int.parse(amountController.text.trim());

                        await customerController.editcustomerdebt(
                          widget.customername,
                          widget.customerdebtUid,
                          item,
                          amount,
                        );
                        customerController.fetchcustomerdebt(
                          widget.customername,
                        );

                        Navigator.of(context).pop();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 40.h,
                          width: 180.w,
                          decoration: BoxDecoration(color: AppConstant.primery),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(color: AppConstant.container),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1000.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  subdebt(BuildContext context) {
    amountController.text = widget.subdebtamount.toString();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppConstant.container,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      '- Debt',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: amountController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        prefixIcon: Padding(
                          padding: EdgeInsetsGeometry.all(12),
                          child: Text(
                            'Rs',
                            style: TextStyle(
                              color: AppConstant.secondaty,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: AppConstant.secondaty,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () async {
                        int amount = int.parse(amountController.text.trim());

                        await customerController.editcustomersubdebt(
                          widget.customername,
                          widget.customerdebtUid,
                          '',
                          amount,
                        );
                        customerController.fetchcustomerdebt(
                          widget.customername,
                        );
                        Navigator.of(context).pop();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 40.h,
                          width: 180.w,
                          decoration: BoxDecoration(color: AppConstant.primery),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(color: AppConstant.container),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 500.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  imagepreview(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 600.h,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.imageurl!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
