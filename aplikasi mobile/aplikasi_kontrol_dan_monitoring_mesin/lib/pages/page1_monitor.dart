import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/apis/api_database.dart';
// import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page2_smsgateway.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/pages/page3_history.dart';
import 'package:url_launcher/url_launcher.dart';

class akdm_monitor extends StatefulWidget {
  const akdm_monitor({super.key});

  @override
  State<akdm_monitor> createState() => _akdm_monitorState();
}

class _akdm_monitorState extends State<akdm_monitor> {
  // // instance api bluetooth
  // late api_bluetooth api_bt;

  // variabel nilai awal untuk bluetooth
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _stateBluetooth = false;
  bool _menyambungkan = false;
  BluetoothConnection? _koneksi; // variabel koneksi bluetooth diberi nilai null karena belum tersambung dulu
  List<BluetoothDevice> _perangkatBluetooth = []; // list array perangkat bluetooth
  BluetoothDevice? _perangkatTersambung; // untuk perangkat bluetooth yang tersambung
  String _notifikasi = "sistem monitoring diskmill";
  // String _listenarus = "";
  TextEditingController _arusController = TextEditingController();

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
    // // koneksi mendengarkan input data String dari mesin
    // _koneksi?.input?.listen((event) {
    //   if (String.fromCharCodes(event) == "n1") {
    //     setState(() {
    //       _notifikasi = "Mesin Hidup";
    //     });
    //   } else if (String.fromCharCodes(event) == "n0") {
    //     setState(() {
    //       _notifikasi = "Mesin Mati";
    //     });
    //   } else if (String.fromCharCodes(event) == "e1") {
    //     setState(() {
    //       _notifikasi = "Terdapat masalah dengan tegangan mesin";
    //       // error
    //       databaseHelper().insertLogKerusakan("Sensor tegangan mendeteksi anomali pada saluran tegangan listrik mesin");
    //     });
    //   } else if (String.fromCharCodes(event) == "e2"){
    //     setState(() {
    //       _notifikasi = "Terdapat masalah dengan arus listrik mesin";
    //       // error
    //       databaseHelper().insertLogKerusakan("Sensor arus mendeteksi anomali pada arus listrik yang mengalir ke mesin");
    //     });
    //   }
    // });

