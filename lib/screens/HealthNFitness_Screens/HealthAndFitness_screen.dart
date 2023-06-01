import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
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

import '../../providers/patientAuth_details.dart';
import '../../providers/patientAuth_details.dart';

import './WellNess_Page.dart';

class HealthAndFitnessScreenPatient extends StatefulWidget {
  static const routeName = '/patient-find-doctor-screen';

  @override
  State<HealthAndFitnessScreenPatient> createState() => _HealthAndFitnessScreenPatientState();
}

class _HealthAndFitnessScreenPatientState extends State<HealthAndFitnessScreenPatient> {
  
  
  @override
  Widget build(BuildContext context) {
    return WellNess_Page();
  }
}