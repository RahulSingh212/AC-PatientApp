// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, unused_import, unused_local_variable

import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:auriga_patient/screens/SignUp_Screens/SelectLanguage_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patientAuth_details.dart';
import '../providers/patientUser_details.dart';

import './Tabs_Screen.dart';
import './MyProfile_Screen.dart';
import 'Setting_Screens/CustomerCare_Screen.dart';
import 'Setting_Screens/ManageAccount_Screen.dart';
import 'Setting_Screens/PrivacyPolicy_Screen.dart';
import 'Setting_Screens/ShareApp_Screen.dart';
import 'SignUp_Screens/SelectSignInSignUp.dart';

class MySettingsScreen extends StatefulWidget {
  static const routeName = '/patient-my-settings-screen';

  @override
  State<MySettingsScreen> createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  bool isLangEnglish = true;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    isLangEnglish = Provider.of<PatientUserDetails>(context, listen: false)
        .isReadingLangEnglish;
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    double height = (MediaQuery.of(context).size.height);

    return Scaffold(
      // backgroundColor: const Color(0xFFf2f3f4),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        leading: IconButton(
          enableFeedback: false,
          onPressed: () {
            // Navigator.of(context).pushReplacementNamed(MyProfileScreen.routeName);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MyProfileScreen.routeName, (route) => false);
          },
          icon: const Icon(
            Icons.arrow_circle_left,
            color: Color(0xff42ccc3),
            size: 35,
          ),
        ),
        title: Text(
          isLangEnglish ? "Settings" : "सेटिंग्स",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: height * 0.05,
          ),
          RowTabWidgetForPrivacyPolicy(
            context,
            Icons.shield_rounded,
            isLangEnglish ? "Privacy Policy" : "गोपनीयता नीति",
          ),
          RowTabWidgetForSharingApplication(
            context,
            Icons.person_add_rounded,
            isLangEnglish ? "Share App" : "ऐप शेयर करें",
          ),
          RowTabWidgetForCustomerCare(
            context,
            Icons.help_center_rounded,
            isLangEnglish ? "Customer Care" : "ग्राहक देखभाल",
          ),
          RowTabWidgetForManageAccount(
            context,
            Icons.person_rounded,
            isLangEnglish ? "Manage Account" : "खाते का प्रबंधन करें",
          ),
          RowTabWidgetForChangingLanguage(
            context,
            Icons.language_rounded,
            isLangEnglish ? "Change Language" : "भाषा बदलें",
          ),
          SizedBox(
            height: height * 0.35,
          ),
          // Container(
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.check_circle_rounded,
          //       color: Color(0xff42ccc3),
          //     ),
          //     iconSize: 50,
          //     color: Colors.brown,
          //     onPressed: () {
          //       String titleText = isLangEnglish ? "Logout!" : "लॉग आउट";
          //       String contextText = isLangEnglish
          //           ? "Are you sure you want to Log-Out?"
          //           : "क्या आप लॉग आउट करना चाहते हैं?";
          //       _checkForLogout(context, titleText, contextText);
          //     },
          //   ),
          // ),
          InkWell(
            onTap: () {
              String titleText = isLangEnglish ? "Logout!" : "लॉग आउट";
              String contextText = isLangEnglish
                  ? "Are you sure you want to Log-Out?"
                  : "क्या आप लॉग आउट करना चाहते हैं?";
              _checkForLogout(context, titleText, contextText);

              // _auth.signOut();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     SelectSignInSignUpScreenPatient.routeName, (route) => false);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                height: height * 0.08,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: const Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                    left: BorderSide(width: 1.0, color: Colors.grey),
                    right: BorderSide(width: 1.0, color: Colors.grey),
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget RowTabWidget(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {},
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RowTabWidgetForPrivacyPolicy(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PatientPrivacyPolicyScreen(
                  3,
                ),
              ),
            );
          },
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RowTabWidgetForSharingApplication(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PatientShareApplicationScreen(
                  3,
                ),
              ),
            );
          },
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RowTabWidgetForCustomerCare(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PatientCustomerCareScreen(
                  3,
                ),
              ),
            );
          },
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RowTabWidgetForManageAccount(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PatientManageAccountScreen(
                  3,
                ),
              ),
            );
          },
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RowTabWidgetForChangingLanguage(
    BuildContext context,
    IconData iconVal,
    String rowText,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0025,
        horizontal: screenWidth * 0.05,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: () {
            String titleText =
                isLangEnglish ? "Available Languages" : "उपलब्ध भाषाएं";
            String contextText = isLangEnglish
                ? "Select your Language"
                : "अपनी भाषा का चयन करें";
            _seclectReadingLanguageType(context, titleText, contextText);
          },
          child: Container(
            height: screenHeight * 0.065,
            width: screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.01,
              vertical: screenHeight * 0.001,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.0025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    iconVal,
                    color: Color.fromRGBO(66, 204, 195, 1),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                Container(
                  child: Text(
                    rowText,
                    style: TextStyle(
                      color: Color(0xff42ccc3),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _seclectReadingLanguageType(
    BuildContext context,
    String titleText,
    String contextText,
  ) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    String str1 = isLangEnglish ? "Set Language to English" : "भाषा को अंग्रेजी में सेट करें";
    String str2 = isLangEnglish ? "Set Language to Hindi" : "भाषा को हिंदी में सेट करें";

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              // For Setting Language to English
              if (isLangEnglish) {
                Navigator.pop(ctx);
                String titleText =
                    isLangEnglish ? "In-valid Request" : "अमान्य अनुरोध";
                String contextText = isLangEnglish
                    ? "Langauge is already set in english"
                    : "भाषा पहले से ही अंग्रेज़ी में सेट है";
                _checkForError(context, titleText, contextText);
              } else {
                Navigator.pop(ctx);
                Provider.of<PatientUserDetails>(context, listen: false)
                    .updatePatientUserPersonalInformation(
                  context,
                  'patient_LanguageType',
                  'true',
                );

                setState(() {
                  Provider.of<PatientUserDetails>(context, listen: false)
                      .isReadingLangEnglish = true;
                  isLangEnglish = true;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isLangEnglish ? Colors.green : Color.fromRGBO(220, 229, 228, 1),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.015,
                vertical: screenWidth * 0.025,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
                vertical: screenWidth * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.language_outlined,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      isLangEnglish ? str1+"(C*)" : str1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.005,
          ),
          InkWell(
            onTap: () async {
              // For Setting Language to Hindi
              if (!isLangEnglish) {
                Navigator.pop(ctx);
                String titleText =
                    isLangEnglish ? "In-valid Request" : "अमान्य अनुरोध";
                String contextText = isLangEnglish
                    ? "Langauge is already set in hindi"
                    : "भाषा पहले से ही हिन्दी में सेट है";
                _checkForError(context, titleText, contextText);
              } else {
                Navigator.pop(ctx);
                Provider.of<PatientUserDetails>(context, listen: false)
                    .updatePatientUserPersonalInformation(
                  context,
                  'patient_LanguageType',
                  'false',
                );
                setState(() {
                  Provider.of<PatientUserDetails>(context, listen: false)
                      .isReadingLangEnglish = false;
                  isLangEnglish = false;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: !isLangEnglish ? Colors.green : Color.fromRGBO(220, 229, 228, 1),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.015,
                vertical: screenWidth * 0.025,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
                vertical: screenWidth * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.language_outlined,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      !isLangEnglish ? str2+"(सी*)" : str2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkForLogout(
      BuildContext context, String titleText, String contextText,
      {bool popVal = false}) async {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.dangerous_rounded,
              color: Color(0xff42ccc3),
            ),
            iconSize: 50,
            tooltip: isLangEnglish ? 'No' : "नहीं",
            color: Colors.brown,
            onPressed: () {
              setState(() {
                if (popVal == false) {
                  Navigator.pop(ctx);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.check_circle_rounded,
              color: Color(0xff42ccc3),
            ),
            iconSize: 50,
            tooltip: isLangEnglish ? 'Yes' : "हाँ",
            color: Colors.brown,
            onPressed: () {
              setState(() {
                if (popVal == false) {
                  Navigator.pop(ctx);
                  _auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SelectLanguageScreenPatient.routeName, (route) => false);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkForError(
      BuildContext context, String titleText, String contextText,
      {bool popVal = false}) async {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${titleText}'),
        content: Text('${contextText}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check_circle_rounded,
              color: Color(0xff42ccc3),
            ),
            iconSize: 50,
            color: Colors.brown,
            onPressed: () {
              setState(() {
                if (popVal == false) {
                  Navigator.pop(ctx);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
