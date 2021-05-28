import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/widgets/cityInput.dart';

import 'package:covid_help/widgets/custom_btn.dart';
import 'package:covid_help/widgets/helpList.dart';
import 'package:flutter/material.dart';

class NeedSearch extends StatefulWidget {
  static String route_name = '/needsearch';
  final String city;

  NeedSearch({this.city});

  @override
  _NeedSearchState createState() => _NeedSearchState();
}

class _NeedSearchState extends State<NeedSearch> {
  bool loading = false;
  List results = [];
  List filterResults = [];
  bool filter = false;
  String helpType;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: Loading())
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('need')
                .where('user.city', isEqualTo: widget.city)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.active) {
                results = snapshot.data.docs;

                return Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HelpList(
                            onsubmit: (val) {
                              setState(() {
                                filter = true;
                                helpType = val;
                                filterResults = results
                                    .where(
                                        (element) => element['helpType'] == val)
                                    .toList();
                              });
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(filter ? helpType : 'Needs',
                                style: Constants.regularHeading),
                          ),
                          results.isEmpty
                              ? Column(children: [
                                  SizedBox(height: 50),
                                  Text(
                                    'No current data avilable',
                                    style: Constants.nameText,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/auth');
                                      },
                                      child: Text(
                                        'Post your Help/Need',
                                        style: Constants.regularDarkText,
                                      ))
                                ])
                              : filter
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: filterResults.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/pdetails', arguments: {
                                                'person':
                                                    filterResults[index].data()
                                              });
                                            },
                                            child: Card(
                                              margin: EdgeInsets.all(10),
                                              child: ListTile(
                                                title: Text(
                                                    filterResults[index]['user']
                                                        ['name'],
                                                    style: Constants
                                                        .regularDarkText),
                                                subtitle: Text(
                                                    filterResults[index]
                                                        ['helpInfo']),
                                              ),
                                            ));
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: results.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/pdetails',
                                                  arguments: {
                                                    'person':
                                                        results[index].data()
                                                  });
                                            },
                                            child: Card(
                                              margin: EdgeInsets.all(10),
                                              child: ListTile(
                                                title: Text(
                                                    results[index]['user']
                                                        ['name'],
                                                    style: Constants
                                                        .regularDarkText),
                                                subtitle: Text(
                                                    results[index]['helpInfo']),
                                              ),
                                            ));
                                      },
                                    ),
                        ],
                      ),
                    ));
              } else {
                return Loading();
              }
            });
  }
}
