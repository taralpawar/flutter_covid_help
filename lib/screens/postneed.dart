import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/services/config.dart';
import 'package:covid_help/services/database.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:covid_help/widgets/helpList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PostNeed extends StatefulWidget {
  static String route_name = '/postneed';
  @override
  _PostNeedState createState() => _PostNeedState();
}

class _PostNeedState extends State<PostNeed> {
  final formKey = new GlobalKey<FormState>();
  FirebaseStorage _storage = FirebaseStorage.instance;
  DatabaseService databaseService = DatabaseService();

  TextEditingController textEditingController = TextEditingController();

  String name, helpType, helpInfo, gender, age, imageUrl;
  List<String> genderType = ['Male', 'Female', 'Others'];
  File sampleImage;
  bool uploaded = false;
  final picker = ImagePicker();
  bool loading = false;

  Future uploadImage() async {
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (tempImage != null) {
        sampleImage = File(tempImage.path);
        uploaded = true;
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(sampleImage.path);
    Reference reference = _storage.ref().child("precriptions/$fileName");
    UploadTask uploadTask = reference.putFile(sampleImage);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();
    return (url);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    Map user = data['user'];
    String id = data['id'];

    String phone = user['phone'];
    String address = user['addrerss'];
    String city = user['city'];

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
                              'Post your requirments',
                              style: Constants.boldHeading,
                            ),
                            Text(
                              'Please enter necessary and valid data only',
                              style: Constants.regularDarkText,
                            )
                          ],
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: Column(children: <Widget>[
                            HelpList(onsubmit: (val) {
                              helpType = val;
                            }),
                            CustomInput(
                              hintText:
                                  'Provide information about your requirements ...',
                              onChanged: (val) {
                                setState(() {
                                  helpInfo = val;
                                });
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return ('Enter valid details');
                                }
                              },
                              maxline: 4,
                            ),
                            Divider(
                              height: 30,
                            ),
                            CustomInput(
                              hintText: 'Enter patient name ...',
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
                            ),
                            Row(children: [
                              Expanded(
                                child: CustomInput(
                                  hintText: 'Age ...',
                                  onChanged: (val) {
                                    setState(() {
                                      age = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return ('Enter valid age');
                                    }
                                  },
                                  isNumberField: true,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 24.0,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: DropdownButtonFormField(
                                    style: Constants.regularDarkText,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Gender",
                                        hintStyle: Constants.regularDarkText,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 24.0,
                                          vertical: 20.0,
                                        )),
                                    //value: 'Select type of help',
                                    items: genderType.map((help) {
                                      return DropdownMenuItem(
                                          value: help, child: Text(help));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                            CustomInput(
                              value: address,
                              maxline: 2,
                              hintText: 'Address ...',
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
                            CustomInput(
                              value: phone,
                              hintText: 'Enter contact number ...',
                              onChanged: (val) {
                                setState(() {
                                  phone = val;
                                });
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return ('Enter a valid 10 digit mobile numebr');
                                }
                              },
                              isNumberField: true,
                            ),
                            Divider(height: 30),
                            CustomBtn(
                              text: uploaded
                                  ? '${basename(sampleImage.path)}'
                                  : 'Upload prescription',
                              onPressed: uploadImage,
                              outlineBtn: true,
                            ),
                            uploaded
                                ? Container(
                                    child: Column(
                                      children: [
                                        Image.file(sampleImage,
                                            height: 200, width: 200),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                sampleImage = null;
                                                uploaded = false;
                                              });
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: Constants.regularDarkText,
                                            )),
                                      ],
                                    ),
                                  )
                                : Container(),
                            CustomBtn(
                                text: 'Post the requirment',
                                isLoading: loading,
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (sampleImage != null) {
                                      imageUrl =
                                          await uploadImageToFirebase(context);
                                    }

                                    await FirebaseFirestore.instance
                                        .collection('need')
                                        .doc()
                                        .set({
                                      'helpInfo': helpInfo,
                                      'helpType': helpType,
                                      'patientname': name,
                                      'age': age,
                                      'gender': gender,
                                      'user': id,
                                      'prescription': imageUrl,
                                    });

                                    await twitterApi.tweetService.update(
                                        status:
                                            'Urgent Requirement \n Type: $helpType \n Info: $helpInfo \n\n Personal Details\n Name: $name\n Gender: $gender, Age: $age\n City: ${user['city']}, ${user['state']}\n Address: ${user['address']}\n Phone: ${user['phone']}\n #covidhelp');

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            elevation: 2,
                                            backgroundColor: Colors.teal,
                                            title: Text(
                                              'Requirement posted successfully',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
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
                                                          color: Colors.white)))
                                            ],
                                          );
                                        });
                                  }
                                })
                          ]))
                    ])))));
  }
}
