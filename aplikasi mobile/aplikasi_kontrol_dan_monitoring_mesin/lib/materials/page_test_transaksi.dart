// import 'package:aplikasi_kontrol_dan_monitoring_mesin/apis/api_database.dart';
// import 'package:aplikasi_kontrol_dan_monitoring_mesin/materials/page_backuprestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class pageTransaksi extends StatefulWidget {
//   const pageTransaksi({super.key});

//   @override
//   State<pageTransaksi> createState() => _pageTransaksiState();
// }

// class _pageTransaksiState extends State<pageTransaksi> {
  
//   final databaseHelper _databaseHelper = databaseHelper();

//   // list tabel
//   List<Map<String, dynamic>> _transaksi = [];
//   double _totalTransaksi = 0.0;
//   List<Map<String, dynamic>> _belanja = [];
//   double _totalBelanja = 0.0;
//   // tanggal untuk penjualan dan belanja sendiri
//   DateTime? _startDateDetail;
//   DateTime? _endDateDetail;
//   // format tanggal dan waktu
//   String _dateFormat_detail(String dateISO) { // konversi iso ke format indo
//     final dateTime = DateTime.parse(dateISO);
//     final format = DateFormat('dd-MM-yyyy hh:mm');
//     return format.format(dateTime);
//   }

//   // tanggal total laba rugi
//   DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
//   DateTime _endDate = DateTime.now();
//   // mapping untuk laporan
//   Map<String, dynamic> _laporan = {
//     'totalPenjualan': 0.0,
//     'totalBelanja': 0.0,
//     'labaBersih': 0.0,
//   };
//   // List<Map<String, double>> _laporanChart = [];
//   // format tanggal dan rupiah
//   final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');
//   final NumberFormat _uangFormat = NumberFormat.currency(
//     locale: 'id',
//     symbol: 'Rp',
//     decimalDigits: 0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _ambilTransaksi();
//     _ambilBelanja();
//     _ambilLaporan();
//     // _ambilLaporanChart();
//   }

//   // ambil semua data transaksi
//   Future<void> _ambilTransaksi() async {
//     _transaksi = await _databaseHelper.getTransaksi();
//     setState(() {});
//     // Database db = await _databaseHelper.database;
//     // transaksi = await db.query('transaksi');
//     // setState(() {}); // refresh
//   }
//   // ambil data transaksi periode tertentu
//   Future<void> _ambilTransaksiPeriode() async {
//     if (_startDateDetail == null || _endDateDetail == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("pilih rentang tanggal dahulu."))
//       );
//       return;
//     }
//     final transaksi = await _databaseHelper.getTransaksiPeriode(_startDateDetail!, _endDateDetail!);
//     double total = transaksi.fold(0.0, (sum, item) => sum + (item['total_harga'] as num).toDouble());
//     setState(() {
//       _transaksi = transaksi;
//       _totalTransaksi = total;
//     });
//   }
//   // ambil semua data belanja
//   Future<void> _ambilBelanja() async {
//     _belanja = await _databaseHelper.getBelanja();
//     setState(() {});
//   }
//   // ambil data belanja periode tertentu
//   Future<void> _ambilBelanjaPeriode() async {
//     if (_startDateDetail == null || _endDateDetail == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("pilih rentang tanggal dahulu."))
//       );
//       return;
//     }
//     final belanja = await _databaseHelper.getBelanjaPeriode(_startDateDetail!, _endDateDetail!);
//     double total = belanja.fold(0.0, (sum, item) => sum + (item['total_harga_belanja'] as num).toDouble());
//     setState(() {
//       _belanja = belanja;
//       _totalBelanja = total;
//     });
//   }
//   // refresh halaman transaksi dan belanja
//   Future<void> _refresh() {
//     _ambilTransaksi();
//     _ambilBelanja();
//     return Future.delayed(
//       Duration(seconds: 1),
//     );
//   }
//   // fungsi memilih tanggal khusus penjualan dan belanja
//   // Fungsi pilih tanggal
//   Future<void> _pilihTanggalPeriode(bool isStartDate) async {
//     final selectDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (selectDate != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDateDetail = selectDate;
//         } else {
//           _endDateDetail = selectDate;
//         }
//       });
//     }
//   }
//   // Format tanggal untuk UI
//   String _formatTanggal(DateTime? date) {
//     return date != null ? _dateFormat.format(date) : "Pilih Tanggal";
//   }

