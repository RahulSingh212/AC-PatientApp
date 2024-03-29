// ignore_for_file: use_build_context_synchronously, unnecessary_this, unused_local_variable, non_constant_identifier_names, await_only_futures, unnecessary_brace_in_string_interps, unnecessary_new, unnecessary_string_interpolations, duplicate_import, unused_import, prefer_const_constructors

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:auriga_patient/models/doctor_Info.dart';
import 'package:auriga_patient/providers/patientUser_details.dart';
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

import '../models/slot_info.dart';
import 'firebaseLinks_details.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add_15Minutes({int hour = 0, int minute = 15}) {
    if (this.minute + minute >= 60 && this.hour + hour >= 24) {
      return this.replacing(
          hour: (this.hour + hour) % 24, minute: (this.hour + hour) % 60);
    } else {
      return this.replacing(
          hour: this.minute + minute >= 60
              ? this.hour + hour + 1
              : this.hour + hour,
          minute: this.minute + minute >= 60
              ? (this.minute + minute) % 60
              : this.minute + minute);
    }
  }
}

class AppointmentUpdationDetails with ChangeNotifier {
  List<TimeOfDay> _itemsAvailableDuration = [];

  List<TimeOfDay> get items {
    return [..._itemsAvailableDuration];
  }

  Future<void> checkAppointmentDetails(
    BuildContext context,
    DoctorSlotInformation slotInfoDetails,
    DateTime choosenAppointmentDate,
  ) async {
    bool checker = true;
    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    String aptDate = "${choosenAppointmentDate.day}-${choosenAppointmentDate.month}-${choosenAppointmentDate.year}";
    String statusUrl = "AppointmentStatusDetails/${slotInfoDetails.slotUniqueId}/${aptDate}";

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference aptStatusRef = db.collection("${statusUrl}");

    Uri appointmentStatusLink = Provider.of<PatientFirebaseDetails>(context, listen: false)
        .getFirebasePathUrl('/${statusUrl}.json');

    try {
      List<TimeOfDay> availableSlots = [];
      final dataBaseResponse = await http.get(appointmentStatusLink);
      Map<String, dynamic> aptStatusMap = {};

      if(dataBaseResponse.body.toString() != "null")
        aptStatusMap = json.decode(dataBaseResponse.body) as Map<String, dynamic>;

      DateTime presentDate = DateTime.now();
      TimeOfDay presentTime = TimeOfDay.now();

      if (presentDate.day == choosenAppointmentDate.day &&
          presentDate.month == choosenAppointmentDate.month &&
          presentDate.year == choosenAppointmentDate.year &&
          (presentTime.hour * 60 + presentTime.minute) >=
              (slotInfoDetails.endTime.hour * 60 +
                  slotInfoDetails.endTime.minute)) {
        return;
      }

      if (aptStatusMap.isEmpty) {
        TimeOfDay startSlotTime = slotInfoDetails.startTime;
        TimeOfDay endSlotTime = slotInfoDetails.endTime;
        TimeOfDay temp = startSlotTime;

        // print("inside");
        while ((temp.hour * 60 + temp.minute) <
            (endSlotTime.hour * 60 + endSlotTime.minute)) {
          if (presentDate.day == choosenAppointmentDate.day &&
              presentDate.month == choosenAppointmentDate.month &&
              presentDate.year == choosenAppointmentDate.year) {
            if ((temp.hour * 60 + temp.minute) >
                (presentTime.hour * 60 + presentTime.minute)) {
              availableSlots.add(temp);
            }
          } else {
            availableSlots.add(temp);
          }
          temp = temp.add_15Minutes();
        }

        this._itemsAvailableDuration = availableSlots;
        notifyListeners();
      } else {
        TimeOfDay startSlotTime = slotInfoDetails.startTime;
        TimeOfDay endSlotTime = slotInfoDetails.endTime;
        TimeOfDay temp = startSlotTime;

        while ((temp.hour * 60 + temp.minute) <
            (endSlotTime.hour * 60 + endSlotTime.minute)) {
          if (aptStatusMap.containsKey("${temp.toString()}") == false) {
            if (presentDate.day == choosenAppointmentDate.day &&
                presentDate.month == choosenAppointmentDate.month &&
                presentDate.year == choosenAppointmentDate.year) {
              if ((temp.hour * 60 + temp.minute) >
                  (presentTime.hour * 60 + presentTime.minute)) {
                availableSlots.add(temp);
              }
            } else {
              availableSlots.add(temp);
            }
          }
          temp = temp.add_15Minutes();
        }

        this._itemsAvailableDuration = availableSlots;
        notifyListeners();
      }
    } catch (errorVal) {
      print("ErrorVal: ");
      print(errorVal);
    }
  }

