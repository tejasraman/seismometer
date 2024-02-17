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

    final file1 = await sftp.open('/home/tejas/risk.txt');
    final content1 = await file1.readBytes();
    final response1 = latin1.decode(content1);

    List x = [];
    x.add(response);
    x.add(response1);
    yield x;
  }
}

final broadcastStream = stream.asBroadcastStream(
  onCancel: (controller) {
    print('Stream paused');
    controller.pause();
  },
  onListen: (controller) async {
    if (controller.isPaused) {
      print('Stream resumed');
      controller.resume();
    }
  },
);

Stream<double> calculationStream =
    broadcastStream.map<double>((list1) => double.parse(list1.elementAt(0)));

double y = 0;

current_time() {
  var now = DateTime.now();
  var formatterTime = DateFormat('E, MMM d, y, h:m a');
  String actualTime = formatterTime.format(now);
  return actualTime;
}

_sshFunc(int x) async {
  if (x == 1) {
    final client = SSHClient(
      await SSHSocket.connect('localhost', 5001),
      username: 'tejas',
      onPasswordRequest: () => 'ramennoodles',
    );
    final recal = await client.run('/home/tejas/bin/recalibrate');
    print(utf8.decode(recal));
  } else if (x == 2) {
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

Stream<String> timestr() async* {
  Stream.periodic(Duration(milliseconds: 500), (_) {
    current_time();
  });
}

final stream = earthquakeData();
final time = timestr();

class MyAppSL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          labelSmall: const TextStyle(color: Colors.white),
          labelMedium: const TextStyle(color: Colors.white),
          labelLarge: const TextStyle(color: Colors.white),
          displaySmall: const TextStyle(color: Colors.white),
          displayMedium: const TextStyle(color: Colors.white),
          displayLarge: const TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.lighter,
          background: const Color(0xFF1F1E1E),
        ),
        fontFamily: 'Segoe UI Variable',
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Color(0xFF363636)),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Stack(
                        fit: StackFit.passthrough,
                        alignment: FractionalOffset.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Seismometer")),
                          Positioned(
                            right: 0.0,
                            child: Icon(Icons.usb, color: Color(0xFF14FF00)),
                          ),
                        ])),
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Expanded(
                  flex: 6,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color(0xFF363636)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Center(
                            child: SizedBox(
                              height: 360,
                              child: RealTimeGraph(
                                stream: calculationStream,
                                updateDelay: Duration(milliseconds: 10),
                                graphColor: Colors.white,
                                xAxisColor: Colors.white,
                                yAxisColor: Colors.white,
                              ),
                            ),
                          ))),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color(0xFF363636)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Center(
                              child: SizedBox(
                                  height: 360,
                                  child: Column(
                                    children: [
                                      Expanded(flex: 3, child: SizedBox()),
                                      Expanded(
                                        flex: 5,
                                        child: StreamBuilder(
                                          stream: broadcastStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                  '${snapshot.data.elementAt(0)}',
                                                  textScaleFactor: 5);
                                            } else {
                                              return Text(
                                                '00',
                                                textScaleFactor: 5,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              textScaleFactor: 1.9, "/1000")),
                                      Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            child: StreamBuilder(
                                              stream: broadcastStream,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                var x =
                                                    snapshot.data.elementAt(1);
                                                if (x == "High") {
                                                  return Text('${x}',
                                                      textScaleFactor: 1.5,
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFFF0000)));
                                                } else if (x == "Moderate") {
                                                  return Text('${x}',
                                                      textScaleFactor: 1.5,
                                                      style: TextStyle(
                                                          color: TinyColor
                                                                  .fromString(
                                                                      '#9B3F00')
                                                              .color));
                                                } else {
                                                  return Text('${x}',
                                                      textScaleFactor: 1.5,
                                                      style: TextStyle(
                                                          color: TinyColor
                                                                  .fromString(
                                                                      '#00791D')
                                                              .color));
                                                }
                                                ;
                                              },
                                            ),
                                          )),
                                      Expanded(flex: 3, child: SizedBox())
                                    ],
                                  ))))),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Color(0xFF363636)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    onPressed: () => _sshFunc(1),
                                    child: Center(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          Icon(
                                            Icons.rotate_left,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          Text("Recalibrate")
                                        ]))),
                                flex: 1),
                            Expanded(
                                child: TextButton(
                                    onPressed: () => _sshFunc(2),
                                    child: Center(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          Icon(
                                            Icons.terminal,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          Text(" Open SSH"),
                                        ]))),
                                flex: 1),
                            Expanded(
                                child: TextButton(
                                    onPressed: () => _sshFunc(3),
                                    child: Center(
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          Icon(
                                            Icons.power_settings_new,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          Text("Reboot")
                                        ]))),
                                flex: 1)
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
