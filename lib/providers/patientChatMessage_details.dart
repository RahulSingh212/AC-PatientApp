// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, unnecessary_import, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, avoid_unnecessary_containers, sort_child_properties_last, unused_import, duplicate_import, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:auriga_patient/screens/AppointsAndTests_Screens/PreviosAppointmentSection.dart';
import 'package:auriga_patient/screens/AppointsAndTests_Screens/UpComingAppointmentSection.dart';
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
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PatientChatMessageDetails with ChangeNotifier {
  Future<void> fetchChatMessages(
    BuildContext context,
    String doctorUniqueId,
  ) async {
    var currLoggedInUser = FirebaseAuth.instance.currentUser;
    var loggedInUserId = currLoggedInUser?.uid as String;

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersRef =
        db.collection("PatientChatMessages/${loggedInUserId}");
  }
}
