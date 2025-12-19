// import 'package:aplikasi_kontrol_dan_monitoring_mesin/apis/api_database.dart';
// import 'package:flutter/material.dart';

// class pageBackupRestore extends StatelessWidget {
//   // pageBackupRestore({super.key});
//   final databaseHelper _databaseHelper = databaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Backup & Restore Database"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15),
//         child: Container(
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // SizedBox(
//               //   height: 60,
//               //   width: 300,
//               //   child: ElevatedButton(
//               //     onPressed: () async {
//               //       await _databaseHelper.getDBPath();
//               //       ScaffoldMessenger.of(context).showSnackBar(
//               //         SnackBar(content: Text("Mencari Path Database")),
//               //       );
//               //     }, 
//               //     child: Text("Path Database", style: TextStyle(fontSize: 24, color: Colors.white),),
//               //     style: ElevatedButton.styleFrom(primary: Colors.black),
//               //   ),
//               // ),
//               // SizedBox(height: 20,),
//               SizedBox(
//                 height: 60,
//                 width: 300,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // await _databaseHelper.backupDatabase();
//                     await _databaseHelper.backupDatabase();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Backup berhasil")),
//                     );
//                   }, 
//                   child: Text("Backup Database", style: TextStyle(fontSize: 24, color: Colors.white),),
//                   style: ElevatedButton.styleFrom(primary: Colors.black),
//                 ),
//               ),
//               SizedBox(height: 20,),
//               SizedBox(
//                 height: 60,
//                 width: 300,
//                 child: ElevatedButton(
//                   onPressed: () async{
//                     // await _databaseHelper.restoreDatabase();
//                     await _databaseHelper.restoreDatabase();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Restore Berhasil")),
//                     );
//                   }, 
//                   child: Text("Restore Database", style: TextStyle(fontSize: 24, color: Colors.white),),
//                   style: ElevatedButton.styleFrom(primary: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }