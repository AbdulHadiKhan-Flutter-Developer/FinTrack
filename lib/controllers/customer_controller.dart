// ignore_for_file: avoid_print, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:udhar/controllers/loading_controller.dart';
import 'package:udhar/models/customer_debt_model.dart';
import 'package:udhar/models/customer_model.dart';
import 'package:udhar/screen/home_screen.dart';

class CustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var imagefile = Rx<File?>(null);

  var customers = <CustomerModel>[].obs;
  var customerdebt = <CustomerDebtModel>[].obs;
  var totalamount = 0.obs;
  var pendingAmount = 0.obs;
  var receivedAmount = 0.obs;
  var serchcustomer = <CustomerModel>[].obs;
  var recyclecustomer = <CustomerModel>[].obs;
  var recyclecustomerdue = <CustomerDebtModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchallcunstomersmethod();

    calculateTotals();
    fetchRecycleCustomer();
  }

  Future<void> searchCustomerByName(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firestore
          .collection('Customer')
          .where('customerUid', isEqualTo: uid)
          .get();

      serchcustomer.value = querysnapshot.docs
          .map((doc) => CustomerModel.formmap(doc.data()))
          .where(
            (customer) => customer.customerName.toLowerCase().startsWith(
              name.toLowerCase(),
            ),
          )
          .toList();
      loading.dismissloading();
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
    }
  }

  Future<void> addCustomermethod(
    String customername,
    String customeremail,
    String customeraddress,
    String customerphone,
  ) async {
    final loading = Get.find<LoadingController>();
    try {
      loading.showloading();
      CustomerModel customerModel = CustomerModel(
        customerUid: uid,
        customerName: customername,
        customerAmount: 0,
        customerEmail: customeremail,
        customerAddress: customeraddress,
        customerPhone: customerphone,
        date: DateTime.now(),
      );
      await _firestore.collection('Customer').add(customerModel.tomap());
      Get.snackbar('Success', 'Customer added successfully');
      Get.off(HomeScreen());
      loading.dismissloading();
    } on FirebaseAuthException catch (e) {
      print('Error : $e');
      loading.dismissloading();
    }
  }

  Future<void> fetchallcunstomersmethod() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firestore
          .collection('Customer')
          .where('customerUid', isEqualTo: uid)
          .get();

      customers.value = querysnapshot.docs
          .map((doc) => CustomerModel.formmap(doc.data()))
          .toList();
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> adddebtmethod(String name, int debtamount, String items) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      QuerySnapshot querySnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final customerRef = _firestore.collection('Customer').doc(doc.id);
        final newDebtRef = customerRef.collection('debt').doc();

        int currentamount = doc['customerAmount'];
        int newamount = currentamount + debtamount;

        await customerRef.update({'customerAmount': newamount});
        totalamount.value = newamount;

        String imageurl = "";
        if (imagefile.value != null) {
          final uploaded = await uploadimage();
          if (uploaded != null) imageurl = uploaded;
        }

        CustomerDebtModel customerDebtModel = CustomerDebtModel(
          customerdebtUid: newDebtRef.id,
          customerName: name,
          debtAmount: debtamount,
          subdebtAmount: 0,
          date: DateTime.now(),
          items: items,
          imageurl: imageurl,
        );

        await newDebtRef.set(customerDebtModel.tomap());
        loading.dismissloading();
      }
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> fetchcustomerdebt(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        var debtSnapshot = await _firestore
            .collection('Customer')
            .doc(docId)
            .collection('debt')
            .orderBy('date', descending: true)
            .get();

        customerdebt.value = debtSnapshot.docs
            .map((doc) => CustomerDebtModel.formmap(doc.data()))
            .toList();
        loading.dismissloading();
      }
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> subtractcustomerdebtmethod(
    String name,
    int subdebtamount,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      QuerySnapshot querysnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: name)
          .get();

      if (querysnapshot.docs.isNotEmpty) {
        var doc = querysnapshot.docs.first;
        final customerRef = _firestore.collection('Customer').doc(doc.id);
        final newDebtRef = customerRef.collection('debt').doc();

        int currentamount = doc['customerAmount'];
        int newamount = currentamount - subdebtamount;

        await customerRef.update({'customerAmount': newamount});
        totalamount.value = newamount;

        String imageurl = '';
        if (imagefile.value != null) {
          final uploaded = await uploadimage();
          if (uploaded != null) imageurl = uploaded;
        }

        CustomerDebtModel customerDebtModel = CustomerDebtModel(
          customerdebtUid: newDebtRef.id,
          customerName: name,
          debtAmount: 0,
          subdebtAmount: subdebtamount,
          date: DateTime.now(),
          items: '',
          imageurl: imageurl,
        );

        await newDebtRef.set(customerDebtModel.tomap());
        loading.dismissloading();
      }
    } catch (e) {
      print('error:$e');
      loading.dismissloading();
    }
  }

  Future<void> calculateTotals() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firestore
          .collection('Customer')
          .where('customerUid', isEqualTo: uid)
          .get();

      int totalPending = 0;
      int totalReceived = 0;

      for (var doc in querysnapshot.docs) {
        int amount = doc['customerAmount'] ?? 0;
        totalPending += amount;

        var debtSnapshot = await _firestore
            .collection('Customer')
            .doc(doc.id)
            .collection('debt')
            .get();

        for (var debtDoc in debtSnapshot.docs) {
          int received = debtDoc['subdebtAmount'] ?? 0;
          totalReceived += received;
        }
      }

      pendingAmount.value = totalPending;
      receivedAmount.value = totalReceived;
      loading.dismissloading();
    } catch (e) {
      print("Error calculating totals: $e");
      loading.dismissloading();
    }
  }

  Future<void> editcustomerdebt(
    String customerName,
    String customerdebtuid,
    String newItem,
    int newDebtAmount,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: customerName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final customerDoc = querySnapshot.docs.first;

        var debtSnapshot = await _firestore
            .collection('Customer')
            .doc(customerDoc.id)
            .collection('debt')
            .where('customerdebtUid', isEqualTo: customerdebtuid)
            .get();

        if (debtSnapshot.docs.isNotEmpty) {
          final debtDoc = debtSnapshot.docs.first;

          int oldDebt = debtDoc['debtAmount'] ?? 0;

          int currentTotal = customerDoc['customerAmount'] ?? 0;
          int newTotal = (currentTotal - oldDebt) + newDebtAmount;

          await debtDoc.reference.update({
            'items': newItem,
            'debtAmount': newDebtAmount,
            'subdebtAmount': 0,
            'date': DateTime.now(),
          });

          await _firestore.collection('Customer').doc(customerDoc.id).update({
            'customerAmount': newTotal,
          });

          totalamount.value = newTotal;

          await fetchcustomerdebt(customerName);
          await calculateTotals();

          Get.snackbar("Success", "Debt updated successfully");
        } else {
          print(
            "No debt record found for $customerName with UID $customerdebtuid",
          );
        }
      }
      loading.dismissloading();
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
    }
  }

  Future<void> editcustomersubdebt(
    String customerName,
    String customerdebtuid,
    String newItem,
    int newSubDebtAmount,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: customerName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final customerDoc = querySnapshot.docs.first;

        var debtSnapshot = await _firestore
            .collection('Customer')
            .doc(customerDoc.id)
            .collection('debt')
            .where('customerdebtUid', isEqualTo: customerdebtuid)
            .get();

        if (debtSnapshot.docs.isNotEmpty) {
          final debtDoc = debtSnapshot.docs.first;

          int oldsubDebt = debtDoc['subdebtAmount'] ?? 0;
          int currentTotal = customerDoc['customerAmount'] ?? 0;
          int newTotal = (currentTotal + oldsubDebt) - newSubDebtAmount;

          await debtDoc.reference.update({
            'items': newItem,
            'debtAmount': 0,
            'subdebtAmount': newSubDebtAmount,
            'date': DateTime.now(),
          });

          await _firestore.collection('Customer').doc(customerDoc.id).update({
            'customerAmount': newTotal,
          });

          totalamount.value = newTotal;

          await fetchcustomerdebt(customerName);
          await calculateTotals();

          Get.snackbar("Success", "Subdebt updated successfully");
        } else {
          print(
            "No subdebt record found for $customerName with UID $customerdebtuid",
          );
        }
      }
      loading.dismissloading();
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
    }
  }

  void pickgalleryimage() async {
    ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagefile.value = File(image.path);
    }
  }

  void pickcameraimage() async {
    ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      imagefile.value = File(image.path);
    }
  }

  Future<String?> uploadimage() async {
    final loading = Get.find<LoadingController>();

    if (imagefile.value == null) return null;

    final filename = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    final path = 'upload/$filename';

    final file = File(imagefile.value!.path);
    loading.showloading();

    await Supabase.instance.client.storage.from('bills').upload(path, file);

    final imageurl = Supabase.instance.client.storage
        .from('bills')
        .getPublicUrl(path);
    loading.dismissloading();

    return imageurl;
  }

  Future<void> deletecustomermethod(
    String name,
    String address,
    String phone,
    int amount,
    DateTime date,
    String email,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firestore
          .collection('Customer')
          .where('customerName', isEqualTo: name)
          .get();

      final doc = querysnapshot.docs.first;

      var duesnapshot = await _firestore
          .collection('Customer')
          .doc(doc.id)
          .collection('debt')
          .get();

      CustomerModel customerModel = CustomerModel(
        customerUid: uid,
        customerName: name,
        customerAmount: amount,
        customerEmail: email,
        customerAddress: address,
        customerPhone: phone,
        date: date,
      );

      await _firestore.collection('recyclebincustomer').doc(doc.id).set({
        ...customerModel.tomap(),
        'deletedAt': DateTime.now(),
      });

      for (var debt in duesnapshot.docs) {
        await _firestore
            .collection('recyclebincustomer')
            .doc(doc.id)
            .collection('debt')
            .doc(debt.id)
            .set({...debt.data(), 'deletedAt': DateTime.now()});
        await debt.reference.delete();
      }

      await _firestore.collection('Customer').doc(doc.id).delete();
      await calculateTotals();
      await fetchRecycleCustomer();

      customers.removeWhere((merchant) => merchant.customerName == name);
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> fetchRecycleCustomer() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var snapshot = await _firestore.collection('recyclebincustomer').get();

      recyclecustomer.value = snapshot.docs
          .map((doc) => CustomerModel.formmap(doc.data()))
          .toList();
      loading.dismissloading();
    } catch (e) {
      print('Error fetching recycle merchants: $e');
      loading.dismissloading();
    }
  }

  Future<void> fetchrecyclecustomerdues(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var docsnapshot = await _firestore
          .collection('recyclebincustomer')
          .where('customerName', isEqualTo: name)
          .get();

      final doc = docsnapshot.docs.first;

      var duesnapshot = await _firestore
          .collection('recyclebincustomer')
          .doc(doc.id)
          .collection('debt')
          .orderBy('date', descending: true)
          .get();

      recyclecustomerdue.value = duesnapshot.docs
          .map((due) => CustomerDebtModel.formmap(due.data()))
          .toList();
      loading.dismissloading();
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
    }
  }

  Future<void> restorerecyclebin(
    String name,
    String address,
    String phone,
    int amount,
    DateTime date,
    String email,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var recyclequerysnapshot = await _firestore
          .collection('recyclebincustomer')
          .where('customerName', isEqualTo: name)
          .get();

      final doc = recyclequerysnapshot.docs.first;

      var recycleduesnapshot = await _firestore
          .collection('recyclebincustomer')
          .doc(doc.id)
          .collection('debt')
          .get();

      CustomerModel customerModel = CustomerModel(
        customerUid: uid,
        customerName: name,
        customerAmount: amount,
        customerEmail: email,
        customerAddress: address,
        customerPhone: phone,
        date: date,
      );

      await _firestore.collection('Customer').doc(doc.id).set({
        ...customerModel.tomap(),
      });

      for (var debt in recycleduesnapshot.docs) {
        await _firestore
            .collection('Customer')
            .doc(doc.id)
            .collection('debt')
            .doc(debt.id)
            .set({...debt.data()});

        await debt.reference.delete();
        await calculateTotals();
      }

      await _firestore.collection('recyclebincustomer').doc(doc.id).delete();

      recyclecustomer.removeWhere((merchant) => merchant.customerName == name);
      await fetchRecycleCustomer();
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> deleterecyclebin(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firestore
          .collection('recyclebincustomer')
          .where('customerName', isEqualTo: name)
          .get();

      final doc = querysnapshot.docs.first;
      await _firestore.collection('recyclebincustomer').doc(doc.id).delete();

      recyclecustomer.removeWhere((merchant) => merchant.customerName == name);
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }
}
