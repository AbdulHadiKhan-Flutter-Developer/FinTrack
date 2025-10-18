// ignore_for_file: avoid_print, body_might_complete_normally_nullable, avoid_types_as_parameter_names, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:udhar/controllers/loading_controller.dart';
import 'package:udhar/models/merchant_dues_model.dart';
import 'package:udhar/models/merchant_model.dart';
import 'package:udhar/screen/home_screen.dart';

class MerchantController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var imagefile = Rx<File?>(null);

  var merchants = <MerchantModel>[].obs;
  var merchantdues = <MerchantDuesModel>[].obs;
  var totalamount = 0.obs;
  var pendingdue = 0.obs;
  var paiddue = 0.obs;
  var searchResults = <MerchantModel>[].obs;
  var recyclemerchant = <MerchantModel>[].obs;
  var recyclemerchntdue = <MerchantDuesModel>[].obs;

  @override
  void onReady() {
    fetchAllMerchants();
    calculateTotals();
    fetchRecycleMerchants();

    super.onReady();
  }

  Future<void> searchMerchantByName(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantUid', isEqualTo: uid)
          .get();

      searchResults.value = querySnapshot.docs
          .map((doc) => MerchantModel.formmap(doc.data()))
          .where(
            (merchant) => merchant.merchantName.toLowerCase().startsWith(
              name.toLowerCase(),
            ),
          )
          .toList();
      loading.dismissloading();
    } catch (e) {
      print("Error searching merchants: $e");
      loading.dismissloading();
    }
  }

  Future<void> addMerchant(
    String merchantName,
    String merchantEmail,
    String merchantAddress,
    String merchantPhone,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      MerchantModel merchantModel = MerchantModel(
        merchantUid: uid,
        merchantName: merchantName,
        merchantEmail: merchantEmail,
        merchantAddress: merchantAddress,
        merchantPhone: merchantPhone,
        date: DateTime.now(),
        merchantAmount: 0,
      );

      await _firestore.collection('Merchant').add(merchantModel.tomap());

      Get.snackbar("Success", "Merchant added successfully");
      Get.off(HomeScreen());
      loading.dismissloading();
    } on FirebaseAuthException catch (e) {
      print("Error adding merchant: $e");
      loading.dismissloading();
    }
  }

  Future<void> fetchAllMerchants() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantUid', isEqualTo: uid)
          .get();

      merchants.value = querySnapshot.docs
          .map((doc) => MerchantModel.formmap(doc.data()))
          .toList();
      loading.dismissloading();
    } catch (e) {
      print("Error fetching merchants: $e");
      loading.dismissloading();
    }
  }

  Future<void> addDue(String name, int dueAmount, String items) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantName', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final merchantRef = _firestore.collection('Merchant').doc(doc.id);
        final newDueRef = merchantRef.collection('due').doc();

        int currentAmount = doc['merchantAmount'];
        int newAmount = currentAmount + dueAmount;

        await merchantRef.update({'merchantAmount': newAmount});
        totalamount.value = newAmount;

        String imageurl = '';
        if (imagefile.value != null) {
          final uploaded = await uploadimage();
          if (uploaded != null) imageurl = uploaded;
        }

        MerchantDuesModel merchantDuesModel = MerchantDuesModel(
          merchantUid: newDueRef.id,
          merchantName: name,
          dueAmount: dueAmount,
          paidAmount: 0,
          date: DateTime.now(),
          items: items,
          imageurl: imageurl,
        );

        await newDueRef.set(merchantDuesModel.tomap());
        loading.dismissloading();
      }
    } catch (e) {
      print("Error adding due: $e");
      loading.dismissloading();
    }
  }

  Future<void> fetchMerchantDues(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantName', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        var dueSnapshot = await _firestore
            .collection('Merchant')
            .doc(docId)
            .collection('due')
            .orderBy('date', descending: true)
            .get();

        merchantdues.value = dueSnapshot.docs
            .map((doc) => MerchantDuesModel.formmap(doc.data()))
            .toList();
        loading.dismissloading();
      }
    } catch (e) {
      print("Error fetching merchant dues: $e");
      loading.dismissloading();
    }
  }

  Future<void> payDue(String name, int paidAmount) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantName', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final merchantRef = _firestore.collection('Merchant').doc(doc.id);
        final newDueRef = merchantRef.collection('due').doc();

        int currentAmount = doc['merchantAmount'];
        int newAmount = currentAmount - paidAmount;

        await merchantRef.update({'merchantAmount': newAmount});
        totalamount.value = newAmount;

        String imageurl = '';
        if (imagefile.value != null) {
          final uploaded = await uploadimage();
          if (uploaded != null) imageurl = uploaded;
        }

        MerchantDuesModel merchantDuesModel = MerchantDuesModel(
          merchantUid: newDueRef.id,
          merchantName: name,
          dueAmount: 0,
          paidAmount: paidAmount,
          date: DateTime.now(),
          items: "",
          imageurl: imageurl,
        );

        await newDueRef.set(merchantDuesModel.tomap());
        loading.dismissloading();
      }
    } catch (e) {
      print("Error paying due: $e");
      loading.dismissloading();
    }
  }

  Future<void> calculateTotals() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantUid', isEqualTo: uid)
          .get();

      int totalPending = 0;
      int totalPaid = 0;

      for (var doc in querySnapshot.docs) {
        int amount = doc['merchantAmount'] ?? 0;
        totalPending += amount;

        var dueSnapshot = await _firestore
            .collection('Merchant')
            .doc(doc.id)
            .collection('due')
            .get();

        for (var dueDoc in dueSnapshot.docs) {
          int paid = dueDoc['paidAmount'] ?? 0;
          totalPaid += paid;
        }
      }

      pendingdue.value = totalPending;
      paiddue.value = totalPaid;
      loading.dismissloading();
    } catch (e) {
      print("Error calculating totals: $e");
      loading.dismissloading();
    }
  }

  Future<void> editMerchantDue(
    String merchantName,
    String merchantDueUid,
    String newItem,
    int newDueAmount,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantName', isEqualTo: merchantName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final merchantDoc = querySnapshot.docs.first;

        var dueSnapshot = await _firestore
            .collection('Merchant')
            .doc(merchantDoc.id)
            .collection('due')
            .where('merchantUid', isEqualTo: merchantDueUid)
            .get();

        if (dueSnapshot.docs.isNotEmpty) {
          final dueDoc = dueSnapshot.docs.first;

          int oldDue = dueDoc['dueAmount'] ?? 0;
          int currentTotal = merchantDoc['merchantAmount'] ?? 0;
          int newTotal = (currentTotal - oldDue) + newDueAmount;

          await dueDoc.reference.update({
            'items': newItem,
            'dueAmount': newDueAmount,
            'paidAmount': 0,
            'date': DateTime.now(),
          });

          await _firestore.collection('Merchant').doc(merchantDoc.id).update({
            'merchantAmount': newTotal,
          });

          totalamount.value = newTotal;

          await fetchMerchantDues(merchantName);
          await calculateTotals();

          Get.snackbar("Success", "Due updated successfully");
        }
      }
      loading.dismissloading();
    } catch (e) {
      print("Error editing merchant due: $e");
      loading.dismissloading();
    }
  }

  Future<void> editMerchantPaid(
    String merchantName,
    String merchantDueUid,
    String newItem,
    int newPaidAmount,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querySnapshot = await _firestore
          .collection('Merchant')
          .where('merchantName', isEqualTo: merchantName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final merchantDoc = querySnapshot.docs.first;

        var dueSnapshot = await _firestore
            .collection('Merchant')
            .doc(merchantDoc.id)
            .collection('due')
            .where('merchantUid', isEqualTo: merchantDueUid)
            .get();

        if (dueSnapshot.docs.isNotEmpty) {
          final dueDoc = dueSnapshot.docs.first;

          int oldPaid = dueDoc['paidAmount'] ?? 0;
          int currentTotal = merchantDoc['merchantAmount'] ?? 0;
          int newTotal = (currentTotal + oldPaid) - newPaidAmount;

          await dueDoc.reference.update({
            'items': newItem,
            'dueAmount': 0,
            'paidAmount': newPaidAmount,
            'date': DateTime.now(),
          });

          await _firestore.collection('Merchant').doc(merchantDoc.id).update({
            'merchantAmount': newTotal,
          });

          totalamount.value = newTotal;

          await fetchMerchantDues(merchantName);
          await calculateTotals();

          Get.snackbar("Success", "Paid updated successfully");
        }
      }
      loading.dismissloading();
    } catch (e) {
      print("Error editing merchant paid: $e");
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

    try {
      if (imagefile.value == null) return null;

      final filename = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final path = 'upload/$filename';
      final file = File(imagefile.value!.path);
      loading.showloading();
      await Supabase.instance.client.storage.from('bills').upload(path, file);

      String imageurl = Supabase.instance.client.storage
          .from('bills')
          .getPublicUrl(path);
      loading.dismissloading();

      return imageurl;
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
    }
  }

  Future<void> deletemerchantmethod(
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
          .collection('Merchant')
          .where('merchantName', isEqualTo: name)
          .get();

      final doc = querysnapshot.docs.first;

      var duesnapshot = await _firestore
          .collection('Merchant')
          .doc(doc.id)
          .collection('due')
          .get();

      MerchantModel merchantModel = MerchantModel(
        merchantUid: uid,
        merchantName: name,
        merchantEmail: email,
        merchantAddress: address,
        merchantPhone: phone,
        date: date,
        merchantAmount: amount,
      );

      await _firestore.collection('recyclebin').doc(doc.id).set({
        ...merchantModel.tomap(),
        'deletedAt': DateTime.now(),
      });

      for (var due in duesnapshot.docs) {
        await _firestore
            .collection('recyclebin')
            .doc(doc.id)
            .collection('due')
            .doc(due.id)
            .set({...due.data(), 'deletedAt': DateTime.now()});
        await due.reference.delete();
      }

      await _firestore.collection('Merchant').doc(doc.id).delete();
      await calculateTotals();
      await fetchRecycleMerchants();

      merchants.removeWhere((merchant) => merchant.merchantName == name);
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }

  Future<void> fetchRecycleMerchants() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var snapshot = await _firestore.collection('recyclebin').get();

      recyclemerchant.value = snapshot.docs
          .map((doc) => MerchantModel.formmap(doc.data()))
          .toList();
      loading.dismissloading();
    } catch (e) {
      print('Error fetching recycle merchants: $e');
      loading.dismissloading();
    }
  }

  Future<void> fetchrecyclemerchantdues(String name) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var docsnapshot = await _firestore
          .collection('recyclebin')
          .where('merchantName', isEqualTo: name)
          .get();

      final doc = docsnapshot.docs.first;

      var duesnapshot = await _firestore
          .collection('recyclebin')
          .doc(doc.id)
          .collection('due')
          .orderBy('date', descending: true)
          .get();

      recyclemerchntdue.value = duesnapshot.docs
          .map((due) => MerchantDuesModel.formmap(due.data()))
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
          .collection('recyclebin')
          .where('merchantName', isEqualTo: name)
          .get();

      final doc = recyclequerysnapshot.docs.first;

      var recycleduesnapshot = await _firestore
          .collection('recyclebin')
          .doc(doc.id)
          .collection('due')
          .get();

      MerchantModel merchantModel = MerchantModel(
        merchantUid: uid,
        merchantName: name,
        merchantEmail: email,
        merchantAddress: address,
        merchantPhone: phone,
        date: date,
        merchantAmount: amount,
      );

      await _firestore.collection('Merchant').doc(doc.id).set({
        ...merchantModel.tomap(),
      });

      for (var due in recycleduesnapshot.docs) {
        await _firestore
            .collection('Merchant')
            .doc(doc.id)
            .collection('due')
            .doc(due.id)
            .set({...due.data()});

        await due.reference.delete();
        await calculateTotals();
      }

      await _firestore.collection('recyclebin').doc(doc.id).delete();

      recyclemerchant.removeWhere((merchant) => merchant.merchantName == name);
      await fetchRecycleMerchants();
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
          .collection('recyclebin')
          .where('merchantName', isEqualTo: name)
          .get();

      final doc = querysnapshot.docs.first;
      await _firestore.collection('recyclebin').doc(doc.id).delete();

      recyclemerchant.removeWhere((merchant) => merchant.merchantName == name);
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }
}
