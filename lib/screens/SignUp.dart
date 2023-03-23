import 'package:final_project_flutter/screens/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/profile.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

// ignore: unused_element
class _SignUp extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(username: '', email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("error")),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: const Text("สมัครสมาชิก")),
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Text('ชื่อผู้ใช้งาน'),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      TextFormField(
                        validator:
                            RequiredValidator(errorText: "กรุณากรอกข้อมูล"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff7364FF))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onSaved: (String? username) {
                          profile.username = username!;
                        },
                      ),
                      Container(
                        child: Text('อีเมล'),
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณากรอกข้อมูล"),
                          EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                        ]),
                        onSaved: (String? email) {
                          profile.email = email!;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff7364FF))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                      Container(
                        child: Text('รหัสผ่าน'),
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff7364FF))),
                            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: GestureDetector(
                                    onTap: _toggle,
                                    child: Icon(
                                        _obscureText
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        size: 24)))),
                        validator:
                            RequiredValidator(errorText: "กรุณากรอกข้อมูล"),
                        obscureText: _obscureText,
                        onSaved: (String? password) {
                          profile.password = password!;
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Color(0xff7364FF)),
                        child: const Text(
                          'สมัครสมาชิก',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: profile.email,
                                      password: profile.password)
                                  .then((userCredential) {
                                // ignore: avoid_print
                                print(userCredential);
                                //userCredential
                                return userCredential.user
                                    ?.updateDisplayName(profile.username);
                              }).then((value) {
                                Fluttertoast.showToast(
                                  msg: "Signu Up Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SignIn();
                                }));
                              });

                              formKey.currentState?.reset();
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                              Fluttertoast.showToast(
                                msg: "${e.message}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }

                          print(
                              "email = ${profile.email} passowrd = ${profile.password} username = ${profile.username}");
                        },
                      ),
                      const Image(image: AssetImage("assets/images/bg.png"))
                    ],
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
          ;
        });
  }
}
