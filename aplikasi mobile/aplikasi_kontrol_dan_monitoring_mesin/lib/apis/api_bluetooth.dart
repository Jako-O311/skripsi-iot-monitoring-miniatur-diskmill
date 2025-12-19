import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

// class api_bluetooth_2 {
//   void requestIzin() async {
//     await Permission.location.request();
//     await Permission.bluetooth.request();
//     await Permission.bluetoothScan.request();
//     await Permission.bluetoothConnect.request();
//   }
// }

class api_bluetooth extends StatefulWidget {
  const api_bluetooth({super.key});

  @override
  State<api_bluetooth> createState() => _api_bluetoothState();
}

class _api_bluetoothState extends State<api_bluetooth> {
  // variabel nilai awal untuk api bluetooth
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _stateBluetooth = false;
  bool _menyambungkan = false;
  BluetoothConnection? _koneksi; // variabel koneksi bluetooth diberi nilai null karena belum tersambung dulu
  List<BluetoothDevice> _perangkatBluetooth = []; // list array perangkat bluetooth
  BluetoothDevice? _perangkatTersambung; // untuk perangkat bluetooth yang tersambung
  String _notifikasi = "";

  // method untuk request/minta izin pemakaian di android dengan permission_handler
  void _requestIzin() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }
  // method untuk menyambungkan module bluetooth mesin dengan aplikasi
  void _ambilPerangkat() async {
    var perangkat = await _bluetooth.getBondedDevices();
    setState(() {
      _perangkatBluetooth = perangkat;
    });
  }
  // method untuk notifikasi mesin ke aplikasi
  void _terimaData() {
    // koneksi mendengarkan input data String dari mesin
    _koneksi?.input?.listen((event) {
      if (String.fromCharCodes(event) == "hidup") {
        setState(() {
          _notifikasi = "Mesin Hidup";
        });
      } else if (String.fromCharCodes(event) == "mati") {
        setState(() {
          _notifikasi = "Mesin Mati";
        });
      } else if (String.fromCharCodes(event) == "tegangan") {
        setState(() {
          _notifikasi = "Terdapat masalah dengan tegangan mesin";
        });
      }
    });
  }
  // method untuk mengirim data perintah ke mesin
  void _kirimData(String data) {
    // IF mengecek variabel _koneksi tersambung apa tidak
    if (_koneksi?.isConnected ?? false) {
      // jika terkoneksi data yang dikirim perlu di konversi format ASCII
      _koneksi?.output.add(ascii.encode(data));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // inisialiasi izin state bluetooth
    _requestIzin();
    // rubah state bluetooth menjadi true
    _bluetooth.state.then((value) {
      setState(() {
        _stateBluetooth = value.isEnabled;
      });
    },);
    // pancingan untuk mendengarkan perubahan _stateBluetooth
    // apakah bluetoothnya mati atau tidak
    _bluetooth.onStateChanged().listen((event) {
      switch (event) {
        case BluetoothState.STATE_OFF:
          setState(() {
            _stateBluetooth = false;
          });
          break;
        case BluetoothState.STATE_ON:
          setState(() {
            _stateBluetooth = true;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
