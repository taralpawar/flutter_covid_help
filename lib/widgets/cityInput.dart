import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:covid_help/constants.dart';
import 'package:covid_help/services/cities.dart';
import 'package:flutter/material.dart';

class CityInput extends StatelessWidget {
  final Function onSubmit;
  final TextEditingController textEditingController;

  CityInput({this.onSubmit, this.textEditingController});
  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<Map<dynamic, dynamic>>> key =
        new GlobalKey();
    //TextEditingController txt = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: AutoCompleteTextField<Map<dynamic, dynamic>>(
        key: key,
        controller: textEditingController,
        clearOnSubmit: false,
        itemSubmitted: onSubmit,
        suggestions: cityNames,
        suggestionsAmount: 3,
        itemBuilder: (context, suggestion) => new Padding(
            child: new ListTile(
                title: new Text(
                  suggestion['city'],
                  style: Constants.regularDarkText,
                ),
                trailing: new Text("${suggestion['state']}")),
            padding: EdgeInsets.all(8.0)),

        itemFilter: (suggestion, input) =>
            suggestion['city'].toLowerCase().startsWith(input.toLowerCase()),

        itemSorter: (a, b) => a == b
            ? 0
            : a.length > b.length
                ? -1
                : 1,

        //clearOnSubmit: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search your city...",
            suffixIcon: Icon(
              Icons.search,
              color: Colors.teal,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            )),
        style: Constants.regularDarkText,
      ),
    );
  }
}
