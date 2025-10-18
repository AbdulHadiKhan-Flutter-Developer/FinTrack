import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:udhar/controllers/auth_controller.dart';
import 'package:udhar/controllers/loading_controller.dart';
import 'package:udhar/firebase_options.dart';
import 'package:udhar/screen/auth/signin_screen.dart';
import 'package:udhar/widgets/loading_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(LoadingController());

  await Supabase.initialize(
    url: 'https://qwgyiflqjitcvxlouqoy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3Z3lpZmxxaml0Y3Z4bG91cW95Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3NjE0MjksImV4cCI6MjA3MzMzNzQyOX0._spQiRLG7aoDzQJcKFy1G_LkiYFEL3Zu6t5-ABWf-Tk',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Udhar App',
        builder: (context, child) {
          return Stack(children: [child!, const LoadingWidget()]);
        },
        home: SigninScreen(),
      ),
    );
  }
}
