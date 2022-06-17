import 'package:assignment/ChatMainScreen.dart';
import 'package:assignment/ChatScreen.dart';
import 'package:assignment/GroupName.dart';
import 'package:assignment/NewGroup.dart';
import 'package:assignment/Provider.dart';
import 'package:assignment/Search.dart';
import 'package:assignment/mainOtions.dart';
import 'package:assignment/test.dart';
import 'package:assignment/userInfoEdit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => provider1(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: FirebaseAuth.instance.currentUser==null?MainSignupLogin(): ChatMainScreen(),
        ),
        routes: {
          "ChatMainScreen":(ctx)=>ChatMainScreen(),
          "search": (ctx) => const Search(),
          "chatscreen":(ctx)=>ChatScreen(),
          "test":(ctx)=>const test(),
          "useredit":(ctx)=>UserInfoEdit(),
          "signup":(ctx)=>MainSignupLogin(),
          "NewGroup":(ctx)=>NewGroup(),
          "GroupName":(ctx)=>GroupName(),
          "userInfo":(ctx)=>UserInfoEdit()

          });
  }
}
