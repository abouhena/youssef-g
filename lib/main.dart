import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/firebase_options.dart';
import 'package:tourism_app/screen/splash_screen.dart';
import 'package:tourism_app/services/shared_pref_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider (create: (BuildContext context) => AppCubit()),
        ],
        child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tourism App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

