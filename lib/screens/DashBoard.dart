// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'dart:ffi';
import 'package:day/day.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:final_project_flutter/model/device.dart';
import 'package:final_project_flutter/screens/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../model/profile.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.index});
  final int index;
  @override
  // ignore: no_logic_in_create_state
  State<Dashboard> createState() => _Dashboard(index);
}

// ignore: unused_element
class _Dashboard extends State<Dashboard> {
  _Dashboard(this.index);
  final int index;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  late PageController _pageController = PageController(initialPage: 0);
  dynamic _currentPosition = 0.0;

  num _volt = 0.0;
  num _watt = 0.0;
  num _amp = 0.0;
  num _energy = 0;
  int _isOn = 0;
  late String _title = "";

  final day = Day();

  var _voltLimit = 0;
  var _wattLimit = 0;
  var _ampLimit = 0;
  double _ft = -0.116;
  String _dateReset = '1';
  int _energyHour = 0;
  int _energyDay = 0;
  int _energyMonth = 0;
  int _energyYear = 0;
  double vat = 1.07;
  double service = 24.62; //ค่าบริการ

  double _total = 0.0;

  Profile profile = Profile(username: '', email: '', password: '');
  late DatabaseReference c;
  late DatabaseReference setting;
  late DatabaseReference log = FirebaseDatabase.instance.ref('logs');
  String _dropdownValue1 = 'รายชั่วโมง';
  String _dropdownValue2 = '1';

  var items1 = [
    'รายชั่วโมง',
    'รายวัน',
    'รายเดือน',
    'รายปี',
  ];

