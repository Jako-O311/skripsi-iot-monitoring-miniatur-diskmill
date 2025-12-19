import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_kontrol_dan_monitoring_mesin/apis/api_database.dart';

class akdm_history extends StatefulWidget {
  const akdm_history({super.key});

  @override
  State<akdm_history> createState() => _akdm_historyState();
}

class _akdm_historyState extends State<akdm_history> {
  final databaseHelper _databaseHelper = databaseHelper();
  
  // list tabel
  List<Map<String, dynamic>> _logKerusakan = [];
  // variabel untuk Log Kerusakan sebagai opsi pilih tanggal
  DateTime? _startDateDetail;
  DateTime? _endDateDetail;
  // format tanggal dan waktu
  String _dateFormat_detail(String dateISO) { // konversi iso ke format indo
    final dateTime = DateTime.parse(dateISO);
    final format = DateFormat('dd-MM-yyyy hh:mm');
    return format.format(dateTime);
  }
  // format tanggal
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');

  // ambil semua data log kerusakan
  Future<void> _ambilLog() async {
    _logKerusakan = await _databaseHelper.getLogKerusakan();
    setState(() {});
  }
  // ambil data history log kerusakan periode tertentu
  Future<void> _ambilLogPeriode() async {
    if (_startDateDetail == null || _endDateDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("pilih rentang tanggal dahulu."))
      );
      return;
    }
    final log = await _databaseHelper.getLogKerusakanPeriode(_startDateDetail!, _endDateDetail!);
    setState(() {
      _logKerusakan = log;
    });
  }
  // refresh halaman history log
  Future<void> _refresh() {
    _ambilLog();
    return Future.delayed(
      Duration(seconds: 1),
    );
  }
  // Fungsi pilih tanggal
  Future<void> _pilihTanggalPeriode(bool isStartDate) async {
    final selectDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectDate != null) {
      setState(() {
        if (isStartDate) {
          _startDateDetail = selectDate;
        } else {
          _endDateDetail = selectDate;
        }
      });
    }
  }
  // Format tanggal untuk UI
  // dengan return bukan null jika sudah tersetting jika tidak = string pilih tanggal
  String _formatTanggal(DateTime? date) {
    return date != null ? _dateFormat.format(date) : "Pilih Tanggal";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ambilLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sejarah Kerusakan"),
      ),
      body: Center(
        child: Column(
          children: [
            // jendela history
            Container(
              height: 580,
              child: Column(
                children: [
                  // Input tanggal
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pilihTanggalPeriode(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(_formatTanggal(_startDateDetail)),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pilihTanggalPeriode(false),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(_formatTanggal(_endDateDetail)),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _ambilLogPeriode,
                          child: Text("Tampilkan"),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // List log kerusakan
                  Container(
                    height: 482,
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      // child: Expanded(
                        child: _logKerusakan.isEmpty ? Center(child: Text("Tidak ada error")) : ListView.builder(
                          itemCount: _logKerusakan.length,
                          itemBuilder: (BuildContext context, int index) {
                            final logError = _logKerusakan[index];
                            return ListTile(
                              title: Text(style: TextStyle(fontSize: 18), "${logError['deskripsi_error']}"),
                              subtitle: Text(style: TextStyle(fontSize: 18), "Tanggal: ${_dateFormat_detail(logError['tgl_kerusakan'])}"),
                              // isThreeLine: true,
                            );
                          },
                        ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              // color: Colors.amber,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: ElevatedButton(
                    onPressed: () async {
                      await _databaseHelper.backupDatabase();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Backup database berhasil.")),
                      );
                    }, 
                    child: Text("Backup DB", style: TextStyle(fontSize: 19, color: Colors.white),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _databaseHelper.restoreDatabase();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Restore database berhasil."))
                        );
                        _refresh();
                      }, 
                      child: Text("Restore DB", style: TextStyle(fontSize: 19, color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            title: Text("Delete Database"),
                            content: Text("Hapus database log kerusakan mesin dari aplikasi?"),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _databaseHelper.deleteDatabase();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Delete database berhasil."))
                                  );
                                  _refresh();
                                }, 
                                child: Text("HAPUS")
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                child: Text("BATAL")
                              ),
                            ],
                          ),
                        );
                        
                      }, 
                      child: Icon(Icons.delete_forever, color: Colors.white,),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}