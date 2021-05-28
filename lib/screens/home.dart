import 'package:covid_help/constants.dart';
import 'package:covid_help/widgets/cityInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Covid Help',
                  style: Constants.labelHeading,
                ),
              ),
              Column(children: [
                Text(
                  'Search helps and needs',
                  style: Constants.regularHeading,
                ),
                SizedBox(height: 30),
                CityInput(
                  textEditingController: textEditingController,
                  onSubmit: (val) {
                    textEditingController.text = val['city'];
                    Navigator.pushNamed(context, '/citydashboard', arguments: {
                      'city': val['city'],
                      'state': val['state']
                    });
                  },
                ),
              ]),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  child: Text(
                    'Post Help/Need',
                    style: Constants.regularDarkText,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
