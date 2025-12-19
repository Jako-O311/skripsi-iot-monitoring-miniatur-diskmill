import 'package:flutter/material.dart';
// import 'package:aplikasi_kontrol_dan_monitoring_mesin/main_page.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page1_monitor.dart';
// import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page2_smsgateway.dart';
// import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page3_history.dart';


void main() async {
  runApp(aplikasi_kontrol_dan_monitoring_diskmill());
}

class aplikasi_kontrol_dan_monitoring_diskmill extends StatelessWidget {
  const aplikasi_kontrol_dan_monitoring_diskmill({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: akdm_monitor(),
    );
  }
}








// // For performing some operations asynchronously
// import 'dart:async';
// import 'dart:convert';

// // For using PlatformException
// import 'package:flutter/services.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BluetoothApp(),
//     );
//   }
// }

// class BluetoothApp extends StatefulWidget {
//   @override
//   _BluetoothAppState createState() => _BluetoothAppState();
// }

// class _BluetoothAppState extends State<BluetoothApp> {
//   // Initializing the Bluetooth connection state to be unknown
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//   // Initializing a global key, as it would help us in showing a SnackBar later
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   // Get the instance of the Bluetooth
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   // Track the Bluetooth connection with the remote device
//   BluetoothConnection connection;

//   int _deviceState;

//   bool isDisconnecting = false;

//   Map<String, Color> colors = {
//     'onBorderColor': Colors.green,
//     'offBorderColor': Colors.red,
//     'neutralBorderColor': Colors.transparent,
//     'onTextColor': Colors.green[700],
//     'offTextColor': Colors.red[700],
//     'neutralTextColor': Colors.blue,
//   };

//   // To track whether the device is still connected to Bluetooth
//   bool get isConnected => connection != null && connection.isConnected;

//   // Define some variables, which will be required later
//   List<BluetoothDevice> _devicesList = [];
//   BluetoothDevice _device;
//   bool _connected = false;
//   bool _isButtonUnavailable = false;

//   @override
//   void initState() {
//     super.initState();

//     // Get current state
//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     _deviceState = 0; // neutral

//     // If the bluetooth of the device is not enabled,
//     // then request permission to turn on bluetooth
//     // as the app starts up
//     enableBluetooth();

//     // Listen for further state changes
//     FlutterBluetoothSerial.instance
//         .onStateChanged()
//         .listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//         if (_bluetoothState == BluetoothState.STATE_OFF) {
//           _isButtonUnavailable = true;
//         }
//         getPairedDevices();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     // Avoid memory leak and disconnect
//     if (isConnected) {
//       isDisconnecting = true;
//       connection.dispose();
//       connection = null;
//     }

//     super.dispose();
//   }

//   // Request Bluetooth permission from the user
//   Future<void> enableBluetooth() async {
//     // Retrieving the current Bluetooth state
//     _bluetoothState = await FlutterBluetoothSerial.instance.state;

//     // If the bluetooth is off, then turn it on first
//     // and then retrieve the devices that are paired.
//     if (_bluetoothState == BluetoothState.STATE_OFF) {
//       await FlutterBluetoothSerial.instance.requestEnable();
//       await getPairedDevices();
//       return true;
//     } else {
//       await getPairedDevices();
//     }
//     return false;
//   }

//   // For retrieving and storing the paired devices
//   // in a list.
//   Future<void> getPairedDevices() async {
//     List<BluetoothDevice> devices = [];

//     // To get the list of paired devices
//     try {
//       devices = await _bluetooth.getBondedDevices();
//     } on PlatformException {
//       print("Error");
//     }

//     // It is an error to call [setState] unless [mounted] is true.
//     if (!mounted) {
//       return;
//     }

//     // Store the [devices] list in the [_devicesList] for accessing
//     // the list outside this class
//     setState(() {
//       _devicesList = devices;
//     });
//   }