  Future<void> savePatientAppointmentSlot(
    BuildContext context,
    bool isClinicApt,
    bool isVideoApt,
    TimeOfDay selectedSlotTime,
    DateTime choosenAppointmentDate,
    String patientAilmentDescription,
    DoctorSlotInformation slotInfo,
    DoctorDetailsInformation doctorDetails,
  ) async {
    Map<String, String> mp =
        Provider.of<PatientUserDetails>(context, listen: false)
            .getPatientUserPersonalInformation();
    var currLoggedInUser = await FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    String patientSideUrl = "PatientBookedAppointList/${loggedInUserId}";
    String doctorSideUrl = "DoctorBookedAppointList/${doctorDetails.doctor_personalUniqueIdentificationId}";

    String patientSideAppointmentUniqueId = "";
    String doctorSideAppointmentUniqueId = "";

    Uri patientUrlLink = Provider.of<PatientFirebaseDetails>(context, listen: false)
        .getFirebasePathUrl('/${patientSideUrl}.json');

    Uri doctorUrlLink = Provider.of<PatientFirebaseDetails>(context, listen: false)
        .getFirebasePathUrl('/${doctorSideUrl}.json');

    String aptDate = "${choosenAppointmentDate.day}-${choosenAppointmentDate.month}-${choosenAppointmentDate.year}";
    String statusUrl = "AppointmentStatusDetails/${slotInfo.slotUniqueId}/${aptDate}";

    // // used in creating our own value of the "key"
    DatabaseReference mDatabase = FirebaseDatabase.instance.ref();
    // mDatabase.child("${statusUrl}").child("${selectedSlotTime.toString()}").set(loggedInUserId);
    // mDatabase
    //     .child("AppointmentStatusDetails")
    //     .child("${slotInfo.slotUniqueId}")
    //     .child("${aptDate}")
    //     .set({selectedSlotTime.toString(): loggedInUserId});

    bool isAppointmentCreated = false;
    try {
      mDatabase
          .child("AppointmentStatusDetails")
          .child("${slotInfo.slotUniqueId}")
          .child("${aptDate}")
          .update({selectedSlotTime.toString(): loggedInUserId}).then(
        (value) async {
          final responseForPatientApt = await http
              .post(
            patientUrlLink,
            body: json.encode(
              {
                'registeredTokenId': DateTime.now().toString(),
                'appointmentDate': choosenAppointmentDate.toString(),
                'appointmentTime': selectedSlotTime.toString(),
                'doctor_AppointmentUniqueId': slotInfo.slotUniqueId.toString(),
                'doctor_personalUniqueIdentificationId': doctorDetails
                    .doctor_personalUniqueIdentificationId
                    .toString(),
                'isClinicAppointmentType': isClinicApt.toString(),
                'isVideoAppointmentType': isVideoApt.toString(),
                'isTokenActive': "true",
                'patientAilmentDescription': patientAilmentDescription.toString(),
                'prescriptionUrl': "",
                'slotType': "appointment",
                'registrationTiming': DateTime.now().toString(),
                'doctorFullName': doctorDetails.doctor_FullName.toString(),
                'doctorSpeciality': doctorDetails.doctor_Speciality.toString(),
                'doctorImageUrl': doctorDetails.doctor_ProfilePicUrl.toString(),
                'doctorTotalRatings': doctorDetails.doctor_TotalExperience.toString(),
                'givenPatientExperienceRating': '0'.toString(),
                'testType': "",
                'aurigaCareTestCenter': "",
                'testReportUrl': "",
                'tokenFees': slotInfo.appointmentFeesPerPatient.toString(),
              },
            ),
          )
              .then(
            (savedResponsePatient) async {

              Uri urlLinkForUpdate = Provider.of<PatientFirebaseDetails>(context, listen: false)
        .getFirebasePathUrl('/PatientBookedAppointList/${loggedInUserId}/${json.decode(savedResponsePatient.body)["name"]}.json');

              patientSideAppointmentUniqueId =
                  json.decode(savedResponsePatient.body)["name"];
              final responseForPatientTokenDetails = await http
                  .patch(
                urlLinkForUpdate,
                body: json.encode(
                  {
                    'registeredTokenId': json
                        .decode(savedResponsePatient.body)["name"]
                        .toString(),
                  },
                ),
              )
                  .then(
                (value) {
                  mDatabase
                      .child("DoctorBookedAppointList")
                      .child(
                          "${doctorDetails.doctor_personalUniqueIdentificationId}")
                      .child("${patientSideAppointmentUniqueId}")
                      .update(
                    {
                      'registeredTokenId': json
                          .decode(savedResponsePatient.body)["name"]
                          .toString(),
                      'appointmentDate': choosenAppointmentDate.toString(),
                      'appointmentTime': selectedSlotTime.toString(),
                      'doctor_AppointmentUniqueId':
                          slotInfo.slotUniqueId.toString(),
                      'doctor_personalUniqueIdentificationId': doctorDetails
                          .doctor_personalUniqueIdentificationId
                          .toString(),
                      'isClinicAppointmentType': isClinicApt.toString(),
                      'isVideoAppointmentType': isVideoApt.toString(),
                      'isTokenActive': "true",
                      'patientAilmentDescription':
                          patientAilmentDescription.toString(),
                      'prescriptionUrl': "",
                      'slotType': "appointment",
                      'registrationTiming': DateTime.now().toString(),
                      'doctorFullName':
                          doctorDetails.doctor_FullName.toString(),
                      'doctorSpeciality':
                          doctorDetails.doctor_Speciality.toString(),
                      'doctorImageUrl':
                          doctorDetails.doctor_ProfilePicUrl.toString(),
                      'doctorTotalRatings':
                          doctorDetails.doctor_TotalExperience.toString(),
                      'testType': "",
                      'aurigaCareTestCenter': "",
                      'testReportUrl': "",
                      'tokenFees':
                          slotInfo.appointmentFeesPerPatient.toString(),
                      'givenPatientExperienceRating': '0',
                      'patient_personalUniqueIdentificationId':
                          loggedInUserId.toString(),
                      'patientFullName': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_FullName"]
                          .toString(),
                      'patientImageUrl': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_ProfilePicUrl"]
                          .toString(),
                      'patient_Gender': Provider.of<PatientUserDetails>(context,
                              listen: false)
                          .getPatientUserPersonalInformation()["patient_Gender"]
                          .toString(),
                      'patient_Age': Provider.of<PatientUserDetails>(context,
                              listen: false)
                          .getPatientUserPersonalInformation()["patient_Age"]
                          .toString(),
                      'patient_Height': Provider.of<PatientUserDetails>(context,
                              listen: false)
                          .getPatientUserPersonalInformation()["patient_Height"]
                          .toString(),
                      'patient_Weight': Provider.of<PatientUserDetails>(context,
                              listen: false)
                          .getPatientUserPersonalInformation()["patient_Weight"]
                          .toString(),
                      'patient_BloodGroup': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_BloodGroup"]
                          .toString(),
                      'patient_PhoneNumber': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_PhoneNumber"]
                          .toString(),
                      'patient_Injuries': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_Injuries"]
                          .toString(),
                      'patient_Allergies': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_Allergies"]
                          .toString(),
                      'patient_Medication': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_Medication"]
                          .toString(),
                      'patient_Surgeries': Provider.of<PatientUserDetails>(
                              context,
                              listen: false)
                          .getPatientUserPersonalInformation()[
                              "patient_Surgeries"]
                          .toString(),
                    },
                  );
                },
              );
            },
          );
        },
      ).then((value) async {
        var responseVal = await mDatabase
            .child("DoctorPatientDetails")
            .child(doctorDetails.doctor_personalUniqueIdentificationId)
            .child("${loggedInUserId}")
            .update({
          'patient_personalUniqueIdentificationId':
              mp['patient_personalUniqueIdentificationId'],
          'patient_LastBookedAppointmentDate':
              choosenAppointmentDate.toString(),
          'patient_LastBookedAppointmentTime': selectedSlotTime.toString(),
          // 'patient_FullName': mp['patient_FullName'],
          // 'patient_ProfilePicUrl': mp['patient_ProfilePicUrl'],
          // 'patient_Age': mp['patient_Age'],
          // 'patient_Gender': mp['patient_Gender'],
          // 'patient_BloodGroup': mp['patient_BloodGroup'],
          // 'patient_Height': mp['patient_Height'],
          // 'patient_Weight': mp['patient_Weight'],
          // 'patient_PhoneNumber': mp['patient_PhoneNumber'],
        }).then((value) async {
          isAppointmentCreated = true;
          print("Executed");

          notifyListeners();
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     TabsScreenPatient.routeName, (route) => false);
        });
      });
    } catch (errorVal) {
      print("Error while saving the status of appointment");
      print(errorVal);
    }
  }

  TimeOfDay convertStringToTimeOfDay(String givenTime) {
    int hrVal = int.parse(givenTime.split(":")[0].substring(10));
    int minVal = int.parse(givenTime.split(":")[1].substring(0, 2));
    TimeOfDay time = TimeOfDay(hour: hrVal, minute: minVal);

    return time;
  }
}
