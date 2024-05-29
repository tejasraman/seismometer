// Material pkg import
// Fluent icons and theming colors
// import 'package:dartssh2/dartssh2.dart';
import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
import 'package:real_time_chart/real_time_chart.dart';
// import 'package:system_theme/system_theme.dart';
// import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:onesignal_flutter/onesignal_flutter.dart';

/////////////////////////////////////////////////
// DO NOT USE HTTP OVERRIDES; ONLY FOR TESTING //
/////////////////////////////////////////////////

// class DevHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpC/opt/warpdotdev/warp-terminal/warp: /lib64/libcurl.so.4: no version information available (required by /opt/warpdotdev/warp-terminal/warp)lient(context)
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
//
// int rk = 1;
// double rv = 0.0;
//
// Stream<List> earthquakeData() async* {
//   final socket = await SSHSocket.connect('localhost', 5001);
//   final List<String> risks = ["Lo", "Med", "Hi"];
//   SSHClient client = SSHClient(socket,
//       username: 'tejas', onPasswordRequest: () => 'ramennoodles');
//   SftpClient sftp = await client.sftp();
//   var problem = false;
//
//   while (true) {
//     await Future.delayed(const Duration(milliseconds: 20));
//     List x = [];
//     try {
//       final file = await sftp.open('/home/tejas/datapoint.txt');
//       final content = await file.readBytes();
//       final response = latin1.decode(content);
//       if (response.trim() != "") {
//         rv = double.parse(response);
//       }
//     } on SftpStatusError {
//       problem = true;
//     }
//     x.add(rv.toString());
//
//     try {
//       final file1 = await sftp.open('/home/tejas/risk.txt');
//       final content1 = await file1.readBytes();
//       final response = latin1.decode(content1);
//       if (response.trim() != "") {
//         rk = int.parse(response);
//       }
//     } on SftpStatusError {
//       problem = true;
//     }
//
//     Stream<List> earthquakeData() async* {
//       final socket = await SSHSocket.connect('localhost', 5001);
//       final List<String> risks = ["Lo", "Med", "Hi"];
//       SSHClient client = SSHClient(socket,
//           username: 'tejas', onPasswordRequest: () => 'ramennoodles');
//       SftpClient sftp = await client.sftp();
//       var problem = false;
//
//       while (true) {}
//     }
//
//     // restart connection if there was a problem
//     if (problem) {
//       client.close();
//       client = SSHClient(socket,
//           username: 'tejas', onPasswordRequest: () => 'ramennoodles');
//       sftp = await client.sftp();
//       problem = false;
//     }
//
//     x.add(risks[rk - 1]);
//     print(x);
//     yield x;
//   }
// }
//
// final broadcastStream = stream.asBroadcastStream(
//   onCancel: (controller) {
//     controller.pause();
//   },
//   onListen: (controller) async {
//     if (controller.isPaused) {
//       controller.resume();
//     }
//   },
// );
//

// double y = 0;
//
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
    final recal = await client.run('bash /home/tejas/toggle.bash');
    print(utf8.decode(recal));
  }
}
//
// final stream = earthquakeData();



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
home: MyApp());
}
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}


class _MyApp extends State<MyApp> {
late nats.Client natsClient;
late nats.Subscription seismometer, risk;

void initState() {
super.initState();

OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
OneSignal.initialize("1c785572-5466-4027-b9d2-9b48f04b791a");
OneSignal.Notifications.requestPermission(true);


connect();
}

void connect() {
natsClient = nats.Client();
natsClient.connect(Uri.parse('nats://localhost:5001'));
seismometer = natsClient.sub('data');
risk = natsClient.sub('risk');
}

Widget build(BuildContext context) {
return Scaffold(
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
color: Color(0xCD1A1A1A)),
child: Center(
child: Text(
"Quake-O-Meter",
textScaleFactor: 1.15,
style: TextStyle(color: Colors.white70),
))),
),
Expanded(flex: 15, child: Container()),
Expanded(
flex: 480,
child: Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(15.0)),
color: Color(0xCDC7C7C7)),
  child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  child: Center(
  child: RealTimeGraph(
  stream: seismometer.stream.map<double>((val) => double.parse(val.string)),
  updateDelay: Duration(milliseconds: 25),
  graphColor: Colors.black,
  pointsSpacing: double.parse("1.0"),
  xAxisColor: Colors.black,
  yAxisColor: Colors.black,
  graphStroke: 3,
  ),
  )
  )
  )
  ),
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
color: Color(0xCD1A1A1A)),
child: Center(
child: Text(
"Raw Value",
textScaleFactor: 1.2,
style: TextStyle(
color: Colors.white70,
fontWeight: FontWeight.w400),
)))),
SizedBox(width: 15),
Expanded(
flex: 1,
child: Container(
decoration: BoxDecoration(
borderRadius:
BorderRadius.all(Radius.circular(15.0)),
color: Color(0xCD1A1A1A)),
child: Center(
child: Text(
"Risk",
textScaleFactor: 1.2,
style: TextStyle(
color: Colors.white70,
fontWeight: FontWeight.w400),
)))),
SizedBox(width: 15),
Expanded(
flex: 3,
child: Container(
decoration: BoxDecoration(
borderRadius:
BorderRadius.all(Radius.circular(15.0)),
color: Color(0xCD1A1A1A)),
child: Center(
child: Text(
"Tools",
textScaleFactor: 1.2,
style: TextStyle(
color: Colors.white70,
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
color: Color(0xCDC7C7C7)),
child: Center(
child: StreamBuilder(
stream: seismometer.stream,
builder: (BuildContext context,
AsyncSnapshot snapshot) {
if (snapshot.hasData) {
return Text(
'${double.parse(snapshot.data.string).round()}',
textScaleFactor: 4.5);
} else {
return Text(
'00',
textScaleFactor: 4.5,
);
}
}),
))),
SizedBox(width: 15),
Expanded(
flex: 1,
child: StreamBuilder(
stream: risk.stream,
builder:
(BuildContext context, AsyncSnapshot snapshot) {
var x = int.parse(snapshot.data.string);
if (x == 2) {
return Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.all(
Radius.circular(15.0)),
color: Color(0xFFFF0000)),
child: Center(
child: Text('Hi',
textScaleFactor: 4.5,
style: TextStyle(
color: Color(0xFFFFFFFF)))));
} else if (x == 1) {
return Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.all(
Radius.circular(15.0)),
color: Color(0xFFF39C12)),
child: Center(
child: Text('Med',
textScaleFactor: 4.5,
style: TextStyle(
color: Color(0xFFFFFFFF)))));
} else {
return Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.all(
Radius.circular(15.0)),
color: Color(0xFF0D981B)),
child: Center(
child: Text('Lo',
textScaleFactor: 4.5,
style: TextStyle(
color: Color(0xFFFFFFFF)))));
}
},
)),
SizedBox(width: 15),
Expanded(
flex: 3,
child: Container(
decoration: BoxDecoration(
borderRadius:
BorderRadius.all(Radius.circular(15.0)),
color: Color(0xCDC7C7C7)),
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
size: 60,
),
Text(
" SSH",
textScaleFactor: 3,
style: TextStyle(
color:
Colors.black87),
),
]))),
flex: 2),
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
size: 60,
),
Text(
" Start/Stop",
textScaleFactor: 3,
style: TextStyle(
color:
Colors.black87),
)
]))),
flex: 3)
],
))))
]),
)
],
),
),
),
));}


void dispose() {
natsClient.close();
super.dispose();
}
}

