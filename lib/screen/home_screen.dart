// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/auth_controller.dart';

import 'package:udhar/controllers/customer_controller.dart';
import 'package:udhar/controllers/merchant_controller.dart';

import 'package:udhar/screen/all_customer_screen.dart';
import 'package:udhar/screen/all_merchant_screen.dart';
import 'package:udhar/utils/app_constant.dart';
import 'package:udhar/widgets/appbar.dart';
import 'package:udhar/widgets/customer_widget.dart';
import 'package:udhar/widgets/merchant_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  CustomerController customerController = Get.put(CustomerController());
  MerchantController merchantController = Get.put(MerchantController());
  AuthController authController = Get.put(AuthController());
  late TabController _tabController;
  void fetchcustomerandmerchant() async {
    await customerController.fetchallcunstomersmethod();
    await customerController.totalamount;
    await merchantController.fetchAllMerchants();
    await authController.fetchuserdata();
  }

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();

  TextEditingController merchantNameController = TextEditingController();
  TextEditingController merchantEmailController = TextEditingController();
  TextEditingController merchantPhoneController = TextEditingController();
  TextEditingController merchantAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchcustomerandmerchant();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.container,
      appBar: AppBar(
        bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.people_alt_outlined, size: 20)),
            Tab(icon: Icon(Icons.store_mall_directory_outlined, size: 20)),
          ],
        ),
        backgroundColor: AppConstant.container,
        centerTitle: true,
        title: Text(
          authController.usershopname,
          style: TextStyle(
            color: AppConstant.primery,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Appbar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(
                            110,
                            33,
                            167,
                            0,
                          ),
                          radius: 11.r,
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 11.sp,
                            color: AppConstant.container,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Obx(
                          () => Text(
                            '${customerController.receivedAmount.value} -/Pkr',
                            style: TextStyle(color: AppConstant.primery),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(109, 167, 0, 0),
                          radius: 11.r,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 11.sp,
                            color: AppConstant.container,
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Obx(
                          () => Text(
                            '${customerController.pendingAmount.value} -/Pkr',
                            style: TextStyle(color: AppConstant.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    addcustomer(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 40.h,
                      width: 180.w,
                      decoration: BoxDecoration(color: AppConstant.primery),
                      child: Center(
                        child: Text(
                          'Add Customer',
                          style: TextStyle(color: AppConstant.container),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Customer',
                      style: TextStyle(color: AppConstant.secondaty),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(AllCustomerScreen());
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
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
          Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(
                            110,
                            33,
                            167,
                            0,
                          ),
                          radius: 11.r,
                          child: Icon(
                            Icons.check,
                            size: 11.sp,
                            color: AppConstant.container,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Obx(
                          () => Text(
                            '${merchantController.paiddue.value} -/Pkr',
                            style: TextStyle(color: AppConstant.primery),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(109, 167, 0, 0),
                          radius: 11.r,
                          child: Icon(
                            Icons.pending_outlined,
                            size: 11.sp,
                            color: AppConstant.container,
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Obx(
                          () => Text(
                            '${merchantController.pendingdue.value} -/Pkr',
                            style: TextStyle(color: AppConstant.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () async {
                    addmerchant(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 40.h,
                      width: 180.w,
                      decoration: BoxDecoration(color: AppConstant.primery),
                      child: Center(
                        child: Text(
                          'Add Merchant',
                          style: TextStyle(color: AppConstant.container),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Merchant',
                      style: TextStyle(color: AppConstant.secondaty),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(AllMerchantScreen());
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
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
                    itemBuilder: (context, index) {
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
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  addcustomer(BuildContext context) {
    return showModalBottomSheet(
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: customerNameController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Customer Name',
                        prefixIcon: Icon(Icons.person_2_outlined),
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
                      controller: customerEmailController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Customer E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
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
                      controller: customerPhoneController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Customer Phone',
                        prefixIcon: Icon(Icons.call),
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
                      controller: customerAddressController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Customer Address',
                        prefixIcon: Icon(Icons.location_city_outlined),
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
                        String name = customerNameController.text.trim();
                        String email = customerEmailController.text.trim();
                        String phone = customerPhoneController.text.trim();
                        String address = customerAddressController.text.trim();

                        await customerController.addCustomermethod(
                          name,
                          email,
                          address,
                          phone,
                        );
                        customerController.fetchallcunstomersmethod();
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

  addmerchant(BuildContext context) {
    return showModalBottomSheet(
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: merchantNameController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Merchant Name',
                        prefixIcon: Icon(Icons.person_2_outlined),
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
                      controller: merchantEmailController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Merchant E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
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
                      controller: merchantPhoneController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Merchant Phone',
                        prefixIcon: Icon(Icons.call),
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
                      controller: merchantAddressController,
                      cursorColor: AppConstant.secondaty,
                      style: TextStyle(color: AppConstant.secondaty),
                      decoration: InputDecoration(
                        hintText: 'Merchant Address',
                        prefixIcon: Icon(Icons.location_city_outlined),
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
                        String name = merchantNameController.text.trim();
                        String email = merchantEmailController.text.trim();
                        String phone = merchantPhoneController.text.trim();
                        String address = merchantAddressController.text.trim();

                        await merchantController.addMerchant(
                          name,
                          email,
                          address,
                          phone,
                        );
                        merchantController.fetchAllMerchants();
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
