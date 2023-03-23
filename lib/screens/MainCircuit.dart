import 'dart:ffi';
import 'package:final_project_flutter/main.dart';
import 'package:final_project_flutter/model/circuit.dart';
import 'package:final_project_flutter/screens/DashBoard.dart';
import 'package:final_project_flutter/screens/Setting.dart';
import 'package:final_project_flutter/screens/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dots_indicator/dots_indicator.dart';

class MainCircuit extends StatefulWidget {
  const MainCircuit({super.key});

  @override
  State<MainCircuit> createState() => _MainCircuit();
}

class _MainCircuit extends State<MainCircuit> {
  late PageController _pageController = PageController(initialPage: 0);
  double _currentPosition = 0.0;
  final auth = FirebaseAuth.instance;
  late DatabaseReference c1;
  late DatabaseReference c2;
  late DatabaseReference c3;
  late DatabaseReference c4;
  late DatabaseReference c5;
  late DatabaseReference c6;
  late DatabaseReference c7;
  late DatabaseReference c8;
  late DatabaseReference c9;
  late DatabaseReference c10;
  late DatabaseReference settings;
  Object _data = {};
  Object _dataC2 = {};
  Object _dataC3 = {};
  Object _dataC4 = {};
  Object _dataC5 = {};
  Object _dataC6 = {};
  Object _dataC7 = {};
  Object _dataC8 = {};
  Object _dataC9 = {};
  Object _dataC10 = {};
  int _status = 0;
  num _volt = 0.0;
  num _watt = 0.0;
  num _amp = 0.0;
  num _watt2 = 0.0;
  num _amp2 = 0.0;
  num _watt3 = 0.0;
  num _amp3 = 0.0;
  num _watt4 = 0.0;
  num _amp4 = 0.0;
  num _watt5 = 0.0;
  num _amp5 = 0.0;
  num _watt6 = 0.0;
  num _amp6 = 0.0;
  num _watt7 = 0.0;
  num _amp7 = 0.0;
  num _watt8 = 0.0;
  num _amp8 = 0.0;
  num _watt9 = 0.0;
  num _amp9 = 0.0;
  num _watt10 = 0.0;
  num _amp10 = 0.0;
  int _status2 = 0;
  int _status3 = 0;
  int _status4 = 0;
  int _status5 = 0;
  int _status6 = 0;
  int _status7 = 0;
  int _status8 = 0;
  int _status9 = 0;
  int _status10 = 0;

  late List<Circuit> circuit = [
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 1'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 2'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 3'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 4'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 5'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 6'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 7'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 8'),
    Circuit(
        title: 'ชื่อห้อง',
        ampLimit: 0,
        dateReset: '',
        voltLimit: 0,
        wattLimit: 0,
        status: 0,
        subtitle: 'เซอร์กิตที่ 9')
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c1 = FirebaseDatabase.instance.ref('C1');
    c2 = FirebaseDatabase.instance.ref('C2');
    c3 = FirebaseDatabase.instance.ref('C3');
    c4 = FirebaseDatabase.instance.ref('C4');
    c5 = FirebaseDatabase.instance.ref('C5');
    c6 = FirebaseDatabase.instance.ref('C6');
    c7 = FirebaseDatabase.instance.ref('C7');
    c8 = FirebaseDatabase.instance.ref('C8');
    c9 = FirebaseDatabase.instance.ref('C9');
    c10 = FirebaseDatabase.instance.ref('C10');
    settings = FirebaseDatabase.instance.ref('settings');

