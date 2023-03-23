// ignore: file_names
import 'package:final_project_flutter/screens/MainCircuit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/profile.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(username: '', email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(title: const Text("error")),
                body: Center(child: Text("${snapshot.error}")));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: const Text("ลงชื่อเข้าใช้")),
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text("Welcome to electrical system",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 36, color: Color(0xff7364FF))),
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
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff7364FF))),
                            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                              borderRadius: BorderRadius.circular(8),
                            )),
                        validator:
                            RequiredValidator(errorText: "กรุณากรอกข้อมูล"),
                        obscureText: true,
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
                          'ลงชื่อเข้าใช้',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: profile.email,
                                      password: profile.password)
                                  .then((value) {
                                formKey.currentState?.reset();
                                Fluttertoast.showToast(
                                  msg: "Logged In",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MainCircuit();
                                }), (r) {
                                  return false;
                                });
                              });
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                              Fluttertoast.showToast(
                                msg:
                                    " อีเมลหรือรหัสผ่านของคุณไม่ถูกต้อง ", //${e.message}
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
                              "email = ${profile.email} passowrd = ${profile.password} ");
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