  var items2 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
  ];

  late List<Object> _devices = [];

  @override
  void initState() {
    super.initState();

    print(day.year());
    print(day.month());
    print(day.get('date'));
    print(day.hour());

    switch (index) {
      case 0:
        c = FirebaseDatabase.instance.ref('C2');
        setting = FirebaseDatabase.instance.ref('settings/C2');
        break;
      case 1:
        c = FirebaseDatabase.instance.ref('C3');
        setting = FirebaseDatabase.instance.ref('settings/C3');
        break;
      case 2:
        c = FirebaseDatabase.instance.ref('C4');
        setting = FirebaseDatabase.instance.ref('settings/C4');
        break;
      case 3:
        c = FirebaseDatabase.instance.ref('C5');
        setting = FirebaseDatabase.instance.ref('settings/C5');
        break;
      case 4:
        c = FirebaseDatabase.instance.ref('C6');
        setting = FirebaseDatabase.instance.ref('settings/C6');
        break;
      case 5:
        c = FirebaseDatabase.instance.ref('C7');
        setting = FirebaseDatabase.instance.ref('settings/C7');
        break;
      case 6:
        c = FirebaseDatabase.instance.ref('C8');
        setting = FirebaseDatabase.instance.ref('settings/C8');
        break;
      case 7:
        c = FirebaseDatabase.instance.ref('C9');
        setting = FirebaseDatabase.instance.ref('settings/C9');
        break;
      case 8:
        c = FirebaseDatabase.instance.ref('C10');
        setting = FirebaseDatabase.instance.ref('settings/C10');
        break;
      default:
        c = FirebaseDatabase.instance.ref('C2');
        setting = FirebaseDatabase.instance.ref('settings/C2');
    }

    print(c);
    print(setting);
    print(index);

    c.onValue.listen((DatabaseEvent event) {
      if (!mounted) {
        return;
      }
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _volt = (event.snapshot.value as Map)['Voltage'];
        _watt = (event.snapshot.value as Map)['Power'];
        //_watt = _watt * 10000.0;
        print(_watt);
        _amp = (event.snapshot.value as Map)['Current'];
        _energy = (event.snapshot.value as Map)['Energy'];
        _isOn = (event.snapshot.value as Map)['status'];
      });
    });
    setting.onValue.listen((DatabaseEvent event) {
      if (!mounted) {
        return;
      }
      print(event.snapshot.value);
      setState(() {
        _title = (event.snapshot.value as Map)['title'];
        _devices = (event.snapshot.value as Map)['devices'];
        _ampLimit = (event.snapshot.value as Map)['ampLimit'];
        _voltLimit = (event.snapshot.value as Map)['voltLimit'];
        _wattLimit = (event.snapshot.value as Map)['wattLimit'];
        _dateReset = (event.snapshot.value as Map)['dateReset'];
      });
      print(_devices);
    });

    getEnery();
  }

  Future getEnery() {
    return log.once().then((event) {
      setState(() {
        _energyHour = day.hour() == 0
            ? (event.snapshot.value as Map)['${day.year()}'][day.month()]
                [day.get('date')! - 1][23][c.path]
            : (event.snapshot.value as Map)['${day.year()}'][day.month()]
                [day.get('date')][day.hour() - 1][c.path];
        _energyHour = _energy.toInt() - _energyHour;
        print(_energyHour);

        if (day.hour() == 0) {
          _energyDay = _energy.toInt();
        } else {
          int total = 0;
          dynamic temp = (event.snapshot.value as Map)['${day.year()}']
              [day.month()][day.get('date')];
          for (var i in temp) {
            int temp = (i as Map)[c.path];
            total = total + temp;
          }
          print(temp);
          _energyDay = total;
        }
        int totalMonth = 0;

        try {
          if ((event.snapshot.value as Map)['${day.year()}'][day.month() - 1] ==
              null) {
            if (int.parse(_dateReset) <= day.get('date')!) {
              for (int i = int.parse(_dateReset); i <= day.get('date')!; i++) {
                if ((event.snapshot.value as Map)['${day.year()}'][day.month()]
                        [i] !=
                    null) {
                  if (i == day.get('date')!) {
                    totalMonth = totalMonth + _energy.toInt();
                  } else {
                    for (int j = 0; j < 24; j++) {
                      dynamic temp = (event.snapshot.value
                          as Map)['${day.year()}'][day.month()][i][j];
                      int tempHour = (temp as Map)[c.path];

                      totalMonth = totalMonth + tempHour;
                    }
                  }
                }
              }
              _energyMonth = totalMonth;
            } else {}
          } else {
            for (int i = int.parse(_dateReset); i <= 31; i++) {
              if ((event.snapshot.value as Map)['${day.year()}']
                      [day.month() - 1][i] !=
                  null) {
                for (int j = 0; j < 24; j++) {
                  dynamic temp = (event.snapshot.value as Map)['${day.year()}']
                      [day.month() - 1][i][j];
                  int tempHour = (temp as Map)[c.path];

                  totalMonth = totalMonth + tempHour;
                }
              }
            }
            for (int i = 1; i <= int.parse(_dateReset); i++) {
              if ((event.snapshot.value as Map)['${day.year()}']
                      [day.month() - 1][i] !=
                  null) {
                if (i == day.get('date')!) {
                  totalMonth = totalMonth + _energy.toInt();
                } else {
                  for (int j = 0; j < 24; j++) {
                    if ((event.snapshot.value as Map)['${day.year()}'][i - 1] !=
                        null) {
                      dynamic temp = (event.snapshot.value
                          as Map)['${day.year()}'][day.month()][i - 1][j];
                      int tempHour = (temp as Map)[c.path];

                      totalMonth = totalMonth + tempHour;
                    }
                  }
                }
              }
            }

            _energyMonth = totalMonth;
          }
        } catch (e) {}
        print(totalMonth);

        int totalYear = 0;

        try {
          for (int i = 0; i < 12; i++) {
            print((event.snapshot.value as Map)['${day.year()}']);
            if ((event.snapshot.value as Map)['${day.year()}'][i] != null) {
              for (int j = 0; j < 31; j++) {
                if ((event.snapshot.value as Map)['${day.year()}'][i][j] !=
                    null) {
                  for (int k = 0; k < 24; k++) {
                    if ((event.snapshot.value as Map)['${day.year()}'][i][j]
                            [k] !=
                        null) {
                      dynamic temp = (event.snapshot.value
                          as Map)['${day.year()}'][i][j][k];
                      int tempHour = (temp as Map)[c.path];

                      totalYear = totalYear + tempHour;
                    }
                  }
                }
              }
            }
          }
        } catch (e) {}

        print(totalYear);
        _energyYear = totalYear;
      });
    });
  }

  void setTotal() {
    setState(() {
      _total = 0.0;
    });
    if (_dropdownValue1 == 'รายชั่วโมง') {
      setState(() {
        int temp = _energyHour;
        if (_energyHour >= 150) {
          _total = _total + 150 * 3.2484;
          temp = temp - 150;
          print('150 >= ${_total}');
          if (_energyHour >= 151 && _energyHour <= 400) {
            _total = _total + ((temp * 4.2218));
            print('150 >= =< 400 ${_total}');
          }
          if (_energyHour >= 151 && _energyHour >= 401) {
            _total = _total + ((250 * 4.2218));
            temp = temp - 250;
          }
          if (_energyHour >= 401) {
            _total = _total + ((temp * 4.4217));
          }
        } else {
          _total = _total + temp * 3.2484;
        }

        _total = (_total + service + (_energyHour * _ft)) * vat;
      });
    } else if (_dropdownValue1 == 'รายวัน') {
      setState(() {
        int temp = _energyDay;
        if (_energyDay >= 150) {
          _total = _total + 150 * 3.2484;
          temp = temp - 150;
          print('150 >= ${_total}');
          if (_energyDay >= 151 && _energyDay <= 400) {
            _total = _total + ((temp * 4.2218));
            print('150 >= =< 400 ${_total}');
          }
          if (_energyDay >= 151 && _energyDay >= 401) {
            _total = _total + ((250 * 4.2218));
            temp = temp - 250;
          }
          if (_energyDay >= 401) {
            _total = _total + ((temp * 4.4217));
          }
        } else {
          _total = _total + temp * 3.2484;
        }

        _total = (_total + service + (_energyDay * _ft)) * vat;
      });
    } else if (_dropdownValue1 == 'รายเดือน') {
      setState(() {
        int temp = _energyMonth;
        if (_energyMonth >= 150) {
          _total = _total + 150 * 3.2484;
          temp = temp - 150;
          print('150 >= ${_total}');
          if (_energyMonth >= 151 && _energyMonth <= 400) {
            _total = _total + ((temp * 4.2218));
            print('150 >= =< 400 ${_total}');
          }
          if (_energyMonth >= 151 && _energyMonth >= 401) {
            _total = _total + ((250 * 4.2218));
            temp = temp - 250;
          }
          if (_energyMonth >= 401) {
            _total = _total + ((temp * 4.4217));
          }
        } else {
          _total = _total + temp * 3.2484;
        }

        _total = (_total + service + (_energyMonth * _ft)) * vat;
      });
    } else {
      setState(() {
        int temp = _energyYear;
        if (_energyYear >= 150) {
          _total = _total + 150 * 3.2484;
          temp = temp - 150;
          print('150 >= ${_total}');
          if (_energyYear >= 151 && _energyYear <= 400) {
            _total = _total + ((temp * 4.2218));
            print('150 >= =< 400 ${_total}');
          }
          if (_energyYear >= 151 && _energyYear >= 401) {
            _total = _total + ((250 * 4.2218));
            temp = temp - 250;
          }
          if (_energyYear >= 401) {
            _total = _total + ((temp * 4.4217));
          }
        } else {
          _total = _total + temp * 3.2484;
        }

        _total = (_total + service + (_energyYear * _ft)) * vat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: Center(
            child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 420,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() {
                      _currentPosition = value.toDouble();
                    }),
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(
                                  axisLabelStyle: GaugeTextStyle(fontSize: 10),
                                  minimum: 0,
                                  maximum: 250,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        endValue: _volt.toDouble(),
                                        color: Colors.blue),
                                    // ignore: prefer_const_literals_to_create_immutables
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      value: _volt.toDouble(),
                                      needleColor: Colors.blue,
                                      knobStyle: KnobStyle(color: Colors.blue),
                                      needleEndWidth: 2,
                                    )
                                    // ignore: prefer_const_literals_to_create_immutables
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Text('Volt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                        angle: 90,
                                        positionFactor: 0.5),
                                    GaugeAnnotation(
                                        widget: Text(
                                            "${_volt.toStringAsFixed(2)} V",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                        angle: 90,
                                        positionFactor: 0.7)
                                  ])
                            ]),
                          ),
                          Expanded(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: SfRadialGauge(axes: <RadialAxis>[
                                      RadialAxis(
                                          axisLabelStyle:
                                              GaugeTextStyle(fontSize: 10),
                                          minimum: 0,
                                          maximum: 12500,
                                          ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: _watt.toDouble(),
                                                color: Colors.blue),
                                            // ignore: prefer_const_literals_to_create_immutables
                                          ],
                                          pointers: <GaugePointer>[
                                            NeedlePointer(
                                              value: _watt.toDouble(),
                                              needleColor: Colors.blue,
                                              knobStyle:
                                                  KnobStyle(color: Colors.blue),
                                              needleEndWidth: 2,
                                            )
                                            // ignore: prefer_const_literals_to_create_immutables
                                          ],
                                          annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Text('Watt',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                angle: 90,
                                                positionFactor: 0.5),
                                            GaugeAnnotation(
                                                widget: Text(
                                                    '${_watt.toString()} W',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                angle: 90,
                                                positionFactor: 0.7)
                                          ])
                                    ]),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: SfRadialGauge(axes: <RadialAxis>[
                                      RadialAxis(
                                          axisLabelStyle:
                                              GaugeTextStyle(fontSize: 10),
                                          minimum: 0,
                                          maximum: 50,
                                          ranges: <GaugeRange>[
                                            GaugeRange(
                                                startValue: 0,
                                                endValue: _amp.toDouble(),
                                                color: Colors.blue),
                                            // ignore: prefer_const_literals_to_create_immutables
                                          ],
                                          pointers: <GaugePointer>[
                                            NeedlePointer(
                                              value: _amp.toDouble(),
                                              needleColor: Colors.blue,
                                              knobStyle:
                                                  KnobStyle(color: Colors.blue),
                                              needleEndWidth: 2,
                                            )
                                            // ignore: prefer_const_literals_to_create_immutables
                                          ],
                                          annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                                widget: Text('Ampare',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                angle: 90,
                                                positionFactor: 0.5),
                                            GaugeAnnotation(
                                                widget: Text(
                                                    '${_amp.toDouble().toStringAsFixed(2)} A',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                angle: 90,
                                                positionFactor: 0.7)
                                          ])
                                    ]),
                                  )
                                ]),
                          ),
                          Align(
                            alignment: Alignment(0.7, 0.0),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                              child: IconButton(
                                icon: Icon(Icons.power_settings_new),
                                onPressed: () async {
                                  try {
                                    await c.update({
                                      "status": _isOn == 1 ? 0 : 1
                                    }).then((value) => Fluttertoast.showToast(
                                          msg: 'บันทึกข้อมูลเรียบร้อย',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        ));
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
                                color: _isOn == 1
                                    ? Colors.greenAccent
                                    : Colors.red,
                                iconSize: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('กำหนด Volt'),
                            ),
                            Form(
                              key: formKey1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 70,
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: false, decimal: false),
                                      onChanged: (value) {
                                        setState(() {
                                          _voltLimit = int.parse(value);
                                        });
                                      },
                                      initialValue: _voltLimit.toString(),
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff7364FF))),
                                          //labelText: "กำหนด Volt",
                                          hintText: 'ไม่เกิน 250 V',
                                          contentPadding:
                                              EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          )),
                                      validator: RangeValidator(
                                          min: 0,
                                          max: 250,
                                          errorText: 'กรุณากรอกค่า 0 - 250'),
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                      flex: 30,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor:
                                                  Color(0xff7364FF)),
                                          onPressed: () async {
                                            if (formKey1.currentState!
                                                .validate()) {
                                              formKey1.currentState?.save();
                                              try {
                                                await setting.update({
                                                  "voltLimit":
                                                      _voltLimit.toInt()
                                                }).then((value) {
                                                  formKey1.currentState
                                                      ?.reset();
                                                  return Fluttertoast.showToast(
                                                    msg:
                                                        'บันทึกข้อมูลเรียบร้อย',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                });
                                              } on FirebaseAuthException catch (e) {
                                                print(e.message);
                                                Fluttertoast.showToast(
                                                  msg: "${e.message}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'ok',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          )))
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('กำหนด Watt'),
                            ),
                            Form(
                              key: formKey2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 70,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            _wattLimit = int.parse(value);
                                          });
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: false),
                                        initialValue: _wattLimit.toString(),
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff7364FF))),
                                            // labelText: "กำหนด Watt",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 0, 12, 0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            hintText: 'ไม่เกิน 12500 W'),
                                        validator: RangeValidator(
                                            min: 0,
                                            max: 12500,
                                            errorText:
                                                'กรุณากรอกค่า 0 - 12500')),
                                  ),
                                  Spacer(),
                                  Flexible(
                                      flex: 30,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor:
                                                  Color(0xff7364FF)),
                                          onPressed: () async {
                                            if (formKey2.currentState!
                                                .validate()) {
                                              formKey2.currentState?.save();
                                              try {
                                                await setting.update({
                                                  "wattLimit":
                                                      _wattLimit.toInt()
                                                }).then((value) {
                                                  formKey2.currentState
                                                      ?.reset();
                                                  return Fluttertoast.showToast(
                                                    msg:
                                                        'บันทึกข้อมูลเรียบร้อย',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                });
                                              } on FirebaseAuthException catch (e) {
                                                print(e.message);
                                                Fluttertoast.showToast(
                                                  msg: "${e.message}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'ok',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          )))
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('กำหนด Ampere'),
                            ),
                            Form(
                              key: formKey3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 70,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            _ampLimit = int.parse(value);
                                          });
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: false),
                                        initialValue: _ampLimit.toString(),
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff7364FF))),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 0, 12, 0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            hintText: 'ไม่เกิน 50 A'),
                                        validator: RangeValidator(
                                            min: 0,
                                            max: 50,
                                            errorText: 'กรุณากรอกค่า 0 - 50')),
                                  ),
                                  Spacer(),
                                  Flexible(
                                      flex: 30,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor:
                                                  Color(0xff7364FF)),
                                          onPressed: () async {
                                            if (formKey3.currentState!
                                                .validate()) {
                                              formKey3.currentState?.save();
                                              try {
                                                await setting.update({
                                                  "ampLimit": _ampLimit.toInt()
                                                }).then((value) {
                                                  formKey3.currentState
                                                      ?.reset();
                                                  return Fluttertoast.showToast(
                                                    msg:
                                                        'บันทึกข้อมูลเรียบร้อย',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                });
                                              } on FirebaseAuthException catch (e) {
                                                print(e.message);
                                                Fluttertoast.showToast(
                                                  msg: "${e.message}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'ok',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          )))
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text('กำหนดค่า FT'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 70,
                                  child: TextFormField(
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.digitsOnly
                                    // ],
                                    onChanged: (value) {
                                      setState(() {
                                        _ft = double.parse(value);
                                      });
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    initialValue: _ft.toString(),
                                    decoration: InputDecoration(
                                        hintText: 'สตางค์',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 0, 12, 0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff7364FF))),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        )),
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                    flex: 30,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            backgroundColor: Color(0xff7364FF)),
                                        onPressed: () {
                                          getEnery().then((value) {
                                            setTotal();
                                          });
                                        },
                                        child: const Text(
                                          'ok',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        )))
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                  "จำนวนค่าไฟที่ใช้ ${_total.toStringAsFixed(2)} บาท",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    backgroundColor: Colors.grey.shade400,
                                  )),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Color(0xff7364FF),
                                        //border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          labelText: "เลือกรูปแบบการดูข้อมูล",
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff7364FF)),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        ),
                                        value: _dropdownValue1,
                                        items: items1.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _dropdownValue1 = newValue!;
                                          });
                                          getEnery().then((value) {
                                            setTotal();
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Color(0xff7364FF),
                                        //border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          labelText: "เลือกวันที่รีเซ็ทข้อมูล",
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        ),
                                        value: _dateReset,
                                        items: items2.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) async {
                                          setState(() {
                                            _dateReset = newValue!;
                                          });

                                          await setting.update({
                                            'dateReset': _dateReset
                                          }).then((value) =>
                                              Fluttertoast.showToast(
                                                msg: 'บันทึกข้อมูลเรียบร้อย',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              ));
                                        }),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                            child: Text('อุปกรณ์ที่กำลังใช้งานอยู่',
                                style: (TextStyle(fontSize: 24))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _devices
                                  .map((i) => i != null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text((i as Map)['title']),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _watt >= i['minWatt']
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                            _watt >= i['minWatt']
                                                ? Text('อาจจะกำลังทำงาน')
                                                : SizedBox.shrink(),
                                          ],
                                        )
                                      : SizedBox.shrink())
                                  .toList(),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                  "ค่ากำลังไฟฟ้า  ${_watt.toStringAsFixed(0)}  วัตต์",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.black,
                                      backgroundColor: Colors.grey.shade500)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DotsIndicator(
                    dotsCount: 3,
                    position: _currentPosition,
                    decorator: DotsDecorator(
                        color: Colors.grey, activeColor: Colors.red),
                    onTap: (position) => setState(() {
                          _currentPosition = position;
                          _pageController.animateToPage(position.toInt(),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }))
              ],
            ),
          ),
        )));
  }
}
