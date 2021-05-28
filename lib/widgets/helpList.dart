import 'package:covid_help/constants.dart';
import 'package:flutter/material.dart';

class HelpList extends StatelessWidget {
  final Function onsubmit;

  HelpList({this.onsubmit});

  final List<String> helpType = [
    'Oxygen Cylinders',
    'Beds',
    'Injections',
    'Blood',
    'Medical Equiments',
    'Others'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Select type of help ...",
              hintStyle: Constants.regularDarkText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              )),
          style: Constants.regularDarkText,
          //value: value,
          //value: 'Select type of help',
          items: helpType.map((help) {
            return DropdownMenuItem(value: help, child: Text(help));
          }).toList(),
          onChanged: onsubmit),
    );
  }
}