//   // untuk ambil laporan dari get laporan laba rugi
//   Future<void> _ambilLaporan() async {
//     final laporan = await _databaseHelper.getLaporanLabaRugi(_startDate, _endDate);
//     setState(() {
//       _laporan = laporan;
//     });
//   }
//   // void _ambilLaporanChart() async {
//   //   // Retrieve data for the specified date range
//   //   final List<Map<String, double>> data = await _databaseHelper.getLaporanLabaRugiPerHari(
//   //     _startDate,
//   //     _endDate,
//   //   );
//   //   setState(() {
//   //     _laporanChart = data;
//   //   });
//   // }
//   // fungsi memilih tanggal
//   Future<void> _pilihTanggal(BuildContext context, bool isStartDate) async {
//     final selectDate = await showDatePicker(
//       context: context, 
//       initialDate: isStartDate ? _startDate : _endDate,
//       firstDate: DateTime(2000), 
//       lastDate: DateTime.now(),
//     );
//     if (selectDate != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = selectDate;
//         } else {
//           _endDate = selectDate;
//         }
//       });
//       _ambilLaporan();
//     }
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Laporan Laba & Rugi"),
//           centerTitle: true,
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, 
//                   MaterialPageRoute(builder: (context) => pageBackupRestore(),)
//                 );
//               }, 
//               child: Icon(Icons.backup),
//             ),
//           ],
//           bottom: TabBar(tabs: [
//             Tab(icon: Icon(Icons.currency_exchange_outlined),),
//             Tab(icon: Icon(Icons.sell_outlined),),
//             Tab(icon: Icon(Icons.arrow_circle_up_outlined),),
//           ]),
//         ),
//         body: TabBarView(
//           children: [
//             // halaman tab total dari penjualan dan belanja
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: () => _pilihTanggal(context, true),
//                           child: Text(
//                             "Dari: ${_dateFormat.format(_startDate)}",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         Divider(
//                           color: Colors.black,
//                           thickness: 1,
//                         ),
//                         TextButton(
//                           onPressed: () => _pilihTanggal(context, false),
//                           child: Text(
//                             "Sampai: ${_dateFormat.format(_endDate)}",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Pendapatan: ${_uangFormat.format(_laporan['totalPenjualan'])}",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "Pengeluaran: ${_uangFormat.format(_laporan['totalBelanja'])}",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           SizedBox(height: 8),
//                           Divider(),
//                           Text(
//                             _laporan['labaBersih'] >= 0 ?
//                             "Laba: ${_uangFormat.format(_laporan['labaBersih'])}" : "Rugi: ${_uangFormat.format(_laporan['labaBersih'])}",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: _laporan['labaBersih'] >= 0 ? Colors.green : Colors.red,
//                             ),
//                             // "Laba Bersih: ${_uangFormat.format(_laporan['labaBersih'])}",
//                             // style: TextStyle(
//                             //   fontSize: 20,
//                             //   fontWeight: FontWeight.bold,
//                             //   color: _laporan['labaBersih'] >= 0
//                             //       ? Colors.green
//                             //       : Colors.red,
//                             // ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // chart - belum bisa
//                   // Expanded(
//                   //   child: _laporanChart.isEmpty ? Center(child: CircularProgressIndicator()) : Padding(
//                   //     padding: const EdgeInsets.all(16.0),
//                   //     child: LineChart(
//                   //       LineChartData(
//                   //         titlesData: FlTitlesData(
//                   //           leftTitles: AxisTitles(
//                   //             sideTitles: SideTitles(
//                   //               showTitles: true,
//                   //               reservedSize: 40,
//                   //               // getTitlesWidget: (value, meta) {
//                   //               //   return Text(value.toInt().toString(), style: TextStyle(fontSize: 12),);
//                   //               // },
//                   //             ),
//                   //           ),
//                   //           bottomTitles: AxisTitles(
//                   //             sideTitles: SideTitles(
//                   //               showTitles: true,
//                   //               reservedSize: 40,
//                   //               // getTitlesWidget: (value, meta) {
//                   //               //   final index = value.toInt();
//                   //               //   if (index < _laporanChart.length) {
//                   //               //     final date = _startDate.add(Duration(days: index)).toIso8601String();
//                   //               //     return Text(date, style: TextStyle(fontSize: 10),);
//                   //               //   }
//                   //               //   return Text('');
//                   //               // },
//                   //             ),
//                   //           ) 
//                   //         ),
//                   //         gridData: FlGridData(show: true),
//                   //         borderData: FlBorderData(show: true),
//                   //         // lineBarsData: [
//                   //         //   LineChartBarData(
//                   //         //     spots: _generateLineSpots('Pendapatan'),
//                   //         //     isCurved: true,
//                   //         //     color: Colors.green,
//                   //         //     barWidth: 4,
//                   //         //     isStrokeCapRound: true,
//                   //         //     belowBarData: BarAreaData(show: false),
//                   //         //   ),
//                   //         //   LineChartBarData(
//                   //         //     spots: _generateLineSpots('Pengeluaran'),
//                   //         //     isCurved: true,
//                   //         //     color: Colors.red,
//                   //         //     barWidth: 4,
//                   //         //     isStrokeCapRound: true,
//                   //         //     belowBarData: BarAreaData(show: false),
//                   //         //   ),
//                   //         //   LineChartBarData(
//                   //         //     spots: _generateLineSpots('LabaBersih'),
//                   //         //     isCurved: true,
//                   //         //     color: Colors.blue,
//                   //         //     barWidth: 4,
//                   //         //     isStrokeCapRound: true,
//                   //         //     belowBarData: BarAreaData(show: false),
//                   //         //   ),
//                   //         // ],
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),

