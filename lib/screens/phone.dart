import 'package:covid_help/constants.dart';
import 'package:covid_help/screens/loading.dart';
import 'package:covid_help/services/authservice.dart';
import 'package:covid_help/widgets/customInput.dart';
import 'package:covid_help/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String route_name = '/phonelogin';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;
  bool loading = false;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Login with your \n Phone number',
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: 'Enter the Phone number ...',
                      onChanged: (val) {
                        setState(() {
                          phoneNo = val;
                        });
                      },
                      validator: (val) {
                        if (val.length != 10) {
                          return ('Enter valid phone number');
                        }
                      },
                      isNumberField: true,
                    ),
                    codeSent
                        ? CustomInput(
                            hintText: 'Enter the OTP...',
                            onChanged: (val) {
                              setState(() {
                                smsCode = val;
                              });
                            },
                            validator: (val) {
                              if (val.length < 6) {
                                return ('Enter valid otp');
                              }
                            },
                            isNumberField: true,
                          )
                        : Container(),
                  ],
                ),
                CustomBtn(
                    isLoading: loading,
                    text: codeSent ? 'Login' : 'Verify',
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        codeSent
                            ? AuthService()
                                .signInWithOTP(smsCode, verificationId)
                            : verifyPhone('+91$phoneNo');
                      }
                    }),
              ],
            ),
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    loading = true;
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        this.loading = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
