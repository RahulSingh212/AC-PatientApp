// ignore_for_file: use_build_context_synchronously, unnecessary_this, unused_local_variable, non_constant_identifier_names, await_only_futures, unnecessary_brace_in_string_interps, duplicate_import, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:auriga_patient/screens/Tabs_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/token_info.dart';
import 'firebaseLinks_details.dart';

class PatientUserDetails with ChangeNotifier {
  bool isReadingLangEnglish = true;
  Map<String, String> mp = {};
  String loggedInPatientUserUniqueCred = "";
  bool patient_LanguageType = true; // English: true, Hindi: false
  String mobileMessagingToken = "";
  String messagingTokenName = "aurigaCare";

  setPatientLanguageType(bool isEnglish) {
    this.patient_LanguageType = isEnglish;
  }

  bool getPatientLanguageType() {
    return this.patient_LanguageType;
  }

  setPatientUserPersonalInformation(Map<String, String> patientMap) {
    this.mp = patientMap;
  }

  Map<String, String> getPatientUserPersonalInformation() {
    return mp;
  }

  String getLoggedInUserUniqueId() {
    return this.loggedInPatientUserUniqueCred;
  }

  late TextEditingController patientFullName;
  late TextEditingController patientFirstName;
  late TextEditingController patientLastName;
  late TextEditingController patientGenderType;
  late TextEditingController patientMobileNumber;
  late TextEditingController patientRegisteredCity;
  late TextEditingController patientRegisteredCityPinCode;
  late TextEditingController patientRegistrationDetails;

  late TextEditingController patientProfilePicUrl;
  late TextEditingController patientProfileCreationTime;

  ///////////////////////////////////////////////////
  setPatientFullName(TextEditingController fullName) {
    this.patientFullName = fullName;
  }

  TextEditingController getPatientFullName() {
    return this.patientFullName;
  }

  ///////////////////////////////////////////////////
  setPatientFirstName(TextEditingController firstName) {
    this.patientFirstName = firstName;
  }

  TextEditingController getPatientFirstName() {
    return this.patientFirstName;
  }

  ///////////////////////////////////////////////////
  setPatientLastName(TextEditingController lastName) {
    this.patientLastName = lastName;
  }

  TextEditingController getPatientLastName() {
    return this.patientLastName;
  }

  ///////////////////////////////////////////////////
  setPatientGenderType(TextEditingController genderType) {
    this.patientGenderType = genderType;
  }

  TextEditingController getPatientGenderType() {
    return this.patientGenderType;
  }

  ///////////////////////////////////////////////////
  setPatientRegisteredCity(TextEditingController registeredCity) {
    this.patientRegisteredCity = registeredCity;
  }

  TextEditingController getPatientRegisteredCity() {
    return this.patientRegisteredCity;
  }

  ///////////////////////////////////////////////////
  setPatientRegisteredCityPincode(TextEditingController registeredCityPinCode) {
    this.patientRegisteredCityPinCode = registeredCityPinCode;
  }

  TextEditingController getPatientRegisteredCityPincode() {
    return this.patientRegisteredCityPinCode;
  }

  ///////////////////////////////////////////////////
  setPatientRegistrationDetails(TextEditingController registrationDetails) {
    this.patientRegistrationDetails = registrationDetails;
  }

  TextEditingController getPatientRegistrationDetails() {
    return this.patientRegistrationDetails;
  }

  ///////////////////////////////////////////////////
  setPatientMobileNumber(TextEditingController mobileNumber) {
    this.patientMobileNumber = mobileNumber;
  }

  TextEditingController getPatientMobileNumber() {
    return this.patientMobileNumber;
  }

  ///////////////////////////////////////////////////
  setPatientProfilePicUrl(TextEditingController doctorProfilePicUrl) {
    this.patientProfilePicUrl = doctorProfilePicUrl;
  }

  TextEditingController getPatientProfilePicUrl() {
    return this.patientProfilePicUrl;
  }

