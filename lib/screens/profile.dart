import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController txt = TextEditingController();

  String name, address, city, state, altphone, organization;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    return Container(
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                padding: EdgeInsets.all(20),
                child:
                    Text('Complete your Profile', style: Constants.boldHeading),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomInput(
                        hintText: 'Enter you name ...',
                        validator: (val) {
                          if (val.isEmpty) {
                            return ("Enter valid name");
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        }),
                    CustomInput(
                        hintText: 'Organization name if any ...',
                        validator: (val) {
                          if (val.isEmpty) {
                            return ("Enter valid name");
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            organization = val;
                          });
                        }),
                    CustomInput(
                      hintText: 'Address ...',
                      maxline: 3,
                      onChanged: (val) {
                        setState(() {
                          address = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return ("Enter valid address");
                        }
                      },
                    ),
                    CityInput(
                      textEditingController: txt,
                      onSubmit: (val) {
                        txt.text = val['city'];
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
                          altphone = val;
                        });
                      },
                      isNumberField: true,
                    ),
                    SizedBox(height: 20),
                    CustomBtn(
                      isLoading: loading,
                      text: 'Submit',
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set({
                            'name': name,
                            'addrerss': address,
                            'city': city,
                            'state': state,
                            'altphone': altphone,
                            'phone': user.phoneNumber,
                            'organization': organization
                          });
                        }
                      },
                    )
                  ],
                ),
              )
            ])));
  }
}
