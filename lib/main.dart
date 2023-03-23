import 'package:final_project_flutter/screens/SignIn.dart';
import 'package:final_project_flutter/screens/SignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
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

  print('User granted permission: ${settings.authorizationStatus}');
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.subscribeToTopic("pushNotifications");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token = await _firebaseMessaging.getToken();
  print("FirebaseMessaging token: $token");

  var message = "No message.";

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('mipmap/ic_launcher');

  var initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
    print("onDidReceiveLocalNotification called.");
  });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
    // when user tap on notification.
    print("onSelectNotification called.");
    // setState(() {
    //   message = payload;
    // });
  });
  sendNotification(title, body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '10000', 'FLUTTER_NOTIFICATION_CHANNEL',
        channelDescription: "Your description",
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, title, body, platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    sendNotification(message.notification?.title, message.notification?.body);
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print(message.notification?.title);
    print(message.notification?.body);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // print("init")
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
      //debugShowCheckedModeBanner: false
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("Welcome to electrical system",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Color(0xff7364FF))),
          ),
          const Center(
              child: Image(
            image: AssetImage("assets/images/bg.png"),
          )),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Color(0xff7364FF),
            ),
            child: const Text(
              'ลงชื่อเข้าใช้',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SignIn();
              }));
            },
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Color(0xff7364FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                )),
            child: const Text(
              'สมัครสมาชิก',
              style: TextStyle(fontSize: 20.0, color: Color(0xff7364FF)),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignUp();
              }));
            },
          ),
        ],
      )),
    );
  }
}