  ///////////////////////////////////////////////////
  setPatientProfileCreationTime(
      TextEditingController doctorProfileCreationTime) {
    this.patientProfileCreationTime = doctorProfileCreationTime;
  }

  TextEditingController getPatientProfileCreationTime() {
    return this.patientProfileCreationTime;
  }

  Future<void> clearStateOfLoggedInUser(BuildContext context) async {
    this.patient_LanguageType = true;

    this.patientFullName = TextEditingController();
    this.patientFirstName = TextEditingController();
    this.patientLastName = TextEditingController();
    this.patientGenderType = TextEditingController();
    this.patientMobileNumber = TextEditingController();
    this.patientRegisteredCity = TextEditingController();
    this.patientRegisteredCityPinCode = TextEditingController();
    this.patientRegistrationDetails = TextEditingController();

    this.patientProfilePicUrl = TextEditingController();
    this.patientProfileCreationTime = TextEditingController();

    this.mp = {};
  }

  Future<void> upLoadNewPatientPersonalInformation(
    BuildContext context,
    UserCredential authCredential,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("PatientsUserPhoneNumberList");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    Uri urlLinkForPhoneNumbers = Provider.of<PatientFirebaseDetails>(context, listen: false).getFirebasePathUrl('/PatientsUserPhoneNumberList.json');

    final responseForAddingNewDoctorUser = await http.post(
      urlLinkForPhoneNumbers,
      body: json.encode(
        {
          'patient_personalUniqueIdentificationId': loggedInUserId.toString(),
          'patient_PhoneNumber': this.patientMobileNumber.text.toString(),
        },
      ),
    );

    try {
      final submissionResponse = await FirebaseFirestore.instance
          .collection('PatientUsersPersonalInformation')
          .doc(authCredential.user?.uid)
          .set(
        {
          'patient_LanguageType': isReadingLangEnglish ? "true" : "false",
          'patient_uniqueDatabaseId': DateTime.now().toString(),
          'patient_personalUniqueIdentificationId': loggedInUserId.toString(),
          'patient_FullName': this.patientFullName.text.toString(),
          'patient_FirstName': "",
          'patient_LastName': "",
          'patient_Gender': "",
          'patient_MobileMessagingTokenId': mobileMessagingToken.toString(),
          'patient_PhoneNumber': this.patientMobileNumber.text.toString(),
          'patient_EmailId': "",
          'patient_Age': "",
          'patient_Weight': "",
          'patient_Height': "",
          'patient_BloodGroup': "",
          'patient_Medication': "",
          'patient_Injuries': "",
          'patient_Surgeries': "",
          'patient_Allergies': "",
          'patient_CurrentCity': "",
          'patient_CurrentCityPinCode': "",
          'patient_RegistrationDetails': "",
          'patient_ProfilePicUrl': "",
          'patient_ProfileCreationTime': DateTime.now().toString(),
          'patient_ProfilePermission': 'true',
          'patient_SwasthyaMitraCenter_personalUniqueIdentificationId': '',
        },
      );

      // Navigator.of(context).pushReplacementNamed(TabsScreenPatient.routeName);
      // Navigator.of(context).pop(false);
      setPatientUserInfo(context);
    } catch (errorVal) {
      print(errorVal);
    }
  }

