// ignore_for_file: unnecessary_brace_in_string_interps, must_be_immutable, use_build_context_synchronously, use_key_in_widget_constructors, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/merchant_controller.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/screen/merchant_info_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/merchant_dues_widget.dart';

class MerchantDetailScreen extends StatefulWidget {
  final String merchantname;
  int merchantamount;
  final String merchantphone;
  final String merchantaddress;
  final DateTime dateTime;

  MerchantDetailScreen({
    super.key,
    required this.merchantname,
    required this.merchantphone,
    required this.merchantaddress,
    required this.dateTime,
    required this.merchantamount,
  });

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  MerchantController merchantController = Get.put(MerchantController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      merchantController.fetchMerchantDues(widget.merchantname);
      merchantController.totalamount.value = widget.merchantamount;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      adddue(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(color: AppConstant.error),
                        child: Center(
                          child: Text(
                            'Due',
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
                      addpaid(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(color: AppConstant.primery),
                        child: Center(
                          child: Text(
                            'Paid',
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
                if (merchantController.merchantdues.isEmpty) {
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
                  itemCount: merchantController.merchantdues.length,
                  itemBuilder: ((context, index) {
                    var merchant = merchantController.merchantdues[index];
                    return MerchantDuesWidget(
                      merchantdueUid: merchant.merchantUid,
                      merchantname: merchant.merchantName,
                      dueamount: merchant.dueAmount,
                      paidamount: merchant.paidAmount,

                      iseven: index % 2 == 0,
                      dateTime: merchant.date,
                      items: merchant.items,
                      imageurl: merchant.imageurl,
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

  adddue(BuildContext context) {
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
                      'Due',
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
                          merchantController.pickgalleryimage();
                        },
                        child: Icon(Icons.image),
                      ),
                      GestureDetector(
                        onTap: () {
                          merchantController.pickcameraimage();
                        },
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  Obx(
                    () => merchantController.imagefile.value != null
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
                                    merchantController.imagefile.value!,
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
                        String items = itemController.text.trim();
                        int dueamount = int.parse(amountController.text.trim());
                        merchantController.addDue(
                          widget.merchantname,
                          dueamount,
                          items,
                        );
                        await merchantController.uploadimage();
                        merchantController.fetchMerchantDues(
                          widget.merchantname,
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

  addpaid(BuildContext context) {
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
                          merchantController.pickgalleryimage();
                        },
                        child: Icon(Icons.image),
                      ),
                      GestureDetector(
                        onTap: () {
                          merchantController.pickcameraimage();
                        },
                        child: Icon(Icons.camera),
                      ),
                    ],
                  ),
                  Obx(
                    () => merchantController.imagefile.value != null
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
                                    merchantController.imagefile.value!,
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
                        int amount = int.parse(amountController.text.trim());
                        await merchantController.payDue(
                          widget.merchantname,
                          amount,
                        );
                        await merchantController.uploadimage();
                        merchantController.fetchMerchantDues(
                          widget.merchantname,
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
