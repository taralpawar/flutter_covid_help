import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/screens/profile.dart';
import 'package:covid_help/screens/userdashboard.dart';
import 'package:covid_help/services/authservice.dart';

import 'package:covid_help/services/database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VolunteerDashboard extends StatefulWidget {
  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  DatabaseService databaseService = DatabaseService();

  bool loading = false;
  //var userData;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: Text(
                  'Logout',
                  style: Constants.regularDarkText,
                ))
          ],
        ),
        //resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.active) {
              DocumentSnapshot userData = (snapshot.data);
              print(userData.data());
              if (userData.data() == null) {
                return Container(
                  child: CompleteProfile(),
                );
              } else {
                return Container(
                  child: UserDashboard(user: userData.data(), id: userData.id),
                );
              }
            } else {
              return Loading();
            }
          },
        ));
  }
}