  Future<void> setPatientUserInfo(BuildContext context) async {
    // FirebaseFirestore db = FirebaseFirestore.instance;
    // CollectionReference usersRef = db.collection("userPersonalInformation");

    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;

    if (mp.isEmpty) {
      var currLoggedInUser = await FirebaseAuth.instance.currentUser;
      var loggedInUserId = currLoggedInUser?.uid as String;

      this.loggedInPatientUserUniqueCred = loggedInUserId;

      var response = await FirebaseFirestore.instance
          .collection('PatientUsersPersonalInformation')
          .doc(loggedInUserId)
          .get()
          .then(
        (DocumentSnapshot ds) {
          String patient_LanguageType = "";
          String patient_uniqueDatabaseId = "";
          String patient_personalUniqueIdentificationId = "";
          String patient_ProfilePermission = "";

          String patient_FullName = "";
          String patient_FirstName = "";
          String patient_LastName = "";
          String patient_Gender = "";
          String patient_PhoneNumber = "";
          String patient_EmailId = "";

          String patient_Age = "0";
          String patient_Weight = "0";
          String patient_Height = "0";
          String patient_BloodGroup = "";
          String patient_Medication = "";
          String patient_Injuries = "";
          String patient_Surgeries = "";
          String patient_Allergies = "";

          String patient_CurrentCity = "";
          String patient_CurrentCityPinCode = "";
          String patient_RegistrationDetails = "";

          String patient_ProfilePicUrl = "";
          String patient_ProfileCreationTime = "";
          String patient_SwasthyaMitraCenter_personalUniqueIdentificationId = "";

          patient_LanguageType = ds.get('patient_LanguageType').toString();
          patient_uniqueDatabaseId = ds.get('patient_uniqueDatabaseId').toString();
          patient_personalUniqueIdentificationId = ds.get('patient_personalUniqueIdentificationId').toString();

          patient_FullName = ds.get('patient_FullName').toString();
          patient_FirstName = ds.get('patient_FirstName').toString();
          patient_LastName = ds.get('patient_LastName').toString();
          patient_Gender = ds.get('patient_Gender').toString();
          patient_PhoneNumber = ds.get('patient_PhoneNumber').toString();
          patient_EmailId = ds.get('patient_EmailId').toString();

          patient_Age = ds.get('patient_Age').toString();
          patient_Weight = ds.get('patient_Weight').toString();
          patient_Height = ds.get('patient_Height').toString();
          patient_BloodGroup = ds.get('patient_BloodGroup').toString();
          patient_Medication = ds.get('patient_Medication').toString();
          patient_Injuries = ds.get('patient_Injuries').toString();
          patient_Surgeries = ds.get('patient_Surgeries').toString();
          patient_Allergies = ds.get('patient_Allergies').toString();

          patient_CurrentCity = ds.get('patient_CurrentCity').toString();
          patient_CurrentCityPinCode = ds.get('patient_CurrentCityPinCode').toString();
          patient_RegistrationDetails = ds.get('patient_RegistrationDetails').toString();

          patient_ProfilePicUrl = ds.get('patient_ProfilePicUrl').toString();
          patient_ProfileCreationTime = ds.get('patient_ProfileCreationTime').toString();
          patient_ProfilePermission = ds.get('patient_ProfilePermission').toString();
          patient_SwasthyaMitraCenter_personalUniqueIdentificationId = ds.get('patient_SwasthyaMitraCenter_personalUniqueIdentificationId').toString();


          if (patient_LanguageType == 'true') {
            isReadingLangEnglish = true;
          }
          else {
            isReadingLangEnglish = false;
          }

          mp["patient_uniqueDatabaseId"] = patient_uniqueDatabaseId;
          mp["patient_personalUniqueIdentificationId"] = patient_personalUniqueIdentificationId;
          mp['patient_ProfilePermission'] = patient_ProfilePermission;

          mp["patient_FullName"] = patient_FullName;
          mp["patient_FirstName"] = patient_FirstName;
          mp["patient_LastName"] = patient_LastName;
          mp["patient_Gender"] = patient_Gender;
          mp["patient_PhoneNumber"] = patient_PhoneNumber;
          mp["patient_EmailId"] = patient_EmailId;

          mp["patient_Age"] = patient_Age;
          mp["patient_Weight"] = patient_Weight;
          mp["patient_Height"] = patient_Height;
          mp["patient_BloodGroup"] = patient_BloodGroup;
          mp["patient_Medication"] = patient_Medication;
          mp["patient_Injuries"] = patient_Injuries;
          mp["patient_Surgeries"] = patient_Surgeries;
          mp["patient_Allergies"] = patient_Allergies;

          mp["patient_CurrentCity"] = patient_CurrentCity;
          mp["patient_CurrentCityPinCode"] = patient_CurrentCityPinCode;
          mp["patient_RegistrationDetails"] = patient_RegistrationDetails;

          mp["patient_ProfilePicUrl"] = patient_ProfilePicUrl;
          mp["patient_ProfileCreationTime"] = patient_ProfileCreationTime;
          mp["patient_SwasthyaMitraCenter_personalUniqueIdentificationId"] = patient_SwasthyaMitraCenter_personalUniqueIdentificationId;
        },
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
          TabsScreenPatient.routeName, (route) => false);
      notifyListeners();
    }
  }

