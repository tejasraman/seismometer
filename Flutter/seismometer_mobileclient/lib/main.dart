import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart';
import 'apikeys.dart' as apikeys;
import 'package:http/http.dart' as http;
import 'package:real_time_chart/real_time_chart.dart';
import 'globals.dart' as globals;


Stream<double> stream = earthquakeRaw();
Stream<String> riskstream = earthquakeRisk();

Stream<double> earthquakeRaw() async* {
  while (true) {
    await Future.delayed(const Duration(milliseconds: 100));
    var response = await http.get(Uri.parse("https://ny3.blynk.cloud/external/api/get?token=${apikeys.BLYNK}&v0"));
    print(response.body);
    if (response.body != globals.existingval) {
      globals.existingval = response.body;
      yield double.parse(response.body);
    }
  }
}

Stream<String> earthquakeRisk() async* {
  while (true) {
    await Future.delayed(const Duration(milliseconds: 100));
    var response = await http.get(Uri.parse("https://ny3.blynk.cloud/external/api/get?token=${apikeys.BLYNK}&v1"));
      yield response.body;
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

final broadcastRisk = riskstream.asBroadcastStream(
  onCancel: (controller) {
    controller.pause();
  },
  onListen: (controller) async {
    if (controller.isPaused) {
      controller.resume();
    }
  },
);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg2.png"), fit: BoxFit.fill),
          ),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              fontFamily: 'Segoe UI Variable',
            ),
            home: const MyHomePage(),
          ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    OneSignal.initialize("${apikeys.ONESIGNAL_APPID}");
    OneSignal.Notifications.requestPermission(true);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Seismometer Client", style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 20, child: RealTimeGraph(
              txtcolor: Colors.white,
              updateDelay: Duration(milliseconds: 100),
              stream: broadcastStream,
              speed: 4,

            )
            ), Expanded(child: Container(), flex: 1), Expanded(flex: 12,child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(color: Color(0xFFFFFFFF))),
                  child: Center(
                    child: StreamBuilder(
                        stream: broadcastStream,
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                '${snapshot.data.round()}',
                                textScaleFactor: 4.5,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF)));
                          } else {
                            return const Text(
                              '00',
                              textScaleFactor: 4.5,style: TextStyle(
                                color: Color(0xFFFFFFFF))
                            );
                          }
                        }),
                  ))
            ),

            Expanded(child: Container(), flex: 1),
            Expanded(flex: 12,child: StreamBuilder(
              stream: broadcastRisk,
              builder:
                  (BuildContext context, AsyncSnapshot snapshot) {
                var x = int.parse(snapshot.data);
                if (x == 2) {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFFF0000)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(15.0))),
                      child: const Center(
                          child: Text('Hi',
                              textScaleFactor: 4.5,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF)))));
                } else if (x == 1) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(color: Color(0xFFF39C12))),
                      child: const Center(
                          child: Text('Med',
                              textScaleFactor: 4.5,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF)))));
                } else {
                  return Container(
                      decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              border: Border.all(color: Color(0xFF0D981B))),
                      child: const Center(
                          child: Text('Lo',
                              textScaleFactor: 4.5,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF)))));
                }
              },
            )), Expanded(child: Container(), flex: 2)
          ],
        )),
      );
  }
}
