// Material pkg import
// Fluent icons and theming colors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:real_time_chart/real_time_chart.dart';
// import 'package:system_theme/system_theme.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:system_theme/system_theme.dart';
import 'package:tinycolor2/tinycolor2.dart';

// class DevHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() {
  // HttpOverrides.global = DevHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom
  ]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((value) => runApp(MyApp()));
}

final stream = earthquakeData();
final stream_raw = earthquakeData_raw();
final risk_stream = riskAnalysis();
double z = 0;
Stream<double> earthquakeData() async* {
  // HttpOverrides.global = DevHttpOverrides();
  // Web API endpoint
  final url = 'http://192.168.137.2/datapoint.txt';

  while (true) {
    // Wait before next fetch
    await Future.delayed(Duration(milliseconds: 250));

    // Fetch latest data
    final response = await get(Uri.parse(url));
    print(response.body);
    // Yield fetched JSON data
    if (response.body != "") {
      yield double.parse(response.body);
      double z = double.parse(response.body);
    } else {
      yield z;
    }
  }
}

Stream<String> riskAnalysis() async* {
  // HttpOverrides.global = DevHttpOverrides();
  // Web API endpoint
  final url = 'http://192.168.137.2/risk.txt';

  while (true) {
    // Wait before next fetch
    await Future.delayed(Duration(milliseconds: 250));
    // Fetch latest data
    final response = await get(Uri.parse(url));
    int body = int.parse(response.body);

    if (body == 0) {
      yield ("High");
    } else if (body == 1) {
      yield ("Moderate");
    } else {
      yield ("No Risk");
    }
  }
}

double y = 0;
Stream<double> earthquakeData_raw() async* {
  // HttpOverrides.global = DevHttpOverrides();
  // Web API endpoint
  final url = 'http://192.168.137.2/datapoint.txt';

  while (true) {
    // Wait before next fetch
    await Future.delayed(Duration(milliseconds: 250));

    // Fetch latest data
    final response = await get(Uri.parse(url));

    if (response.body != "") {
      yield double.parse(response.body);
      double y = double.parse(response.body);
    } else {
      yield y;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.lighter,
          background: Color(0xFF1F1E1E),
        ),
        fontFamily: 'Segoe UI Variable',
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: TinyColor.fromColor(SystemTheme.accentColor.lighter)
              .tint(80)
              .color,
          elevation: 0.0,
          title: Text(
            "Earthquake Detector",
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 13),
          child: Column(
            children: [
              Row(
          children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: TinyColor.fromColor(SystemTheme.accentColor.lighter)
                      .tint(90)
                      .color,
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                        child: Column(children: [
                      Text(
                        "Data Graph:",
                        textScaleFactor: 2,
                      ),
                      SizedBox(
                        height: 200,
                        child: RealTimeGraph(
                          stream: stream,
                          updateDelay: Duration(milliseconds: 250),
                        ),
                      ),
                    ]))),
              ),
    ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: TinyColor.fromColor(SystemTheme.accentColor.lighter)
                        .tint(90)
                        .color,
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Center(
                          child: Column(children: [
                        Text(
                          "Raw Value:",
                          textScaleFactor: 2,
                        ),
                        SizedBox(
                            height: 125,
                            child: StreamBuilder(
                              stream: stream_raw,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text('${snapshot.data}',
                                      textScaleFactor: 5);
                                } else {
                                  return Text(
                                    'Waiting for data...',
                                    textScaleFactor: 5,
                                  );
                                }
                              },
                            ))
                      ])))),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: TinyColor.fromColor(SystemTheme.accentColor.lighter)
                      .tint(90)
                      .color,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Risk Analysis:",
                          textScaleFactor: 2,
                        ),
                        SizedBox(
                            height: 125,
                            child: StreamBuilder(
                              stream: risk_stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == "High") {
                                  return Text('${snapshot.data}',
                                      textScaleFactor: 5,
                                      style: TextStyle(
                                          color: TinyColor.fromString('#830000')
                                              .color));
                                } else if (snapshot.data == "Moderate") {
                                  return Text('${snapshot.data}',
                                      textScaleFactor: 5,
                                      style: TextStyle(
                                          color: TinyColor.fromString('#9B3F00')
                                              .color));
                                } else {
                                  return Text('${snapshot.data}',
                                      textScaleFactor: 5,
                                      style: TextStyle(
                                          color: TinyColor.fromString('#00791D')
                                              .color));
                                }
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
