import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/auth.dart';
import 'package:covid_help/screens/helpsearch.dart';
import 'package:covid_help/screens/needsearch.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';

class CityDashBoard extends StatefulWidget {
  static String route_name = '/citydashboard';
  @override
  _CityDashBoardState createState() => _CityDashBoardState();
}

class _CityDashBoardState extends State<CityDashBoard> {
  int _selectedIndex = 0;
  bool isSearching = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    String city = data['city'];
    String state = data['state'];

    List<Widget> _widgetOptions = <Widget>[
      HelpSearch(
        cityname: city,
      ),
      NeedSearch(
        city: city,
      ),
      // Auth(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: isSearching ? CityInput() : Container(),
      ),
      body: SafeArea(
          child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '$city , $state',
                          style: Constants.labelHeading,
                        ),
                      ),
                      _widgetOptions.elementAt(_selectedIndex),
                    ]),
              ))),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Helps'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Needs'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.pushNamed(context, '/auth');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