    c1.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _volt = (event.snapshot.value as Map)['Voltage']!;
      });
    });

    c2.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt2 = (event.snapshot.value as Map)["Power"]!;
        _amp2 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status2 = (event.snapshot.value as Map)["status"]!;
      });
      print(_watt);
      print(_amp);
    });

    c3.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt3 = (event.snapshot.value as Map)["Power"]!;
        _amp3 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status3 = (event.snapshot.value as Map)["status"]!;
      });
      print(_watt);
      print(_amp);
    });

    c4.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt4 = (event.snapshot.value as Map)["Power"]!;
        _amp4 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status4 = (event.snapshot.value as Map)["status"]!;
      });
      print(_watt);
      print(_amp);
    });

    c5.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt5 = (event.snapshot.value as Map)["Power"]!;
        _amp5 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status5 = (event.snapshot.value as Map)["status"]!;
      });
    });

    c6.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt6 = (event.snapshot.value as Map)["Power"]!;
        _amp6 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status6 = (event.snapshot.value as Map)["status"]!;
      });
    });

    c7.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt7 = (event.snapshot.value as Map)["Power"]!;
        _amp7 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status7 = (event.snapshot.value as Map)["status"]!;
      });
    });

    c8.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt8 = (event.snapshot.value as Map)["Power"]!;
        _amp8 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status8 = (event.snapshot.value as Map)["status"]!;
      });
    });

    c9.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt9 = (event.snapshot.value as Map)["Power"]!;
        _amp9 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status9 = (event.snapshot.value as Map)["status"]!;
      });
    });

    c10.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _data = event.snapshot.value!;
        print(_data);
        _watt10 = (event.snapshot.value as Map)["Power"]!;
        _amp10 = (event.snapshot.value as Map)["Current"]!;
        _watt = (_watt3 +
            _watt4 +
            _watt2 +
            _watt5 +
            _watt6 +
            _watt7 +
            _watt8 +
            _watt9 +
            _watt10);
        _amp = (_amp3 +
            _amp4 +
            _amp2 +
            _amp5 +
            _amp6 +
            _amp7 +
            _amp8 +
            _amp9 +
            _amp10);
        _status10 = (event.snapshot.value as Map)["status"]!;
      });
    });

    settings.onValue.listen((DatabaseEvent event) {
      // ignore: avoid_print
      print(event.snapshot.value);
      setState(() {
        _dataC2 = (event.snapshot.value as Map)['C2'];
        _dataC3 = (event.snapshot.value as Map)['C3'];
        _dataC4 = (event.snapshot.value as Map)['C4'];
        _dataC5 = (event.snapshot.value as Map)['C5'];
        _dataC6 = (event.snapshot.value as Map)['C6'];
        _dataC7 = (event.snapshot.value as Map)['C7'];
        _dataC8 = (event.snapshot.value as Map)['C8'];
        _dataC9 = (event.snapshot.value as Map)['C9'];
        _dataC10 = (event.snapshot.value as Map)['C10'];
        print((_dataC2 as Map)['title']);
        print((_dataC3 as Map)['title']);
        print((_dataC4 as Map)['title']);
        print((_dataC5 as Map)['title']);
        print((_dataC6 as Map)['title']);
        circuit[0] = Circuit(
            title: (_dataC2 as Map)['title'],
            ampLimit: (_dataC2 as Map)['ampLimit'],
            dateReset: (_dataC2 as Map)['dateReset'],
            voltLimit: (_dataC2 as Map)['voltLimit'],
            wattLimit: (_dataC2 as Map)['wattLimit'],
            status: (_dataC2 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 1');
        circuit[1] = Circuit(
            title: (_dataC3 as Map)['title'],
            ampLimit: (_dataC3 as Map)['ampLimit'],
            dateReset: (_dataC3 as Map)['dateReset'],
            voltLimit: (_dataC3 as Map)['voltLimit'],
            wattLimit: (_dataC3 as Map)['wattLimit'],
            status: (_dataC3 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 2');
        circuit[2] = Circuit(
            title: (_dataC4 as Map)['title'],
            ampLimit: (_dataC4 as Map)['ampLimit'],
            dateReset: (_dataC4 as Map)['dateReset'],
            voltLimit: (_dataC4 as Map)['voltLimit'],
            wattLimit: (_dataC4 as Map)['wattLimit'],
            status: (_dataC4 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 3');
        circuit[3] = Circuit(
            title: (_dataC5 as Map)['title'],
            ampLimit: (_dataC5 as Map)['ampLimit'],
            dateReset: (_dataC5 as Map)['dateReset'],
            voltLimit: (_dataC5 as Map)['voltLimit'],
            wattLimit: (_dataC5 as Map)['wattLimit'],
            status: (_dataC5 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 4');
        circuit[4] = Circuit(
            title: (_dataC6 as Map)['title'],
            ampLimit: (_dataC6 as Map)['ampLimit'],
            dateReset: (_dataC6 as Map)['dateReset'],
            voltLimit: (_dataC6 as Map)['voltLimit'],
            wattLimit: (_dataC6 as Map)['wattLimit'],
            status: (_dataC6 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 5');
        circuit[5] = Circuit(
            title: (_dataC7 as Map)['title'],
            ampLimit: (_dataC7 as Map)['ampLimit'],
            dateReset: (_dataC7 as Map)['dateReset'],
            voltLimit: (_dataC7 as Map)['voltLimit'],
            wattLimit: (_dataC7 as Map)['wattLimit'],
            status: (_dataC7 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 6');
        circuit[6] = Circuit(
            title: (_dataC8 as Map)['title'],
            ampLimit: (_dataC8 as Map)['ampLimit'],
            dateReset: (_dataC8 as Map)['dateReset'],
            voltLimit: (_dataC8 as Map)['voltLimit'],
            wattLimit: (_dataC8 as Map)['wattLimit'],
            status: (_dataC8 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 7');
        circuit[7] = Circuit(
            title: (_dataC9 as Map)['title'],
            ampLimit: (_dataC9 as Map)['ampLimit'],
            dateReset: (_dataC9 as Map)['dateReset'],
            voltLimit: (_dataC9 as Map)['voltLimit'],
            wattLimit: (_dataC9 as Map)['wattLimit'],
            status: (_dataC9 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 8');
        circuit[8] = Circuit(
            title: (_dataC10 as Map)['title'],
            ampLimit: (_dataC10 as Map)['ampLimit'],
            dateReset: (_dataC10 as Map)['dateReset'],
            voltLimit: (_dataC10 as Map)['voltLimit'],
            wattLimit: (_dataC10 as Map)['wattLimit'],
            status: (_dataC10 as Map)['status'],
            subtitle: 'เซอร์กิตที่ 9');
      });
      print(circuit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text("${auth.currentUser?.displayName}")),
          // Center(child: Text("${auth.currentUser?.email}")),
        ],
      )),
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Drawer(
            child: Scaffold(
                appBar: AppBar(title: const Text("เมนู")),
                body: Column(
                  children: [
                    SizedBox(
                      height: 400,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (value) => setState(() {
                          _currentPosition = value.toDouble();
                        }),
                        children: [
                          ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              Circuit data = circuit[index];
                              int status = 0;
                              switch (index) {
                                case 0:
                                  {
                                    status = _status2;
                                    break;
                                  }
                                case 1:
                                  {
                                    status = _status3;
                                    break;
                                  }
                                case 2:
                                  {
                                    status = _status4;
                                    break;
                                  }
                                case 3:
                                  {
                                    status = _status5;
                                    break;
                                  }
                                case 4:
                                  {
                                    status = _status6;
                                    break;
                                  }
                                default:
                                  {
                                    status = 3;
                                  }
                              }
                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: ListTile(
                                    tileColor: Colors.cyan[100],
                                    title: Text(data.title,
                                        style: const TextStyle(
                                            color: Color(0xff7364FF))),
                                    subtitle: Text(data.subtitle),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: status == 0
                                                  ? Colors.red
                                                  : status == 3
                                                      ? Colors.grey
                                                      : Colors.green,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Setting(
                                                      index: index,
                                                      title: data.title);
                                                }));
                                              },
                                              icon: const Icon(Icons.edit))
                                        ]),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Dashboard(index: index);
                                      }));
                                    }),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              Circuit data = circuit[index + 5];
                              int status = 0;
                              switch (index + 5) {
                                case 5:
                                  {
                                    status = _status7;
                                    break;
                                  }
                                case 6:
                                  {
                                    status = _status8;
                                    break;
                                  }
                                case 7:
                                  {
                                    status = _status9;
                                    break;
                                  }
                                case 8:
                                  {
                                    status = _status10;
                                    break;
                                  }
                                default:
                                  {
                                    status = 3;
                                  }
                              }

                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: ListTile(
                                    tileColor: Colors.cyan[100],
                                    title: Text(data.title,
                                        style: const TextStyle(
                                            color: Color(0xff7364FF))),
                                    subtitle: Text(data.subtitle),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: status == 0
                                                  ? Colors.red
                                                  : status == 3
                                                      ? Colors.grey
                                                      : Colors.green,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Setting(
                                                    index: index + 5,
                                                    title: data.title,
                                                  );
                                                }));
                                              },
                                              icon: const Icon(Icons.edit))
                                        ]),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Dashboard(index: index + 5);
                                      }));
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    DotsIndicator(
                        dotsCount: 2,
                        position: _currentPosition,
                        decorator: const DotsDecorator(
                            color: Colors.grey, activeColor: Colors.red),
                        onTap: (position) => setState(() {
                              _currentPosition = position;
                              _pageController.animateToPage(position.toInt(),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            }))
                  ],
                ))),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text("เซอร์กิตหลัก",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, color: Colors.black)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text("${_volt.toStringAsFixed(0)} V",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      backgroundColor: Colors.grey.shade400)),
              Text("${_amp.toStringAsFixed(2)} A",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      backgroundColor: Colors.grey.shade400)),
              Text("${_watt.toStringAsFixed(0)} W",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      backgroundColor: Colors.grey.shade400)),
            ]),
            TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Color(0xff7364FF)),
              child: const Text(
                'ลงชื่อออก',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              onPressed: () {
                auth.signOut().then((value) {
                  Fluttertoast.showToast(
                    msg: "Logged Out",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
