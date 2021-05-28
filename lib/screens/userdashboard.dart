import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  static String route_name = '/userdashboard';
  final Map user;
  final String id;

  UserDashboard({this.user, this.id});
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text('Hello ${widget.user['name']}',
                      style: Constants.boldHeading),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/editprofile',
                          arguments: {'user': widget.user});
                    },
                    child: Text(
                      'Edit profile',
                      style: Constants.regularDarkText,
                    ))
              ]),
              Column(children: [
                CustomBtn(
                  text: 'I need help',
                  onPressed: () {
                    Navigator.pushNamed(context, '/postneed',
                        arguments: {'user': widget.user, 'id': widget.id});
                  },
                ),
                CustomBtn(
                  text: 'I can help',
                  onPressed: () {
                    Navigator.pushNamed(context, '/posthelp',
                        arguments: {'user': widget.user, 'id': widget.id});
                  },
                  outlineBtn: true,
                ),
                CustomBtn(
                  text: 'Search for resources in ${widget.user['city']}',
                  onPressed: () {
                    Navigator.pushNamed(context, '/citydashboard', arguments: {
                      'city': widget.user['city'],
                      'state': widget.user['state']
                    });
                  },
                  outlineBtn: true,
                )
              ])
            ]));
  }
}