//   // Now, its time to build the UI
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text("Flutter Bluetooth"),
//           backgroundColor: Colors.deepPurple,
//           actions: <Widget>[
//             FlatButton.icon(
//               icon: Icon(
//                 Icons.refresh,
//                 color: Colors.white,
//               ),
//               label: Text(
//                 "Refresh",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               splashColor: Colors.deepPurple,
//               onPressed: () async {
//                 // So, that when new devices are paired
//                 // while the app is running, user can refresh
//                 // the paired devices list.
//                 await getPairedDevices().then((_) {
//                   show('Device list refreshed');
//                 });
//               },
//             ),
//           ],
//         ),
//         body: Container(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Visibility(
//                 visible: _isButtonUnavailable &&
//                     _bluetoothState == BluetoothState.STATE_ON,
//                 child: LinearProgressIndicator(
//                   backgroundColor: Colors.yellow,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(
//                         'Enable Bluetooth',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Switch(
//                       value: _bluetoothState.isEnabled,
//                       onChanged: (bool value) {
//                         future() async {
//                           if (value) {
//                             await FlutterBluetoothSerial.instance
//                                 .requestEnable();
//                           } else {
//                             await FlutterBluetoothSerial.instance
//                                 .requestDisable();
//                           }

//                           await getPairedDevices();
//                           _isButtonUnavailable = false;

//                           if (_connected) {
//                             _disconnect();
//                           }
//                         }

//                         future().then((_) {
//                           setState(() {});
//                         });
//                       },
//                     )
//                   ],
//                 ),
//               ),
//               Stack(
//                 children: <Widget>[
//                   Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Text(
//                           "PAIRED DEVICES",
//                           style: TextStyle(fontSize: 24, color: Colors.blue),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               'Device:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             DropdownButton(
//                               items: _getDeviceItems(),
//                               onChanged: (value) =>
//                                   setState(() => _device = value),
//                               value: _devicesList.isNotEmpty ? _device : null,
//                             ),
//                             RaisedButton(
//                               onPressed: _isButtonUnavailable
//                                   ? null
//                                   : _connected ? _disconnect : _connect,
//                               child:
//                                   Text(_connected ? 'Disconnect' : 'Connect'),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             side: new BorderSide(
//                               color: _deviceState == 0
//                                   ? colors['neutralBorderColor']
//                                   : _deviceState == 1
//                                       ? colors['onBorderColor']
//                                       : colors['offBorderColor'],
//                               width: 3,
//                             ),
//                             borderRadius: BorderRadius.circular(4.0),
//                           ),
//                           elevation: _deviceState == 0 ? 4 : 0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Text(
//                                     "DEVICE 1",
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       color: _deviceState == 0
//                                           ? colors['neutralTextColor']
//                                           : _deviceState == 1
//                                               ? colors['onTextColor']
//                                               : colors['offTextColor'],
//                                     ),
//                                   ),
//                                 ),
//                                 FlatButton(
//                                   onPressed: _connected
//                                       ? _sendOnMessageToBluetooth
//                                       : null,
//                                   child: Text("ON"),
//                                 ),
//                                 FlatButton(
//                                   onPressed: _connected
//                                       ? _sendOffMessageToBluetooth
//                                       : null,
//                                   child: Text("OFF"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         RaisedButton(
//                           elevation: 2,
//                           child: Text("Bluetooth Settings"),
//                           onPressed: () {
//                             FlutterBluetoothSerial.instance.openSettings();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Create the List of devices to be shown in Dropdown Menu
//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devicesList.isEmpty) {
//       items.add(DropdownMenuItem(
//         child: Text('NONE'),
//       ));
//     } else {
//       _devicesList.forEach((device) {
//         items.add(DropdownMenuItem(
//           child: Text(device.name),
//           value: device,
//         ));
//       });
//     }
//     return items;
//   }

//   // Method to connect to bluetooth
//   void _connect() async {
//     setState(() {
//       _isButtonUnavailable = true;
//     });
//     if (_device == null) {
//       show('No device selected');
//     } else {
//       if (!isConnected) {
//         await BluetoothConnection.toAddress(_device.address)
//             .then((_connection) {
//           print('Connected to the device');
//           connection = _connection;
//           setState(() {
//             _connected = true;
//           });

//           connection.input.listen(null).onDone(() {
//             if (isDisconnecting) {
//               print('Disconnecting locally!');
//             } else {
//               print('Disconnected remotely!');
//             }
//             if (this.mounted) {
//               setState(() {});
//             }
//           });
//         }).catchError((error) {
//           print('Cannot connect, exception occurred');
//           print(error);
//         });
//         show('Device connected');

//         setState(() => _isButtonUnavailable = false);
//       }
//     }
//   }

//   // void _onDataReceived(Uint8List data) {
//   //   // Allocate buffer for parsed data
//   //   int backspacesCounter = 0;
//   //   data.forEach((byte) {
//   //     if (byte == 8 || byte == 127) {
//   //       backspacesCounter++;
//   //     }
//   //   });
//   //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
//   //   int bufferIndex = buffer.length;

