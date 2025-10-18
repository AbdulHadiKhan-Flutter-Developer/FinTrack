// ignore_for_file: body_might_complete_normally_nullable, avoid_print, avoid_returning_null_for_void

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:udhar/controllers/loading_controller.dart';

import 'package:udhar/models/user_model.dart';
import 'package:udhar/screen/auth/signin_screen.dart';
import 'package:udhar/screen/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String usershopname = '';

  Rx<User?> firebaseuser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    firebaseuser.bindStream(_auth.authStateChanges());
    ever(firebaseuser, initialscreen);
  }

  void initialscreen(User? user) {
    if (user == null) {
      Get.to(SigninScreen());
    } else if (user.emailVerified) {
      Get.to(HomeScreen());
    } else {
      user.sendEmailVerification();
      Get.snackbar('Warning', 'Please verify your email before signin');

      _auth.signOut();
      Get.to(() => SigninScreen());
    }
  }

  Future<UserCredential?> sigupmethod(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      final response = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        UserModel userModel = UserModel(
          userUid: response.user!.uid,
          userShopName: name,
          userEmail: email,
          userPhone: phone,
        );
        await _firebaseFirestore
            .collection('user')
            .doc(response.user!.uid)
            .set(userModel.tomap());

        await response.user!.sendEmailVerification();

        Get.snackbar(
          'Verification E-Mail Sent Successfully!',
          'Please verify your email before signin.',
        );

        await _auth.signOut();
        Get.to(
          SigninScreen(),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 500),
        );
      }
      loading.dismissloading();
      return response;
    } on FirebaseAuthException catch (e) {
      print('Error:$e');
      loading.dismissloading();
      return null;
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
      return null;
    }
  }

  Future<UserCredential?> signinmthod(String email, String password) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      final response = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user != null && response.user!.emailVerified) {
        Get.to(
          HomeScreen(),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 500),
        );
      } else {
        Get.snackbar('Warning', 'Please verify your email before signin');
      }
      loading.dismissloading();
      return response;
    } on FirebaseAuthException catch (e) {
      print('Error:$e');
      loading.dismissloading();
      return null;
    } catch (e) {
      print('Error: $e');
      loading.dismissloading();
      return null;
    }
  }

  Future<void> forgotmethod(String email) async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      final response = await _auth.sendPasswordResetEmail(email: email);
      if (email.isNotEmpty) {
        Get.snackbar(
          'Reset E-Mail Sent Successfully',
          'Please check your mailbox or spamox',
        );
        Get.to(
          SigninScreen(),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 500),
        );
      }
      loading.dismissloading();
      return response;
    } on FirebaseAuthException catch (e) {
      print('Error:$e');
      loading.dismissloading();
      return null;
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
      return null;
    }
  }

  Future<void> fetchuserdata() async {
    final loading = Get.find<LoadingController>();

    try {
      loading.showloading();
      var querysnapshot = await _firebaseFirestore
          .collection('user')
          .where('userUid', isEqualTo: uid)
          .get();

      final doc = querysnapshot.docs.first;
      usershopname = doc['userShopName'];
      loading.dismissloading();
    } catch (e) {
      print('Error:$e');
      loading.dismissloading();
    }
  }
}
