import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/screens/phone.dart';
import 'package:covid_help/screens/vdashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  static String route_name = '/auth';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Container(
              child: Center(
                child: Text(
                  'Error ${snapshot.error}',
                  style: Constants.regularHeading,
                ),
              ),
            ));
          }

          if (snapshot.connectionState == ConnectionState.active) {
            User _user = snapshot.data;

            if (_user == null) {
              return LoginPage();
            } else {
              return VolunteerDashboard();
            }
          }

          return Loading();
        });
  }
}
