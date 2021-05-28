import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/services/cities.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class PatientDashboard extends StatefulWidget {
  static String route_name = '/pdashboard';
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  GlobalKey<AutoCompleteTextFieldState<Map<dynamic, dynamic>>> key =
      new GlobalKey();
  TextEditingController txt = TextEditingController();
  List<Map> resultList = [];
  bool loading = false;
  String city = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            //resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Container(
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Search for helps \n in your city',
                              style: Constants.boldHeading,
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //     vertical: 8.0,
                          //     horizontal: 24.0,
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: Color(0xFFF2F2F2),
                          //       borderRadius: BorderRadius.circular(12.0)),
                          //   child: AutoCompleteTextField<Map<dynamic, dynamic>>(
                          //     key: key,
                          //     controller: txt,
                          //     itemSubmitted: (val) async {
                          //       setState(() {
                          //         loading = true;
                          //       });
                          //       await FirebaseFirestore.instance
                          //           .collection('help')
                          //           .where('city', isEqualTo: val['city'])
                          //           .get()
                          //           .then(
                          //               (value) => value.docs.forEach((result) {
                          //                     resultList.add(result.data());
                          //                   }));

                          //       Navigator.pushNamed(context, '/helpsearch',
                          //           arguments: {
                          //             'result': resultList,
                          //             'city': val['city'],
                          //           });
                          //       setState(() {
                          //         loading = false;
                          //         resultList = [];
                          //       });
                          //     },

                          //     suggestions: cityNames,

                          //     itemBuilder: (context, suggestion) => new Padding(
                          //         child: new ListTile(
                          //             title: new Text(
                          //               suggestion['city'],
                          //               style: Constants.regularDarkText,
                          //             ),
                          //             trailing:
                          //                 new Text("${suggestion['state']}")),
                          //         padding: EdgeInsets.all(8.0)),

                          //     itemFilter: (suggestion, input) =>
                          //         suggestion['city']
                          //             .toLowerCase()
                          //             .startsWith(input.toLowerCase()),

                          //     itemSorter: (a, b) => a == b
                          //         ? 0
                          //         : a.length > b.length
                          //             ? -1
                          //             : 1,

                          //     //clearOnSubmit: true,
                          //     decoration: InputDecoration(
                          //         border: InputBorder.none,
                          //         hintText: "Search your city...",
                          //         suffixIcon: Icon(
                          //           Icons.search,
                          //           color: Colors.teal,
                          //         ),
                          //         contentPadding: EdgeInsets.symmetric(
                          //           horizontal: 24.0,
                          //           vertical: 20.0,
                          //         )),
                          //   ),
                          // ),
                          CityInput(
                            onSubmit: (val) async {
                              setState(() {
                                loading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('help')
                                  .where('city', isEqualTo: val['city'])
                                  .get()
                                  .then((value) => value.docs.forEach((result) {
                                        resultList.add(result.data());
                                      }));

                              Navigator.pushNamed(context, '/helpsearch',
                                  arguments: {
                                    'result': resultList,
                                    'city': val['city'],
                                  });
                              setState(() {
                                loading = false;
                                resultList = [];
                              });
                            },
                          ),
                          Text(
                            'OR',
                            style: Constants.regularDarkText,
                          ),
                          CustomBtn(
                            text: 'Post help',
                            onPressed: () {
                              Navigator.pushNamed(context, '/postneed');
                            },
                            outlineBtn: true,
                          )
                        ]))));
  }
}
