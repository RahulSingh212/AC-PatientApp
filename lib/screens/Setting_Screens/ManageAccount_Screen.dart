// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, unnecessary_import, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, avoid_unnecessary_containers, sort_child_properties_last, unused_import, duplicate_import, unused_local_variable, must_be_immutable

import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/patientUser_details.dart';

class PatientManageAccountScreen extends StatefulWidget {
  static const routeName = '/patient-manage-account-screen';

  int pageIndex;

  PatientManageAccountScreen(
    this.pageIndex,
  );

  @override
  State<PatientManageAccountScreen> createState() =>
      _PatientManageAccountScreenState();
}

class _PatientManageAccountScreenState extends State<PatientManageAccountScreen> {
  bool isLangEnglish = true;

  @override
  void initState() {
    super.initState();
    isLangEnglish = Provider.of<PatientUserDetails>(context, listen: false)
        .isReadingLangEnglish;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topInsets = MediaQuery.of(context).viewInsets.top;
    var bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    var useableHeight = screenHeight - topInsets - bottomInsets;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(66, 204, 195, 1),
        title: Text(
          isLangEnglish ? "Manage Account" : "खाते का प्रबंधन करें",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}
