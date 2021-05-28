import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/services/config.dart';
import 'package:covid_help/services/database.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:covid_help/widgets/helpList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostHelp extends StatefulWidget {
  static String route_name = '/posthelp';
  @override
  _PostHelpState createState() => _PostHelpState();
}

class _PostHelpState extends State<PostHelp> {
  final formKey = new GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseService databaseService = DatabaseService();
  TextEditingController textEditingController = TextEditingController();

  String helpType, helpInfo, organization, altPhone;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map data = ModalRoute.of(context).settings.arguments;
    Map user = data['user'];
    String id = data['id'];
    String name = user['name'];
    String phone = user['phone'];
    String address = user['address'];
    String city = user['city'];
    String altPhone = user['altphone'] ?? '';
    String organization = user['organization'] ?? '';
    textEditingController.text = city;

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
                              'Post your supplies',
                              style: Constants.boldHeading,
                            ),
                            Text(
                              'Please enter verified data only',
                              style: Constants.regularDarkText,
                            )
                          ],
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              HelpList(
                                onsubmit: (val) {
                                  setState(() {
                                    helpType = val;
                                  });
                                },
                              ),
                              helpType == 'Others'
                                  ? CustomInput(
                                      hintText: 'Type of help ...',
                                      onChanged: (val) {
                                        setState(() {
                                          helpType = val;
                                        });
                                      },
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return ('Enter valid help type');
                                        }
                                      })
                                  : Container(),
                              CustomInput(
                                hintText: 'Provide information for help ...',
                                onChanged: (val) {
                                  setState(() {
                                    helpInfo = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return ("Enter valis information");
                                  }
                                },
                                maxline: 4,
                              ),
                              Divider(
                                height: 30,
                              ),
                              CustomInput(
                                value: name,
                                enable: false,
                              ),
                              CustomInput(
                                value: organization,
                                hintText: "Organization name is any...",
                                enable: organization.isEmpty ? true : false,
                                onChanged: (val) {
                                  setState(() {
                                    organization = val;
                                  });
                                },
                              ),
                              CustomInput(
                                enable: false,
                                value: phone,
                                isNumberField: true,
                              ),
                              CustomInput(
                                hintText: 'Alternate contact if any ...',
                                enable: altPhone.isEmpty ? true : false,
                                value: altPhone,
                                isNumberField: true,
                              ),
                              CustomInput(
                                value: address,
                                maxline: 2,
                                enable: false,
                              ),
                              CityInput(
                                textEditingController: textEditingController,
                                onSubmit: (val) {
                                  textEditingController.text = val['city'];
                                  setState(() {
                                    city = val['city'];
                                  });
                                },
                              ),
                              CustomBtn(
                                  text: 'Post',
                                  isLoading: loading,
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('help')
                                          .doc()
                                          .set({
                                        'helpType': helpType,
                                        'helpInfo': helpInfo,
                                        'user': id,
                                        'name': name,
                                        'timestamp': formattedDate,
                                      });
                                      // try {
                                      //   await twitterApi.tweetService.update(
                                      //       status:
                                      //           'Help available \n Type: $helpType \n Info: $helpInfo \n\n Personal Details\n Name: ${user['name']} \n City: ${user['city']}, ${user['state']}\n Address: ${user['address']}\n Phone: ${user['phone']}\n #covidhelp');
                                      // } catch (error) {
                                      //   print(
                                      //       'error while requesting home timeline: $error');
                                      // }

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.teal,
                                              title: Text(
                                                'Help posted successfully',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      int counter = 0;
                                                      Navigator.popUntil(
                                                          context,
                                                          (route) =>
                                                              counter++ == 2);
                                                    },
                                                    child: Text('Continue',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                              ],
                                            );
                                          });

                                      //Navigator.pop(context);
                                    }
                                  })
                            ],
                          ))
                    ]),
              ))),
    );
  }
}
