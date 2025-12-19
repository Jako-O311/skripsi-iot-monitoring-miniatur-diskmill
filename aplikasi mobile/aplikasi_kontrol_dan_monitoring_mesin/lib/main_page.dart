// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page1_monitor.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page2_smsgateway.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page3_history.dart';

class main_page extends StatefulWidget {
  const main_page({super.key});

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  // daftar halaman navbar bawah
  int _indexSelect = 0;
  final List<Widget> _pages = [
    akdm_monitor(),
    akdm_smsgateway(),
    akdm_history(),
  ];
  // // variabel nilai awal untuk api bluetooth
  // final _bluetooth = FlutterBluetoothSerial.instance;
  // bool _stateBluetooth = false;
  // bool _menyambungkan = false;
  // BluetoothConnection? _koneksi; // variabel koneksi bluetooth diberi nilai null karena belum tersambung dulu
  // List<BluetoothDevice> _perangkatBluetooth = []; // list array perangkat bluetooth
  // BluetoothDevice? _perangkatTersambung; // untuk perangkat bluetooth yang tersambung
  // String _notifikasi = "tes notifikasi";
  // rubah halaman dengan tekan navbar
  void _onTap(int index) {
    setState(() {
      _indexSelect = index;
    });
  }
  // switch-case untuk teks appbar
  appbarSwitch(int index) {
    switch(index) {
      case 0:
        return "Monitoring Disk Mill";
      case 1:
        return "Halaman Fitur SMS";
      case 2:
        return "Sejarah Kerusakan";
    }
  }
  // // method untuk request/minta izin pemakaian di android dengan permission_handler
  // void _requestIzin() async {
  //   await Permission.location.request();
  //   await Permission.bluetooth.request();
  //   await Permission.bluetoothScan.request();
  //   await Permission.bluetoothConnect.request();
  // }
  // // method untuk menyambungkan module bluetooth mesin dengan aplikasi
  // void _ambilPerangkat() async {
  //   var perangkat = await _bluetooth.getBondedDevices();
  //   setState(() {
  //     _perangkatBluetooth = perangkat;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // inisialiasi api_bluetooth
    // api_bt = api_bluetooth();
    // api_bt.requestIzin();

