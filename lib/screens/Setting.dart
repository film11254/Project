import 'package:final_project_flutter/screens/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/profile.dart';

// ignore: must_be_immutable
class Setting extends StatefulWidget {
  Setting({super.key, required this.index, required this.title});
  final int index;
  final String title;
  @override
  State<Setting> createState() => _Setting(index, title);
}

// ignore: unused_element
class _Setting extends State<Setting> {
  _Setting(this.index, this.title);
  final int index;
  String title;
  List<TextEditingController> textEditingControllersTitle = [];
  List<TextEditingController> textEditingControllersMin = [];
  List<TextEditingController> textEditingControllersMax = [];

  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(username: '', email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  late DatabaseReference setting;
  late DatabaseReference devices;

  late List<Object> _devices = [];

  late List<Object> _devicesTemp = [];

  @override
  void initState() {
    super.initState();

    switch (index) {
      case 0:
        setting = FirebaseDatabase.instance.ref('settings/C2');
        devices = FirebaseDatabase.instance.ref('settings/C2/devices');
        break;
      case 1:
        setting = FirebaseDatabase.instance.ref('settings/C3');
        devices = FirebaseDatabase.instance.ref('settings/C3/devices');
        break;
      case 2:
        setting = FirebaseDatabase.instance.ref('settings/C4');
        devices = FirebaseDatabase.instance.ref('settings/C4/devices');
        break;
      case 3:
        setting = FirebaseDatabase.instance.ref('settings/C5');
        devices = FirebaseDatabase.instance.ref('settings/C5/devices');
        break;
      case 4:
        setting = FirebaseDatabase.instance.ref('settings/C6');
        devices = FirebaseDatabase.instance.ref('settings/C6/devices');
        break;
      case 5:
        setting = FirebaseDatabase.instance.ref('settings/C7');
        devices = FirebaseDatabase.instance.ref('settings/C7/devices');
        break;
      case 6:
        setting = FirebaseDatabase.instance.ref('settings/C8');
        devices = FirebaseDatabase.instance.ref('settings/C8/devices');
        break;
      case 7:
        setting = FirebaseDatabase.instance.ref('settings/C9');
        devices = FirebaseDatabase.instance.ref('settings/C9/devices');
        break;
      case 8:
        setting = FirebaseDatabase.instance.ref('settings/C10');
        devices = FirebaseDatabase.instance.ref('settings/C10/devices');
        break;
      default:
        setting = FirebaseDatabase.instance.ref('settings/C2');
        devices = FirebaseDatabase.instance.ref('settings/C2/devices');
    }

    print(setting);

    setting.onValue.listen((DatabaseEvent event) {
      if (!mounted) {
        return;
      }
      print(event.snapshot.value);
      setState(() {
        _devicesTemp = [];
        title = (event.snapshot.value as Map)['title'];
        print(_devices);
        _devices = (event.snapshot.value as Map)['devices'];
        if (_devices == null) {
          setState(() {
            _devicesTemp.add({'minWatt': 0, 'title': '', 'maxWatt': 0});
          });
        } else {
          _devices.forEach((element) {
            setState(() {
              _devicesTemp.add(element);
            });
          });
        }
        _devicesTemp.forEach((i) {
          var textEditingControllerTitle =
              TextEditingController(text: (i as Map)['title']);
          var textEditingControllerMin =
              TextEditingController(text: (i as Map)['minWatt'].toString());
          var textEditingControllerMax =
              TextEditingController(text: (i as Map)['maxWatt'].toString());
          textEditingControllersTitle.add(textEditingControllerTitle);
          textEditingControllersMin.add(textEditingControllerMin);
          textEditingControllersMax.add(textEditingControllerMax);
        });

        //print(textEditingControllersTitle);
      });

      //print(textEditingControllersTitle);
      print(_devicesTemp);
      print(title);
      //print(_devices);
      // set TextEditingController
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ตั้งค่า")),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Text('ตั้งชื่อห้อง'),
                margin: EdgeInsets.only(bottom: 10, top: 10),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
                initialValue: title.toString(),
                validator: RequiredValidator(errorText: "กรุณากรอกข้อมูล"),
                decoration: InputDecoration(
                    // labelText: "Username",
                    contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7364FF))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                onSaved: (String? username) {
                  profile.username = username!;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  child: Row(
                    children: const [
                      Flexible(
                          flex: 50,
                          child: Text(
                            'กำหนดอุปกรณ์ภายในห้อง',
                            style: TextStyle(fontSize: 12),
                          )),
                      Spacer(
                        flex: 2,
                      ),
                      Flexible(
                          flex: 50,
                          child: Text('กำลังวัตต์ของอุปกรณ์',
                              style: TextStyle(fontSize: 12)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Column(
                    children: _devicesTemp
                        .asMap()
                        .entries
                        .map((i) => i != null
                            ? Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 50,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              (i.value as Map)['title'] = value;
                                            });
                                          },
                                          controller:
                                              textEditingControllersTitle[
                                                  i.key],
                                          validator: RequiredValidator(
                                              errorText:
                                                  'กรุณากรอกชื่ออุปกรณ์'),
                                          decoration: InputDecoration(
                                              // labelText: "Username",
                                              hintText: 'ชื่ออุปกรณ์',
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(0xff7364FF))),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 0, 12, 0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              )),
                                        )),
                                    Spacer(flex: 5),
                                    Flexible(
                                        flex: 25,
                                        child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                (i.value as Map)['minWatt'] =
                                                    int.parse(value);
                                              });
                                            },
                                            controller:
                                                textEditingControllersMin[
                                                    i.key],
                                            decoration: InputDecoration(
                                                hintText: 'MIN',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff7364FF))),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )))),
                                    Text('-', style: TextStyle(fontSize: 20)),
                                    Flexible(
                                        flex: 25,
                                        child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                (i.value as Map)['maxWatt'] =
                                                    int.parse(value);
                                              });
                                            },
                                            controller:
                                                textEditingControllersMax[
                                                    i.key],
                                            decoration: InputDecoration(
                                                hintText: 'MAX',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff7364FF))),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )))),
                                    Spacer(),
                                    Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color:
                                              i.key + 1 == _devicesTemp.length
                                                  ? Colors.green
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.all(1),
                                          icon: Icon(
                                              i.key + 1 == _devicesTemp.length
                                                  ? Icons.add
                                                  : Icons.remove),
                                          color: Colors.white,
                                          onPressed: () {
                                            if (i.key + 1 !=
                                                _devicesTemp.length) {
                                              setState(() {
                                                _devicesTemp.removeAt(i.key);
                                                textEditingControllersTitle
                                                    .removeAt(i.key);
                                                textEditingControllersMin
                                                    .removeAt(i.key);
                                                textEditingControllersMax
                                                    .removeAt(i.key);
                                              });

                                              print(_devicesTemp);
                                              print(i.key);
                                            } else {
                                              if ((_devicesTemp[
                                                      _devicesTemp.length -
                                                          1] as Map)['title']
                                                  .toString()
                                                  .isNotEmpty) {
                                                setState(() {
                                                  _devicesTemp.add({
                                                    'minWatt': 0,
                                                    'title': '',
                                                    'maxWatt': 0
                                                  });
                                                  var textEditingControllerTitle =
                                                      TextEditingController(
                                                          text: '');
                                                  textEditingControllersTitle.add(
                                                      textEditingControllerTitle);

                                                  var textEditingControllerMin =
                                                      TextEditingController(
                                                          text: '0');
                                                  textEditingControllersMin.add(
                                                      textEditingControllerMin);

                                                  var textEditingControllerMax =
                                                      TextEditingController(
                                                          text: '0');
                                                  textEditingControllersMax.add(
                                                      textEditingControllerMax);
                                                });
                                              }
                                            }
                                          },
                                        )),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink())
                        .toList()),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Color(0xff7364FF)),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () async {
                  _devicesTemp.removeWhere(
                      (item) => [""].contains((item as Map)['title']));
                  for (int i = 0; i < _devicesTemp.length; i++) {
                    if ((_devicesTemp[i] as Map)['title'] == '') {
                      setState(() {
                        textEditingControllersTitle.removeAt(i);
                        textEditingControllersMin.removeAt(i);
                        textEditingControllersMax.removeAt(i);
                      });
                    }
                  }
                  try {
                    await setting.update({'title': title}).then(
                        (value) => devices.set(_devicesTemp).then((value) {
                              Fluttertoast.showToast(
                                msg: "บันทึกข้อมูลสำเร็จ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }));

                    print(_devicesTemp);

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
                },
              ),
              const Image(image: AssetImage("assets/images/bg.png"))
            ],
          ),
        ),
      ),
    );
  }
}
