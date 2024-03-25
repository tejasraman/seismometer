// Material pkg import
// Fluent icons and theming colors
// import 'package:dartssh2/dartssh2.dart';
import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:system_theme/system_theme.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher_string.dart';

/////////////////////////////////////////////////
// DO NOT USE HTTP OVERRIDES; ONLY FOR TESTING //
/////////////////////////////////////////////////

// class DevHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() async {
  // HttpOverrides.global = DevHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((value) => runApp(MyAppSL()));
}

double z = 0;

Stream<List> earthquakeData() async* {
  final socket = await SSHSocket.connect('localhost', 5001);

  final client = SSHClient(socket,
      username: 'tejas', onPasswordRequest: () => 'ramennoodles');

  final sftp = await client.sftp();

  while (true) {
    await Future.delayed(const Duration(milliseconds: 5));

    final file = await sftp.open('/home/tejas/datapoint.txt');
    final content = await file.readBytes();
    final response = latin1.decode(content);

    if (response == "") {
      double response = 0.0;
    }

    final file1 = await sftp.open('/home/tejas/risk.txt');
    final content1 = await file1.readBytes();
    String response1 = (latin1.decode(content1)).toString();

    List x = [];
    x.add(response);

    if (response1.toString() == "3") {
      x.add("High");
    } else if (response1.toString() == "2") {
      x.add("Medium");
    } else {
      x.add("No Risk");
    }

    yield x;
  }
}

final broadcastStream = stream.asBroadcastStream(
  onCancel: (controller) {
    controller.pause();
  },
  onListen: (controller) async {
    if (controller.isPaused) {
      controller.resume();
    }
  },
);

Stream<double> calculationStream =
    broadcastStream.map<double>((list1) => double.parse(list1.elementAt(0)));

double y = 0;

_sshFunc(int x) async {
  if (x == 2) {
    String url = 'ssh://tejas@localhost:5001';
    await launchUrlString(url);
  } else if (x == 3) {
    final client = SSHClient(
      await SSHSocket.connect('localhost', 5001),
      username: 'tejas',
      onPasswordRequest: () => 'ramennoodles',
    );
    final recal = await client.run('sudo /home/tejas/rb');
    print(utf8.decode(recal));
  }
}

final stream = earthquakeData();

class CartesianSeis extends StatefulWidget {
  const CartesianSeis({super.key});

  @override
  State<CartesianSeis> createState() => _CartesianSeisState();
}

class _CartesianSeisState extends State<CartesianSeis> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyAppSL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme().copyWith(
            bodySmall: const TextStyle(color: Colors.black87),
            bodyMedium: const TextStyle(color: Colors.black87),
            bodyLarge: const TextStyle(color: Colors.black87),
            labelSmall: const TextStyle(color: Colors.black87),
            labelMedium: const TextStyle(color: Colors.black87),
            labelLarge: const TextStyle(color: Colors.black87),
            displaySmall: const TextStyle(color: Colors.black87),
            displayMedium: const TextStyle(color: Colors.black87),
            displayLarge: const TextStyle(color: Colors.black87),
          ),
          fontFamily: 'Segoe UI Variable',
          useMaterial3: true,
        ),
        home: Scaffold(
            body: Container(
          width: 1280,
          height: 800,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/BG_gradient.png"),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              child: Column(
                children: [
                  Expanded(
                    flex: 60,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Color(0xFFFFFFFF)),
                        child: Center(
                            child: Text(
                          "Graph:",
                          textScaleFactor: 1.15,
                          style: TextStyle(color: Colors.black87),
                        ))),
                  ),
                  Expanded(flex: 15, child: Container()),
                  Expanded(
                      flex: 480,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              color: Color(0xFFFFFFFF)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Center(
                                child: RealTimeGraph(
                                  stream: calculationStream,
                                  updateDelay: Duration(milliseconds: 25),
                                  graphColor: Colors.black,
                                  pointsSpacing: double.parse("1.0"),
                                  xAxisColor: Colors.black,
                                  yAxisColor: Colors.black,
                                ),
                              )))),
                  Expanded(flex: 15, child: Container()),
                  Expanded(
                    flex: 60,
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Center(
                                  child: Text(
                                "Value:",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              )))),
                      SizedBox(width: 15),
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Center(
                                  child: Text(
                                "Risk:",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              )))),
                      SizedBox(width: 15),
                      Expanded(
                          flex: 3,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Center(
                                  child: Text(
                                "Tools:",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              )))),
                    ]),
                  ),
                  Expanded(flex: 15, child: Container()),
                  Expanded(
                    flex: 220,
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Center(
                                  child: Column(children: [
                                StreamBuilder(
                                    stream: broadcastStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                            '${double.parse(snapshot.data.elementAt(0)).floor()}',
                                            textScaleFactor: 4.5);
                                      } else {
                                        return Text(
                                          '00',
                                          textScaleFactor: 4.5,
                                        );
                                      }
                                    }),
                                StreamBuilder(
                                  stream: broadcastStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          '.${((double.parse(snapshot.data.elementAt(0)) - double.parse(snapshot.data.elementAt(0)).floor()) * 10).floor()}',
                                          textScaleFactor: 2);
                                    } else {
                                      return Text(
                                        '00',
                                        textScaleFactor: 2,
                                      );
                                    }
                                  },
                                )
                              ])))),
                      SizedBox(width: 15),
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Center(
                                  child: StreamBuilder(
                                stream: broadcastStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  var x = snapshot.data.elementAt(1);
                                  if (x == "High") {
                                    return Text('${x}',
                                        textScaleFactor: 2,
                                        style: TextStyle(
                                            color: Color(0xFFFF0000)));
                                  } else if (x == "Medium") {
                                    return Text('${x}',
                                        textScaleFactor: 2,
                                        style: TextStyle(
                                            color:
                                                TinyColor.fromString('#9B3F00')
                                                    .color));
                                  } else {
                                    return Text('${x}',
                                        textScaleFactor: 2,
                                        style: TextStyle(
                                            color:
                                                TinyColor.fromString('#00791D')
                                                    .color));
                                  }
                                  ;
                                },
                              )))),
                      SizedBox(width: 15),
                      Expanded(
                          flex: 3,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFFFFFF)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () => _sshFunc(2),
                                              child: Center(
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                    Icon(
                                                      Icons.terminal,
                                                      color: Colors.black87,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      "  Open SSH",
                                                      textScaleFactor: 1.25,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ]))),
                                          flex: 1),
                                      Expanded(
                                          child: TextButton(
                                              onPressed: () => _sshFunc(3),
                                              child: Center(
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                    Icon(
                                                      Icons.power_settings_new,
                                                      color: Colors.black87,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      "  Reboot",
                                                      textScaleFactor: 1.25,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ]))),
                                          flex: 1)
                                    ],
                                  ))))
                    ]),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