    // // inisialiasi izin state bluetooth
    // _requestIzin();
    // // rubah state bluetooth menjadi true
    // _bluetooth.state.then((value) {
    //   setState(() {
    //     _stateBluetooth = value.isEnabled;
    //   });
    // },);
    // // pancingan untuk mendengarkan perubahan _stateBluetooth
    // // apakah bluetoothnya mati atau tidak
    // _bluetooth.onStateChanged().listen((event) {
    //   switch (event) {
    //     case BluetoothState.STATE_OFF:
    //       setState(() {
    //         _stateBluetooth = false;
    //       });
    //       break;
    //     case BluetoothState.STATE_ON:
    //       setState(() {
    //         _stateBluetooth = true;
    //       });
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(appbarSwitch(_indexSelect)),
      ),
      body: Column(
        children: [
          // //menu koneksi bluetooth
          // // SwitchListTile(
          // //   value: _stateBluetooth, 
          // //   onChanged: (value) async {
          // //     if (value) {
          // //       await _bluetooth.requestEnable(); // mengaktifkan bluetooth
          // //       showDialog(
          // //         context: context, 
          // //         builder: (context) => SimpleDialog(
          // //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // //         ),
          // //       );
          // //     } else {
          // //       await _bluetooth.requestDisable(); // menonaktifkan bluetooth
          // //     }
          // //   },
          // //   tileColor: Colors.blue[100],
          // //   title: Text(_stateBluetooth ? "Bluetooth Hidup" : "Bluetooth Mati"),
          // //   subtitle: Text("${_perangkatTersambung?.name ?? "Tidak Tersambung"}"), //"??" null safety menggunakan conditional IF
          // // ),
          // ListTile(
          //   tileColor: Colors.blue[100],
          //   title: Text(_stateBluetooth ? "Bluetooth Hidup" : "Bluetooth Mati"),
          //   subtitle: Text("${_perangkatTersambung?.name ?? "Tidak Tersambung"}"), //"??" null safety menggunakan conditional IF
          //   trailing: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Container(
          //         child: _stateBluetooth ? _koneksi?.isConnected ?? false ? TextButton(
          //           onPressed: () async {
          //             await _koneksi?.finish();
          //             setState(() {
          //               _perangkatTersambung = null;
          //             });
          //           }, 
          //           child: Text("Putus")
          //         ) : TextButton(
          //           onPressed: () {
          //             _ambilPerangkat(); // untuk listing mengambil perangkat
          //             showDialog( // widget untuk memilih perangkat
          //               context: context, 
          //               builder: (context) => SimpleDialog(
          //                 // title: ElevatedButton(
          //                 //   onPressed: _ambilPerangkat,
          //                 //   child: Text("refresh")),
          //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //                 children: [
          //                   Expanded(child: _menyambungkan ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          //                     child: Column(
          //                       children: [
          //                         ...[
          //                           for (final perangkat in _perangkatBluetooth) ListTile(
          //                             title: Text(perangkat.name ?? perangkat.address),
          //                             trailing: TextButton(
          //                               onPressed: () async {
          //                                 setState(() {
          //                                   _menyambungkan = true;
          //                                 });
          //                                 _koneksi = await BluetoothConnection.toAddress(perangkat.address);
          //                                 _perangkatTersambung = perangkat;
          //                                 _perangkatBluetooth = [];
          //                                 _menyambungkan = false;
          //                                 // _terimaData();
          //                                 // refresh
          //                                 setState(() {});
          //                               }, 
          //                               child: Text("Sandingkan")
          //                             ),
          //                           )
          //                         ]
          //                       ],
          //                     ),
          //                   ),),
          //                 ],
          //               ),
          //             );
          //           },  
          //           child: Text("Cari")
          //         ) : Text("") ,
          //       ),
          //       Switch(
          //         value: _stateBluetooth, 
          //         onChanged: (value) async {
          //           if (value) {
          //             await _bluetooth.requestEnable(); // mengaktifkan bluetooth
          //             // showDialog( // widget untuk memilih perangkat
          //             //   context: context, 
          //             //   builder: (context) => SimpleDialog(
          //             //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //             //     children: [
          //             //       Expanded(child: _menyambungkan ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          //             //         child: Column(
          //             //           children: [
          //             //             ...[
          //             //               for (final perangkat in _perangkatBluetooth) ListTile(
          //             //                 title: Text(perangkat.name ?? perangkat.address),
          //             //                 trailing: TextButton(
          //             //                   onPressed: () async {
          //             //                     setState(() {
          //             //                       _menyambungkan = true;
          //             //                     });
          //             //                     _koneksi = await BluetoothConnection.toAddress(perangkat.address);
          //             //                     _perangkatTersambung = perangkat;
          //             //                     _perangkatBluetooth = [];
          //             //                     _menyambungkan = false;
          //             //                     // _terimaData();
          //             //                     // refresh
          //             //                     setState(() {});
          //             //                   }, 
          //             //                   child: Text("Sandingkan")
          //             //                 ),
          //             //               )
          //             //             ]
          //             //           ],
          //             //         ),
          //             //       ),),
          //             //     ],
          //             //   ),
          //             // );
          //             // _ambilPerangkat(); // list untuk mengambil perangkat
          //           } else {
          //             await _bluetooth.requestDisable(); // menonaktifkan bluetooth
          //           }
          //         },
          //       ),
          //     ],
          //   )

          //   // trailing: _koneksi?.isConnected ?? false ? TextButton(
          //   //   onPressed: () async {
          //   //     await _koneksi?.finish();
          //   //     setState(() {
          //   //       _perangkatTersambung = null;
          //   //     });
          //   //   }, 
          //   //   child: Text("Putus")
          //   // ) : TextButton(
          //   //   onPressed: _ambilPerangkat, 
          //   //   child: Text("Cari")
          //   // )
          // ),
          // // Container(
          // //   height: 200,
          // //   child: Expanded(child: _menyambungkan ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          // //     child: Column(
          // //       children: [
          // //         ...[
          // //           for (final perangkat in _perangkatBluetooth) ListTile(
          // //             title: Text(perangkat.name ?? perangkat.address),
          // //             trailing: TextButton(
          // //               onPressed: () async {
          // //                 setState(() {
          // //                   _menyambungkan = true;
          // //                 });
          // //                 _koneksi = await BluetoothConnection.toAddress(perangkat.address);
          // //                 _perangkatTersambung = perangkat;
          // //                 _perangkatBluetooth = [];
          // //                 _menyambungkan = false;
          // //                 // _terimaData();
          // //                 // refresh
          // //                 setState(() {});
          // //               }, 
          // //               child: Text("Sandingkan")
          // //             ),
          // //           )
          // //         ]
          // //       ],
          // //     ),
          // //   ),),
          // // ),
          // // Container(
          // //   height: 50,
          // //   child: Text("template tombol bluetooth"),
          // // ),
          Container(
            height: 538,
            child: _pages[_indexSelect],
          ),
        ],
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexSelect,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_audio),
            label: "Monitoring",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms),
            label: "SMS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}