    // broadcast untuk mendapatkan data notifikasi dari arduino
    Stream<Uint8List> streamData = _koneksi!.input!.asBroadcastStream();
    // untuk data arus
    streamData.listen((Uint8List listenData) {
      String stringNotifikasi = String.fromCharCodes(listenData).trim();
      // String stringNotifikasi = utf8.decode(listenData).trim();
      setState(() {
        _notifikasi = stringNotifikasi;
        print(_notifikasi);
        // // if (_notifikasi.indexOf('ERR_T') != -1) {
        // if (_notifikasi.contains('ERR_T')) {
        //   // simpan error ke database sejarah kerusakan
        //   databaseHelper().insertLogKerusakan("Sensor tegangan mendeteksi anomali pada saluran tegangan listrik mesin");
        // } else if (_notifikasi.contains('ERR_A')) {
        //   databaseHelper().insertLogKerusakan("Sensor arus mendeteksi anomali pada arus listrik yang mengalir ke mesin");
        // }
      });
    });
    // untuk notifikasi status mesin
    streamData.listen((event) {
      if (String.fromCharCodes(event) == "n1") {
        setState(() {
          _notifikasi = "Mesin Menyala";
        });
      } else if (String.fromCharCodes(event) == "n0") {
        setState(() {
          _notifikasi = "Mesin Dimatikan";
        });
      } else if (String.fromCharCodes(event) == "n2") {
        setState(() {
          _notifikasi = "Arus listrik mendekati batas normal!";
        });
      } else if (String.fromCharCodes(event) == "e1") {
        setState(() {
          _notifikasi = "Terdapat masalah dengan tegangan listrik mesin";
          // error
          databaseHelper().insertLogKerusakan("Sensor tegangan mendeteksi anomali pada saluran tegangan listrik mesin");
        });
      } else if (String.fromCharCodes(event) == "e2"){
        setState(() {
          _notifikasi = "Terdapat masalah dengan arus listrik mesin";
          // error
          databaseHelper().insertLogKerusakan("Sensor arus mendeteksi anomali pada arus listrik yang mengalir ke mesin");
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
  // // looping cek notifikasi - masih perlu perbaikan
  // _cekNotifikasi() {
  //   while (_koneksi == true) {
  //     setState(() {
  //       // _terimaData();
  //     });
  //   }
  // }
  // untuk pembatas sensor arus - metode string
  //kirim data menggunakan data string ke arduino
  ////kirim data menggunakan metode parse double ke string lalu kirim data string ke arduino
  void _kirimDataArusMetodeString() async {

    // if (_koneksi == null || !_koneksi!.isConnected) {
    //   print("Not connected!");
    //   return;
    // }
    // Ambil nilai float dari TextFormField
    double value = double.tryParse(_arusController.text) ?? 0.0;
    // Konversi ke byte array (4 byte untuk float)
    ByteData byteData = ByteData(4); // menyiapkan buffer untuk 4 byte (float 32-bit)
    byteData.setFloat32(0, value, Endian.little); // menulis float ke dalam buffer
    Uint8List bytes = byteData.buffer.asUint8List(); // mengambil byte array yang akan dikirim
    // Kirim data ke Arduino
    _koneksi!.output.add(bytes); // mengirim data ke Arduino
    _koneksi!.output.allSent.then((_) {
      print("Sent: $value -> ${bytes.toList()}"); // bytes.toList() melihat data yang dikirim dalam bentuk array byte
    });

    // // String _limitArus = "arus:${_arusController.text}";
    // String _limitArus = "${_arusController.text}";
    // // IF mengecek variabel _koneksi tersambung apa tidak
    // if (_koneksi?.isConnected ?? false) {
    //   // jika terkoneksi data yang dikirim perlu di konversi format ASCII
    //   _koneksi?.output.add(ascii.encode(_limitArus));
    // }
    // // ScaffoldMessenger.of(context).showSnackBar(
    // //   SnackBar(content: Text("Limiter sensor arus dirubah"))
    // // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // inisialiasi api_bluetooth
    // api_bt = api_bluetooth();
    // api_bt.requestIzin();
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
    // _cekNotifikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Monitoring Disk Mill"),
      ),
      body: Column(
        children: [
          //menu koneksi bluetooth
          ListTile(
            tileColor: Colors.blue[100],
            title: Text(_stateBluetooth ? "Bluetooth Hidup" : "Bluetooth Mati"),
            subtitle: Text("${_perangkatTersambung?.name ?? "Tidak Tersambung"}"), //"??" null safety menggunakan conditional IF
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: _stateBluetooth ? _koneksi?.isConnected ?? false ? TextButton(
                    onPressed: () async {
                      await _koneksi?.finish();
                      setState(() {
                        _perangkatTersambung = null;
                      });
                    }, 
                    child: Text("Putus")
                  ) : TextButton(
                    onPressed: () {
                      _ambilPerangkat(); // untuk listing mengambil perangkat
                      showDialog( // widget untuk memilih perangkat
                        context: context, 
                        builder: (context) => SimpleDialog(
                          // title: ElevatedButton(
                          //   onPressed: _ambilPerangkat,
                          //   child: Text("refresh")),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          children: [
                            Container( //bugfix expanded sementara
                              height: 200,
                              child: Column(
                                children: [
                                  Expanded(flex: 1, child: _menyambungkan ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...[ // listing perangkat bluetooth yang ada
                                          for (final perangkat in _perangkatBluetooth) ListTile(
                                            title: Text(perangkat.name ?? perangkat.address),
                                            trailing: TextButton(
                                              onPressed: () async {
                                                try {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Menyambungkan Perangkat Bluetooth.")),
                                                  );
                                                  setState(() {
                                                    _menyambungkan = true;
                                                  });
                                                  _koneksi = await BluetoothConnection.toAddress(perangkat.address); // untuk koneksi ke arduino
                                                  _perangkatTersambung = perangkat; 
                                                  _perangkatBluetooth = []; // mengosongkan kembali array perangkat
                                                  // _menyambungkan = false; // bugfix untuk bisa sambung lagi
                                                  _terimaData();
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Perangkat Bluetooth gagal tersambung.")),
                                                  );
                                                }
                                                // _perangkatBluetooth = []; // mengosongkan kembali array perangkat
                                                _menyambungkan = false; // bugfix untuk bisa sambung lagi
                                  
                                                // _terimaData();
                                                // // broadcast untuk mendapatkan data notifikasi dari arduino
                                                // Stream<Uint8List> streamData = _koneksi!.input!.asBroadcastStream();
                                                // // untuk data arus
                                                // streamData.listen((Uint8List listenData) {
                                                //   String stringNotifikasi = String.fromCharCodes(listenData).trim();
                                                //   // String stringNotifikasi = utf8.decode(listenData).trim();
                                                //   setState(() {
                                                //     _notifikasi = stringNotifikasi;
                                                //     print(_notifikasi);
                                                //     // // if (_notifikasi.indexOf('ERR_T') != -1) {
                                                //     // if (_notifikasi.contains('ERR_T')) {
                                                //     //   // simpan error ke database sejarah kerusakan
                                                //     //   databaseHelper().insertLogKerusakan("Sensor tegangan mendeteksi anomali pada saluran tegangan listrik mesin");
                                                //     // } else if (_notifikasi.contains('ERR_A')) {
                                                //     //   databaseHelper().insertLogKerusakan("Sensor arus mendeteksi anomali pada arus listrik yang mengalir ke mesin");
                                                //     // }
                                                //   });
                                                // });
                                                // // untuk notifikasi status mesin
                                                // streamData.listen((event) {
                                                //   // if (String.fromCharCodes(event) == "n1") {
                                                //   //   setState(() {
                                                //   //     _notifikasi = "Mesin Hidup";
                                                //   //   });
                                                //   // } else if (String.fromCharCodes(event) == "n0") {
                                                //   //   setState(() {
                                                //   //     _notifikasi = "Mesin Mati";
                                                //   //   });
                                                //   // } else 
                                                //   if (String.fromCharCodes(event) == "e1") {
                                                //     setState(() {
                                                //       _notifikasi = "Terdapat masalah dengan tegangan listrik mesin";
                                                //       // error
                                                //       databaseHelper().insertLogKerusakan("Sensor tegangan mendeteksi anomali pada saluran tegangan listrik mesin");
                                                //     });
                                                //   } else if (String.fromCharCodes(event) == "e2"){
                                                //     setState(() {
                                                //       _notifikasi = "Terdapat masalah dengan arus listrik mesin";
                                                //       // error
                                                //       databaseHelper().insertLogKerusakan("Sensor arus mendeteksi anomali pada arus listrik yang mengalir ke mesin");
                                                //     });
                                                //   }
                                                // });
                                  
                                                // refresh
                                                setState(() {});
                                                Navigator.pop(context);
                                              }, 
                                              child: Text("Sandingkan")
                                            ),
                                          )
                                        ]
                                      ],
                                    ),
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },  
                    child: Text("Cari")
                  ) : Text("") ,
                ),
                Switch(
                  value: _stateBluetooth, 
                  onChanged: (value) async {
                    if (value) {
                      await _bluetooth.requestEnable(); // mengaktifkan bluetooth
                    } else {
                      await _bluetooth.requestDisable(); // menonaktifkan bluetooth
                    }
                  },
                ),
              ],
            )
          ),
          // notifikasi
          Container(
            height: 105,
            child: ListTile(
              title: Text(style: TextStyle(fontSize: 20), "$_notifikasi"),
            ),
          ),
          // tombol on dan off
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.blue[100],
            child: Column(
              children: [
                Center(child: Text("Saklar Relay Mesin", style: TextStyle(fontSize: 18),),),
                SizedBox(height: 5,),
                InkWell(
                  onTap: () {
                    _kirimData("1");
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.green,
                    height: 120,
                    width: 250,
                    child: Center(child: Text("ON", style: TextStyle(fontSize: 40),)),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    _kirimData("0");
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.red,
                    height: 120,
                    width: 250,
                    child: Center(child: Text("OFF", style: TextStyle(fontSize: 40),)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.blue[100],
            child: Column(
              children: [
                Center(child: Text("Setting Pengaman Arus", style: TextStyle(fontSize: 18),),),
                // Row(
                //   children: [
                //     Container(
                //       width: 200,
                //       color: Colors.white,
                //       child: TextFormField(
                //         controller: _arusController,
                //         style: TextStyle(fontSize: 18),
                //         keyboardType: TextInputType.number,
                //         decoration: InputDecoration(
                //           label: Text("Input Limit Arus"),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5),
                //             borderSide: BorderSide(color: Colors.black, width: 2)
                //           ),
                //         ),
                //       ),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         _kirimDataArusMetodeString();
                //         FocusManager.instance.primaryFocus?.unfocus();
                //       }, 
                //       child: Text("tombol", style: TextStyle(fontSize: 20))
                //     )
                //   ],
                // ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        _kirimData("b");
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.red,
                        height: 75,
                        width: 150,
                        child: Center(child: Text("-", style: TextStyle(fontSize: 20),)),
                      ),
                    ),
                    // Text(_listenarus, style: TextStyle(fontSize: 20),)
                    SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        _kirimData("a");
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.green,
                        height: 75,
                        width: 150,
                        child: Center(child: Text("+", style: TextStyle(fontSize: 20),)),
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextButton.icon(
              //   onPressed: () {}, 
              //   icon: Icon(Icons.bluetooth_audio),
              //   label: Text("Monitoring"),
              // ),
              TextButton.icon(
                onPressed: () async {
                  final Uri url = Uri(
                    scheme: 'sms',
                    path: '+6281217237658',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    print('error');
                  }
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => akdm_smsgateway(),));
                }, 
                icon: Icon(Icons.sms),
                label: Text("SMS"),
              ),
              VerticalDivider(),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => akdm_history(),));
                }, 
                icon: Icon(Icons.history),
                label: Text("History"),
              ),
            ],
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       SizedBox(
      //         height: 100,
      //         child: DrawerHeader(
      //           child: Text("Pengaturan", style: TextStyle(fontSize: 24),)
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: ListTile(
      //           tileColor: Colors.orange,
      //           title: Text("Aktifkan Mode SMS", textAlign: TextAlign.center,),
      //           onTap: () {
      //             _kirimData("x");
      //           },
      //         ),
      //       ),
      //       ListTile(
      //         title: Text("Mengaktifkan Mode SMS akan menonaktifkan fungsi bluetooth pada mesin karena batasan hardware. Untuk mengaktifkan kembali fungsi bluetooth, kirim sms pada jendela SMS dengan mengirim pesan 'bton'"),
      //       ),
      //       ListTile(
      //         title: Text("Mematikan Mesin akan mengembalikan mesin ke mode Bluetooth"),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}