//   //   // Apply backspace control character
//   //   backspacesCounter = 0;
//   //   for (int i = data.length - 1; i >= 0; i--) {
//   //     if (data[i] == 8 || data[i] == 127) {
//   //       backspacesCounter++;
//   //     } else {
//   //       if (backspacesCounter > 0) {
//   //         backspacesCounter--;
//   //       } else {
//   //         buffer[--bufferIndex] = data[i];
//   //       }
//   //     }
//   //   }
//   // }

//   // Method to disconnect bluetooth
//   void _disconnect() async {
//     setState(() {
//       _isButtonUnavailable = true;
//       _deviceState = 0;
//     });

//     await connection.close();
//     show('Device disconnected');
//     if (!connection.isConnected) {
//       setState(() {
//         _connected = false;
//         _isButtonUnavailable = false;
//       });
//     }
//   }

//   // Method to send message,
//   // for turning the Bluetooth device on
//   void _sendOnMessageToBluetooth() async {
//     connection.output.add(utf8.encode("1" + "\r\n"));
//     await connection.output.allSent;
//     show('Device Turned On');
//     setState(() {
//       _deviceState = 1; // device on
//     });
//   }

//   // Method to send message,
//   // for turning the Bluetooth device off
//   void _sendOffMessageToBluetooth() async {
//     connection.output.add(utf8.encode("0" + "\r\n"));
//     await connection.output.allSent;
//     show('Device Turned Off');
//     setState(() {
//       _deviceState = -1; // device off
//     });
//   }

//   // Method to show a Snackbar,
//   // taking message as the text
//   Future show(
//     String message, {
//     Duration duration: const Duration(seconds: 3),
//   }) async {
//     await new Future.delayed(new Duration(milliseconds: 100));
//     _scaffoldKey.currentState.showSnackBar(
//       new SnackBar(
//         content: new Text(
//           message,
//         ),
//         duration: duration,
//       ),
//     );
//   }
// }







// // // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


// // // import 'package:flutter/material.dart';
// // // import 'package:aplikasi_kontrolmesin/main_page.dart';

// // // void main() async {
// // //   runApp(const MainApp());
// // // }

// // // class MainApp extends StatelessWidget {
// // //   const MainApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       theme: ThemeData(useMaterial3: true),
// // //       debugShowCheckedModeBanner: false,
// // //       home: const MainPage(),
// // //     );
// // //   }
// // // }



// // void main() {
// //   runApp(aplikasi_mesin());
// // }

// // class aplikasi_mesin extends StatelessWidget {

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Kontrol Disk Mill',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
// //         useMaterial3: true,
// //       ),
// //       home: kontrol_bluetooth(),
// //     );
// //   }
// // }

// // class kontrol_bluetooth extends StatefulWidget {

// //   @override
// //   State<kontrol_bluetooth> createState() => _kontrol_bluetoothState();
// // }

// // class _kontrol_bluetoothState extends State<kontrol_bluetooth> {
// //   BluetoothConnection? koneksi;
// //   bool isConnecting = true;
// //   bool isConnected = false;
// //   String status = "Tidak Tersambung";

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     sambungKeBluetooth();
// //   }

// //   Future<void> sambungKeBluetooth() async {
// //     try {
// //       final BluetoothDevice device = (await FlutterBluetoothSerial.instance.getBondedDevices()).firstWhere((device) => device.name == "HC-05");
// //       koneksi = await BluetoothConnection.toAddress(device.address);
// //       setState(() {
// //         isConnected = true;
// //         status = "Tersambung dengan HC-05";
// //       });
// //     } catch (e) {
// //       setState(() {
// //         status = "Koneksi gagal: $e";
// //       });
// //     }
// //   }

// //   void kirimPerintah(String perintah) {
// //     if (isConnected && koneksi != null) {
// //       koneksi!.output.add(Uint8List.fromList(perintah.codeUnits));
// //       koneksi!.output.allSent;
// //     }
// //   }
  
// //   @override
// //   void dispose() {
// //     // TODO: implement dispose
// //     koneksi?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Kontrol Disk Mill Bluetooth"),
// //       ),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(status, style: TextStyle(fontSize: 16),),
// //           SizedBox(height: 20,),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               ElevatedButton(
// //                 onPressed: () => kirimPerintah('1'), 
// //                 child: Text("ON"),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () => kirimPerintah('0'), 
// //                 child: Text("OFF"),
// //               ),
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
