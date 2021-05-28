import 'package:covid_help/constants.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpDetails extends StatefulWidget {
  static String route_name = '/hdetails';
  @override
  _HelpDetailsState createState() => _HelpDetailsState();
}

class _HelpDetailsState extends State<HelpDetails> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    Map person = data['person'];
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          '${person['helpType']}',
                          style: Constants.labelHeading,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text('${person['helpInfo']}',
                            style: Constants.semiHeading),
                      ),
                      Divider(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   child: Text(
                          //     'Personal Details',
                          //     style: Constants.boldHeading,
                          //   ),
                          // ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Name : ${person['user']['name']}',
                              style: Constants.nameText,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Address : ${person['user']['addrerss']} \n${person['user']['city']}, ${person['user']['state']} ',
                              style: Constants.nameText,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Organization : ${person['user']['organization']}',
                              style: Constants.regularHeading,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Contact : ${person['user']['phone']}',
                              style: Constants.regularHeading,
                            ),
                          ),
                          person['user']['altphone'].isEmpty
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'Alternate Contact : ${person['user']['altphone']}',
                                    style: Constants.regularHeading,
                                  ),
                                ),
                        ],
                      ),
                      CustomBtn(
                        text: 'Contact the person',
                        onPressed: () {
                          launch("tel://${person['user']['phone']}");
                        },
                      ),
                    ]))));
  }
}