  Future<void> updatePatientUserPersonalInformation(
    BuildContext context,
    String labelText,
    String updatedText,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("PatientUsersPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    db
        .collection("PatientUsersPersonalInformation")
        .doc(loggedInUserId)
        .update({labelText: updatedText}).then((value) {
      mp[labelText] = updatedText;
    });

    // Navigator.of(context).pushNamedAndRemoveUntil(TabsScreenPatient.routeName, (route) => false);
    notifyListeners();
  }

  Future<void> updatePatientProfilePicture(
    BuildContext context,
    File profilePicFile,
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef = db.collection("PatientUsersPersonalInformation");

    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    Uri urlLinkForProfilePic = Provider.of<PatientFirebaseDetails>(context, listen: false).getFirebasePathUrl('/PatientStorageDetails/$loggedInUserId/PatientProfilePicture.json');


    String imageName = "${loggedInUserId}_profilePic.jpg";
    final profilePicture = FirebaseStorage.instance
        .ref()
        .child('PatientStorageDetails/$loggedInUserId/PatientProfilePicture')
        .child(imageName);

    try {
      if (mp['patient_ProfilePicUrl'] == '') {
        final imageUploadResponse =
            await profilePicture.putFile(profilePicFile);
        mp['patient_ProfilePicUrl'] = await profilePicture.getDownloadURL();
        db
            .collection("PatientUsersPersonalInformation")
            .doc(loggedInUserId)
            .update({"patient_ProfilePicUrl": mp['patient_ProfilePicUrl']});
      } else {
        final existingImageRef = FirebaseStorage.instance.ref();
        final deletingFileResponse = await existingImageRef
            .child(
                'PatientStorageDetails/$loggedInUserId/PatientProfilePicture/${loggedInUserId}_profilePic.jpg')
            .delete();

        final imageUploadResponse =
            await profilePicture.putFile(profilePicFile);
        mp['patient_ProfilePicUrl'] = await profilePicture.getDownloadURL();
        db
            .collection("PatientUsersPersonalInformation")
            .doc(loggedInUserId)
            .update({"patient_ProfilePicUrl": mp['patient_ProfilePicUrl']});

        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     TabsScreenPatient.routeName, (route) => false);
        notifyListeners();
      }
    } catch (errorVal) {
      print(errorVal);
    }
  }

  // Future<void> updatePatientPrescription(
  //   BuildContext context,
  //   BookedTokenSlotInformation tokenInfo,
  //   File documentPdfFile,
  // ) async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   CollectionReference usersRef =
  //       db.collection("PatientUsersPersonalInformation");

  //   var currLoggedInUser = await FirebaseAuth.instance.currentUser;
  //   var loggedInUserId = currLoggedInUser?.uid as String;

  //   String aptDate = "${tokenInfo.bookedTokenDate.day}-${tokenInfo.bookedTokenDate.month}-${tokenInfo.bookedTokenDate.year}";
  //   String aptTime = tokenInfo.bookedTokenTime.toString();
  //   String refLink = "PatientReportsAndPrescriptionsDetails/${loggedInUserId}/${tokenInfo.doctor_personalUniqueIdentificationId}/${tokenInfo.doctor_AppointmentUniqueId}/${aptDate}/${aptTime}/PatientPreviousPrescription";

  //   Future<ListResult> futureFiles = FirebaseStorage.instance.ref('/${refLink}').listAll();

