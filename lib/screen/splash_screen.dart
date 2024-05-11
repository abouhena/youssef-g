
import 'dart:async';

import 'package:tourism_app/screen/layout_screen.dart';
import 'package:tourism_app/screen/login_screen.dart';
import 'package:tourism_app/services/shared_pref_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key,);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }


  @override
  void initState() {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    requestPermission();
    loadFCM();
    listenFCM();

    Timer(const Duration(seconds: 3),
            () async{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return (SharedPref.getDate(key: 'kLogin')??false) ? LayoutScreen() : LoginScreen();
              }));
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Image.asset(
                'assets/image/logo.jpg',
                height: 72,
                width: 72,
                fit:  BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}


