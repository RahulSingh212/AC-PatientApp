// ignore_for_file: use_build_context_synchronously, unnecessary_this, unused_local_variable, non_constant_identifier_names, await_only_futures, unnecessary_brace_in_string_interps, unused_import, duplicate_import

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
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class steps_distance {
  final int Steps;
  final double Distance;
  final DateTime Date_time;

  steps_distance({
    required this.Steps,
    required this.Distance,
    required this.Date_time,
  });
}
