import 'package:covid_help/screens/auth.dart';
import 'package:covid_help/screens/citydashboard.dart';
import 'package:covid_help/screens/editprofile.dart';
import 'package:covid_help/screens/hdetails.dart';
import 'package:covid_help/screens/helpsearch.dart';
import 'package:covid_help/screens/needsearch.dart';
import 'package:covid_help/screens/pdashboard.dart';
import 'package:covid_help/screens/pdetails.dart';

import 'package:covid_help/screens/phone.dart';
import 'package:covid_help/screens/posthelp.dart';
import 'package:covid_help/screens/postneed.dart';
import 'package:covid_help/screens/userdashboard.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  LoginPage.route_name: (context) => LoginPage(),
  Auth.route_name: (context) => Auth(),
  PostHelp.route_name: (context) => PostHelp(),
  PatientDashboard.route_name: (context) => PatientDashboard(),
  PostNeed.route_name: (context) => PostNeed(),
  NeedSearch.route_name: (context) => NeedSearch(),
  PatientDetails.route_name: (context) => PatientDetails(),
  HelpSearch.route_name: (context) => HelpSearch(),
  HelpDetails.route_name: (context) => HelpDetails(),
  CityDashBoard.route_name: (context) => CityDashBoard(),
  UserDashboard.route_name: (context) => UserDashboard(),
  EditProfile.route_name: (context) => EditProfile(),
};