  //   DateTime cT = DateTime.now();
  //   String pth =
  //       "${cT.day}-${cT.month}-${cT.year}-${cT.hour}-${cT.minute}-${cT.second}";
  //   if (futureFiles.toString() == null) {
  //     try {
  //       String documentFileName =
  //           "myPrescription.pdf";
  //       final documentFile = FirebaseStorage.instance
  //           .ref()
  //           .child(refLink)
  //           .child(documentFileName);

  //       final documentUploadResponse =
  //           await documentFile.putFile(documentPdfFile);
  //     } catch (errorVal) {
  //       print(errorVal);
  //     }
  //   } else {
  //     final existingDocumentRef = FirebaseStorage.instance.ref();
  //     final deletingFileResponse = await existingDocumentRef
  //         .child('${refLink}/myPrescription.pdf')
  //         .delete()
  //         .then((value) async {
  //       String documentFileName = "myPrescription.pdf";
  //       final documentFile = FirebaseStorage.instance
  //           .ref()
  //           .child(refLink)
  //           .child(documentFileName);

  //       final documentUploadResponse =
  //           await documentFile.putFile(documentPdfFile);
  //     });
  //   }
  // }

  Future<void> uploadPatientAppointmentPrescription(
    BuildContext context,
    BookedTokenSlotInformation tokenInfo,
    File documentPdfFile,
  ) async {
    // FirebaseFirestore db = FirebaseFirestore.instance;
    // CollectionReference usersRef = db.collection("PatientUsersPersonalInformation");

    // var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    // var loggedInUserId = currLoggedInUser?.uid as String;

    String pid = this.mp['patient_personalUniqueIdentificationId'] ?? "";

    String aptDate = "${tokenInfo.bookedTokenDate.day}-${tokenInfo.bookedTokenDate.month}-${tokenInfo.bookedTokenDate.year}";
    String aptTime = tokenInfo.bookedTokenTime.toString();
    String refLink = "PatientReportsAndPrescriptionsDetails/${pid}/${tokenInfo.doctor_personalUniqueIdentificationId}/${tokenInfo.registeredTokenId}/${aptDate}/${aptTime}/PatientPreviousPrescription";

        try {
        String documentFileName = "myPrescriptionFile.pdf";
        final documentFile = FirebaseStorage.instance
            .ref()
            .child(refLink)
            .child(documentFileName);

        final documentUploadResponse = await documentFile.putFile(documentPdfFile).then((p0) {
          Navigator.of(context).pushNamedAndRemoveUntil(TabsScreenPatient.routeName, (route) => false);
        });
      } catch (errorVal) {
        print(errorVal);
      }

    // Future<ListResult> futureFiles = FirebaseStorage.instance.ref('/${refLink}').listAll();

    // DateTime cT = DateTime.now();
    // String pth =
    //     "${cT.day}-${cT.month}-${cT.year}-${cT.hour}-${cT.minute}-${cT.second}";
    // if (futureFiles.toString() == null) {
    //   try {
    //     String documentFileName = "doctorPrescriptionFile.pdf";
    //     final documentFile = FirebaseStorage.instance
    //         .ref()
    //         .child(refLink)
    //         .child(documentFileName);

    //     final documentUploadResponse =
    //         await documentFile.putFile(documentPdfFile);
    //   } catch (errorVal) {
    //     print(errorVal);
    //   }
    // } else {
    //   try {
    //   final existingDocumentRef = FirebaseStorage.instance.ref();
    //   final deletingFileResponse = await existingDocumentRef
    //       .child('${refLink}/doctorPrescriptionFile.pdf')
    //       .delete()
    //       .then((value) async {
    //     String documentFileName =
    //         "doctorPrescriptionFile.pdf";
    //     final documentFile = FirebaseStorage.instance
    //         .ref()
    //         .child(refLink)
    //         .child(documentFileName);

    //     final documentUploadResponse = await documentFile.putFile(documentPdfFile).then((p0) {
    //       Navigator.of(context).pushNamedAndRemoveUntil(TabsScreenDoctor.routeName, (route) => false);
    //     });
    //   });
    //   }
    //   catch (errorVal) {
    //     print(errorVal);
    //   }
    // }
  }

}
