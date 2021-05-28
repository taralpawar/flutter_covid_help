import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  static String route_name = '/editprofile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  bool loading = false;
  String name, phone, address, city, state, organization, altPhone;
  //textEditingController.text = city;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User currentUser = auth.currentUser;

    Map data = ModalRoute.of(context).settings.arguments;
    Map user = data['user'];

    // String name = user['name'];
    // String phone = user['phone'];
    // String address = user['addrerss'];
    // String city = user['city'];
    // String state = user['state'];
    // String altPhone = user['altphone'] ?? '';
    // String organization = user['organization'];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Edit your profile',
                              style: Constants.boldHeading,
                            ),
                            Text(
                              'Enter your most recent and valid details',
                              style: Constants.regularDarkText,
                            )
                          ],
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: Column(children: [
                            CustomInput(
                              hintText: 'Name',
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return ('Enter valid name');
                                }
                              },
                              value: user['name'],
                            ),
                            CustomInput(
                              hintText: 'Organization name is any',
                              onChanged: (val) {
                                setState(() {
                                  organization = val;
                                });
                              },
                              value: user['organization'],
                            ),
                            CustomInput(
                              hintText: 'Address',
                              onChanged: (val) {
                                setState(() {
                                  address = val;
                                });
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return ('Enter valid address');
                                }
                              },
                              value: user['addrerss'],
                              maxline: 3,
                            ),
                            CityInput(
                              textEditingController: textEditingController,
                              onSubmit: (val) {
                                textEditingController.text = val['city'];
                                setState(() {
                                  city = val['city'];
                                  state = val['state'];
                                });
                              },
                            ),
                            CustomInput(
                              hintText: "Alternate Phone number if any",
                              onChanged: (val) {
                                setState(() {
                                  altPhone = val;
                                });
                              },
                              isNumberField: true,
                              value: user['altphone'],
                            ),
                            CustomBtn(
                              isLoading: loading,
                              text: 'Submit',
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser.uid)
                                    .set({
                                  'name': name ?? user['name'],
                                  'address': address ?? user['addrerss'],
                                  'city': city ?? user['city'],
                                  'state': state ?? user['state'],
                                  'organization':
                                      organization ?? user['organization'],
                                  'phone': phone ?? user['phone'],
                                  'altPhone': altPhone ?? user['altphone']
                                });
                                print('updated');

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.teal,
                                        title: Text(
                                          'Profile Edited',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                int counter = 0;
                                                Navigator.popUntil(context,
                                                    (route) => counter++ == 2);
                                              },
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)))
                                        ],
                                      );
                                    });
                              },
                            ),
                          ]))
                    ])))));
  }
}
