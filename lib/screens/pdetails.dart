import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_downloader/image_downloader.dart';

class PatientDetails extends StatefulWidget {
  static String route_name = '/pdetails';
  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  Map data = {};
  Map patient = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    patient = data['person'];
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
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '${patient['helpType']}',
                            style: Constants.labelHeading,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            '${patient['helpInfo']}',
                            style: Constants.semiHeading,
                          ),
                        ),
                        Divider(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Patient name : ${patient['patientname']}',
                            style: Constants.nameText,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                                'Gender/Age : ${patient['gender']} , ${patient['age']} years',
                                style: Constants.regularHeading)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Location : ${patient['user']['addrerss']}, ${patient['user']['city']}',
                            style: Constants.regularHeading,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Contact : ${patient['user']['phone']}',
                            style: Constants.regularHeading,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Prescription :',
                            style: Constants.regularHeading,
                          ),
                        ),
                        patient['prescription'] != null
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Image.network(
                                          patient['prescription'],
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Loading();
                                      }),
                                    ),
                                  ),
                                  IconButton(
                                      color: Colors.teal,
                                      icon: Icon(Icons.file_download),
                                      onPressed: () async {
                                        try {
                                          // Saved with this method.
                                          var imageId = await ImageDownloader
                                              .downloadImage(
                                                  patient['prescription']);

                                          if (imageId == null) {
                                            return;
                                          }

                                          // Below is a method of obtaining saved image information.
                                          // var fileName =
                                          //     await ImageDownloader.findName(
                                          //         imageId);
                                          // var path =
                                          //     await ImageDownloader.findPath(
                                          //         imageId);
                                          // var size = await ImageDownloader
                                          //     .findByteSize(imageId);
                                          // var mimeType = await ImageDownloader
                                          //     .findMimeType(imageId);
                                        } on PlatformException catch (error) {
                                          print(error);
                                        }
                                      })
                                ],
                              )
                            : Container(),
                        CustomBtn(
                          text: 'Contact the patient',
                          onPressed: () {
                            launch("tel://+91${patient['user']['phone']}");
                          },
                        ),
                        // CustomBtn(
                        //     text: "Whatsapp",
                        //     outlineBtn: true,
                        //     onPressed: () async {
                        //       await launch(
                        //           "https://wa.me/${patient['phone']}?text=Hello");
                        //     })
                      ]),
                ))));
  }
}
