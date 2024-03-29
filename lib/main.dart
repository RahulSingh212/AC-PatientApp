// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:auriga_patient/providers/patientTransaction_details.dart';
import 'package:auriga_patient/providers/pushNotification_details.dart';
import 'package:auriga_patient/screens/AppointsAndTests_Screens/AppointmentsNTests_Screen.dart';
import 'package:auriga_patient/screens/FindDoctors_Screens/DoctorDetails_Screen.dart';
import 'package:auriga_patient/screens/FindDoctors_Screens/FindDoctorScreen.dart';
import 'package:auriga_patient/screens/ForthTab_Screen.dart';
import 'package:auriga_patient/screens/HealthNFitness_Screens/HealthAndFitness_screen.dart';
import 'package:auriga_patient/screens/Home_Screens/Home_Screen.dart';
import 'package:auriga_patient/screens/MyProfile_Screen.dart';
import 'package:auriga_patient/screens/MySettings_Screen.dart';
import 'package:auriga_patient/screens/Tabs_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter/services.dart";

import './providers/patientAuth_details.dart';
import './providers/patientUser_details.dart';
import './providers/patientAvailableDoctor_details.dart';
import './providers/doctorCalendar_details.dart';
import './providers/appointmentUpdation_details.dart';
import './providers/bookedAppointmentsAndTests_details.dart';
import './providers/patientChatMessage_details.dart';
import './providers/patientHomeScreen_details.dart';
import './providers/paientHealthAndWellNess_details.dart';

import './screens/SignUp_Screens/SelectLanguage_Screen.dart';
import './screens/SignUp_Screens/SelectSignInSignUp.dart';
import './screens/SignUp_Screens/EnterPersonalDetailsScreen.dart';
import './screens/SignUp_Screens/EnterPhoneNumber_Screen.dart';
import './screens/SignUp_Screens/EnterPhoneOtp_Screen.dart';
import './providers/firebaseLinks_details.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  late UserCredential userCred;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PatientFirebaseDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientAuthDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientUserDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientAvailableDoctorDetails(),
        ),
        ChangeNotifierProvider.value(
          value: DoctorCalendarDetails(),
        ),
        ChangeNotifierProvider.value(
          value: AppointmentUpdationDetails(),
        ),
        ChangeNotifierProvider.value(
          value: BookedAppointmentsAndTestDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientChatMessageDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientHomeScreenrDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientTransactionDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PatientHealthAndWellNessDetails(),
        ),
        ChangeNotifierProvider.value(
          value: PushNotificationDetails(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Patient Application",

        theme: ThemeData(
          primaryColor: const Color(0xFFfbfcff),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          canvasColor: Color.fromRGBO(255, 254, 229, 0.9),
          hoverColor: Colors.transparent,
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
              ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Color.fromARGB(255, 84, 83, 77),
          ),
        ),
        home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return TabsScreenPatient();
              // return SelectSignInSignUpScreenPatient();
              // return SelectLanguageScreenPatient();
            }
            else {
              // return SelectSignInSignUpScreenPatient();
              return SelectLanguageScreenPatient();
            }
          },
        ),
        // home: SelectLanguage_Screen(),
        // initialRoute: ,
        routes: {
          SelectLanguageScreenPatient.routeName: (ctx) => SelectLanguageScreenPatient(),
          SelectSignInSignUpScreenPatient.routeName: (ctx) => SelectSignInSignUpScreenPatient(),
          EnterUserPersonalDetailsScreen.routeName: (ctx) => EnterUserPersonalDetailsScreen(),
          EnterPhoneNumberScreen.routeName: (ctx) => EnterPhoneNumberScreen(),
          EnterPhoneOtpScreen.routeName: (ctx) => EnterPhoneOtpScreen(),

          TabsScreenPatient.routeName: (ctx) => TabsScreenPatient(),

          HomeScreenPatient.routeName: (ctx) => HomeScreenPatient(),
          AppointmentsAndTestsScreenPatient.routeName: (ctx) => AppointmentsAndTestsScreenPatient(),
          FindDoctorScreenPatient.routeName: (ctx) => FindDoctorScreenPatient(),
          FourthTabScreenPatient.routeName: (ctx) => FourthTabScreenPatient(),
          HealthAndFitnessScreenPatient.routeName: (ctx) => HealthAndFitnessScreenPatient(),

          MyProfileScreen.routeName: (ctx) => MyProfileScreen(),
          MySettingsScreen.routeName: (ctx) => MySettingsScreen(),
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   //Henansh Commits
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: const LoadingPage(),
//       // home: const LangPage(),
//       // home: const Find_doctor(),
//       // home: const ProfilePage(),

//       // home: RoutedBasedAuth(),
//       home: LoginPage(),

//       // home: const LoginPage2(),
//       // home: const LoginPage3(),
//       // home: const SettingPage(),
//       // home: const MessagePage(),
//       //   home: AboutDoctor(),
//       // home: const DoctorSlot(),
//       // home: const BookTest(),
//       // home: CallDialog(),


//     );


//   }
// }
