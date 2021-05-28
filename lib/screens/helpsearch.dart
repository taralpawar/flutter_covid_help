import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/widgets/helpList.dart';
import 'package:flutter/material.dart';

class HelpSearch extends StatefulWidget {
  static String route_name = '/helpsearch';

  final String cityname;
  HelpSearch({this.cityname});
  @override
  _HelpSearchState createState() => _HelpSearchState();
}

class _HelpSearchState extends State<HelpSearch> {
  bool loading = false;
  List results = [];
  List filterResults = [];
  bool filter = false;
  String helpType;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('help')
                .where('user.city', isEqualTo: widget.cityname)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.active) {
                results = snapshot.data.docs;
                return Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          child: Text(
                            filter ? helpType : 'Helps',
                            style: Constants.regularHeading,
                          ),
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
                                ? Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: filterResults.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/hdetails', arguments: {
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
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: results.length,
                                      itemBuilder: (context, index) {
                                        print(results.length);
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/hdetails',
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
                                  ),
                      ],
                    ));
              } else {
                return Loading();
              }
            });
  }
}