//             // halaman tab penjualan
//             // RefreshIndicator(
//             //   onRefresh: _refresh,
//             //   child: _transaksi.isEmpty ? Center(child: Text("Tidak ada transaksi yang ditemukan"),) : ListView.builder(
//             //     itemCount: _transaksi.length,
//             //     itemBuilder: (context, index) {
//             //       final transaksi_item = _transaksi[index];
//             //       return ListTile(
//             //         title: Text(style: TextStyle(fontSize: 20), "Produk ID: ${transaksi_item['produk_id']} Nama: ${transaksi_item['produk_nama']}"),
//             //         subtitle: Text(style: TextStyle(fontSize: 20), "Jumlah: ${transaksi_item['jumlah_item_transaksi']} - Total Harga: ${_uangFormat.format(transaksi_item['total_harga'])} \nTanggal: ${_dateFormat_detail(transaksi_item['tgl_transaksi']) }"),
//             //         // trailing: Text("Tanggal: ${transaksi_item['tgl_transaksi']}"),
//             //         isThreeLine: true,
//             //       );
//             //     },
//             //   ),
//             // ),
//             Column(
//               children: [
//                 // Input tanggal
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pilihTanggalPeriode(true),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(_formatTanggal(_startDateDetail)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pilihTanggalPeriode(false),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(_formatTanggal(_endDateDetail)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: _ambilTransaksiPeriode,
//                         child: Text("Tampilkan"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 // List transaksi
//                 Expanded(
//                   child: _transaksi.isEmpty ? Center(child: Text("Tidak ada transaksi")) : ListView.builder(
//                     itemCount: _transaksi.length,
//                     itemBuilder: (context, index) {
//                       final transaksi_item = _transaksi[index];
//                       return ListTile(
//                         // title: Text("ID: ${transaksi['id']}"),
//                         // subtitle: Text("Tanggal: ${_formatTanggal(DateTime.parse(transaksi['tgl_transaksi']))}"),
//                         // trailing: Text("Rp ${transaksi['total_harga']}"),Produk ID: ${transaksi_item['produk_id']}
//                         title: Text(style: TextStyle(fontSize: 20), "Nama: ${transaksi_item['nama_produk']}"),
//                         subtitle: Text(style: TextStyle(fontSize: 20), "Jumlah: ${transaksi_item['jumlah_item_transaksi']} - Total Harga: ${_uangFormat.format(transaksi_item['total_harga'])} \nTanggal: ${_dateFormat_detail(transaksi_item['tgl_transaksi']) }"),
//                         isThreeLine: true,
//                       );
//                     },
//                   ),
//                 ),
//                 Divider(),
//                 // Total transaksi
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Total Penjualan:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       Text("Rp $_totalTransaksi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             // halaman tab untuk belanja
//             // RefreshIndicator(
//             //   onRefresh: _refresh,
//             //   child: _belanja.isEmpty ? Center(child: Text("Tidak ada belanja yang ditemukan"),) : ListView.builder(
//             //     itemCount: _belanja.length,
//             //     itemBuilder: (context, index) {
//             //       final belanja_item = _belanja[index];
//             //       return ListTile(
//             //         title: Text(style: TextStyle(fontSize: 20), "${belanja_item['item_belanja']}"),
//             //         subtitle: Text(style: TextStyle(fontSize: 20), "Biaya: ${_uangFormat.format(belanja_item['total_harga_belanja'])} Quantity: ${belanja_item['quantity_belanja']}${belanja_item['satuan']} \nTanggal: ${_dateFormat_detail(belanja_item['tgl_belanja'])}"),
//             //         isThreeLine: true,
//             //       );
//             //     },
//             //   ),
//             // ),
//             Column(
//               children: [
//                 // Input tanggal
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pilihTanggalPeriode(true),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(_formatTanggal(_startDateDetail)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pilihTanggalPeriode(false),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(_formatTanggal(_endDateDetail)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: _ambilBelanjaPeriode,
//                         child: Text("Tampilkan"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 // List belanja
//                 Expanded(
//                   child: _belanja.isEmpty ? Center(child: Text("Tidak ada belanja")) : ListView.builder(
//                     itemCount: _belanja.length,
//                     itemBuilder: (context, index) {
//                       final belanja_item = _belanja[index];
//                       return ListTile(
//                         title: Text(style: TextStyle(fontSize: 20), "${belanja_item['item_belanja']}"),
//                         subtitle: Text(style: TextStyle(fontSize: 20), "Biaya: ${_uangFormat.format(belanja_item['total_harga_belanja'])} Quantity: ${belanja_item['quantity_belanja']}${belanja_item['satuan']} \nTanggal: ${_dateFormat_detail(belanja_item['tgl_belanja'])}"),
//                         isThreeLine: true,
//                       );
//                     },
//                   ),
//                 ),
//                 Divider(),
//                 // Total belanja
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Total Belanja:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       Text("Rp $_totalBelanja", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),



//             // RefreshIndicator(
//             //   onRefresh: _refresh,
//             //   child: _transaksi.isEmpty ? Center(child: Text("Tidak ada transaksi yang ditemukan"),) : ListView.builder(
//             //     itemCount: _transaksi.length,
//             //     itemBuilder: (context, index) {
//             //       final transaksi_item = _transaksi[index];
//             //       // 3 variabel untuk menghilangkan desimal di tampilan
//             //       double harga_item = transaksi_item['total_harga'];
//             //       String harga_item_string = harga_item.toInt().toString();
//             //       var harga_item_split = harga_item_string.split('.'); // array 0 untuk bilangan kiri, array 1 untuk bilangan kanan
//             //       return ListTile(
//             //         title: Text(style: TextStyle(fontSize: 20), "Produk ID: ${transaksi_item['produk_id']} Nama: ${transaksi_item['produk_nama']}"),
//             //         subtitle: Text(style: TextStyle(fontSize: 20), "Jumlah: ${transaksi_item['jumlah_item_transaksi']} - Total Harga: Rp ${harga_item_split[0]} \nTanggal: ${transaksi_item['tgl_transaksi']}"),
//             //         // trailing: Text("Tanggal: ${transaksi_item['tgl_transaksi']}"),
//             //         isThreeLine: true,
//             //       );
//             //     },
//             //   ),
//             // ),
//             // RefreshIndicator(
//             //   onRefresh: _refresh,
//             //   child: _belanja.isEmpty ? Center(child: Text("Tidak ada belanja yang ditemukan"),) : ListView.builder(
//             //     itemCount: _belanja.length,
//             //     itemBuilder: (context, index) {
//             //       final belanja_item = _belanja[index];
//             //       DateTime tgl_belanja = belanja_item['tgl_belanja'];
//             //       String tgl_terformat = DateFormat('dd/MM/yyyy - HH:mm:ss').format(tgl_belanja);
//             //       return ListTile(
//             //         title: Text("${belanja_item['item_belanja']}"),
//             //         subtitle: Text("Biaya: ${belanja_item['total_harga_belanja']} \nTanggal: ${tgl_terformat}"),
//             //         isThreeLine: true,
//             //       );
//             //     },
//             //   ),
//             // ),
//             // RefreshIndicator(
//             //   onRefresh: _refresh,
//             //   child: _belanja.isEmpty ? Center(child: Text("Tidak ada belanja yang ditemukan"),) : ListView.builder(
//             //     itemCount: _belanja.length,
//             //     itemBuilder: (context, index) {
//             //       final belanja_item = _belanja[index];
//             //       // 3 variabel untuk menghilangkan desimal di tampilan
//             //       double harga_belanja = belanja_item['total_harga_belanja'];
//             //       String harga_belanja_string = harga_belanja.toInt().toString();
//             //       var harga_belanja_split = harga_belanja_string.split('.');
//             //       return ListTile(
//             //         title: Text(style: TextStyle(fontSize: 20), "${belanja_item['item_belanja']}"),
//             //         subtitle: Text(style: TextStyle(fontSize: 20), "Biaya: ${harga_belanja_split[0]} Quantity: ${belanja_item['quantity_belanja']}${belanja_item['satuan']} \nTanggal: ${belanja_item['tgl_belanja']}"),
//             //         isThreeLine: true,
//             //       );
//             //     },
//             //   ),
//             // ),
//           ]
//         ),
//       ),
//     );
//   }
//   // // Generate data points for a specific type ('Pendapatan', 'Pengeluaran', 'LabaBersih')
//   // List<FlSpot> _generateLineSpots(String type) {
//   //   return _laporanChart.asMap().entries.map((entry) {
//   //     final index = entry.key.toDouble();
//   //     final data = entry.value[type] ?? 0.0;
//   //     return FlSpot(index, data);
//   //   }).toList();
//   // }
// }