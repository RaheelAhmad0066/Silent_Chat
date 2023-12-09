import 'dart:developer';

import 'package:flutter/material.dart';
import '../../main.dart';
import '../api/apis.dart';
import 'Onbording_page.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';
import 'package:lottie/lottie.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      // //exit full-screen
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     systemNavigationBarColor: Colors.white,
      //     statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Onboarding()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: SingleChildScrollView(
        child: Column(children: [
          //app logo
          SizedBox(
            height: mq.height * 0.3,
          ),
          Center(
              child: Image.asset(
            'images/icon.png',
            width: mq.width * 0.8,
          )),
          SizedBox(
            height: mq.height * 0.2,
          ),
          LottieBuilder.asset(
            'images/loader.json',
            width: mq.height * 0.08,
          )
        ]),
      ),
    );
  }
}
