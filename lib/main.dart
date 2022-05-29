import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:mistriandlabours/Authpages/splash_screen.dart';
import 'package:mistriandlabours/Mainpages/Labour/home_page.dart';
import 'package:mistriandlabours/Mainpages/User/home_page_user.dart';
import 'package:mistriandlabours/Mainpages/User/job_post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#5c0931');
  Color _accentColor = HexColor('#5c0931');
  Color _textColor = HexColor('#747F8A');

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'labour and maistri',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Button color
              onPrimary: Colors.white, // Text color
            ),
          ),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: _textColor),
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: Colors.grey,
        ),
        home: SplashScreen(
          title: "",
        ));
  }
}
