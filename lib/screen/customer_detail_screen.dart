// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/screen/customer_info_screen.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/customer_debt_widget.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customername;
  int customeramount;
  final String customerphone;
  final String customeraddress;
  final DateTime dateTime;

  CustomerDetailScreen({
    super.key,
    required this.customername,
    required this.customeramount,
    required this.customeraddress,
    required this.customerphone,
    required this.dateTime,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  TextEditingController amountController = TextEditingController();

  TextEditingController itemController = TextEditingController();

  CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.fetchcustomerdebt(widget.customername);
      customerController.totalamount.value = widget.customeramount;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      Get.offAll(adddebt(context));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(color: AppConstant.error),
                        child: Center(
                          child: Text(
                            '+ Debt',
                            style: TextStyle(
                              color: AppConstant.container,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      subdebt(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(color: AppConstant.primery),
                        child: Center(
                          child: Text(
                            '- Debt',
                            style: TextStyle(
                              color: AppConstant.container,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                if (customerController.customerdebt.isEmpty) {
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
                  itemCount: customerController.customerdebt.length,
                  itemBuilder: ((context, index) {
                    var customer = customerController.customerdebt[index];
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

  adddebt(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          customerController.pickgalleryimage();
                        },
                        child: Icon(Icons.image),
                      ),
                      GestureDetector(
                        onTap: () {
                          customerController.pickcameraimage();
                        },
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  Obx(
                    () => customerController.imagefile.value != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 200.h,
                              width: 200.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppConstant.secondaty,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                    customerController.imagefile.value!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              height: 200.h,
                              width: 200.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppConstant.secondaty,
                                ),
                              ),
                              child: Center(child: Text('No Preview')),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () async {
                        String item = itemController.text.trim();
                        int amount = int.parse(amountController.text.trim());

                        await customerController.adddebtmethod(
                          widget.customername,
                          amount,
                          item,
                        );
                        await customerController.uploadimage();

                        customerController.fetchcustomerdebt(
                          widget.customername,
                        );
                        itemController.clear();
                        amountController.clear();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          customerController.pickgalleryimage();
                        },
                        child: Icon(Icons.image),
                      ),
                      GestureDetector(
                        onTap: () {
                          customerController.pickcameraimage();
                        },
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  customerController.imagefile.value != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppConstant.secondaty),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(
                                  customerController.imagefile.value!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 200.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppConstant.secondaty),
                            ),
                            child: Center(child: Text('No Preview')),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () async {
                        int amount = int.parse(amountController.text.trim());

                        await customerController.subtractcustomerdebtmethod(
                          widget.customername,
                          amount,
                        );
                        await customerController.uploadimage();
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
}
