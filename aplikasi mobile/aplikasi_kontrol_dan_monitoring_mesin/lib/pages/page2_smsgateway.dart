import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
// import 'package:sms_advanced/sms_advanced.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class akdm_smsgateway extends StatefulWidget {
  const akdm_smsgateway({super.key});

  @override
  State<akdm_smsgateway> createState() => _akdm_smsgatewayState();
}

class _akdm_smsgatewayState extends State<akdm_smsgateway> {

  // final String phoneNumber = "+62XXXXXXXXXX"; // Nomor SIM800L
  // String receivedMessage = "Belum ada pesan masuk";
  // final String _nomorArduino = '';
  // final SmsQuery query = SmsQuery();
  // List<SmsThread> threads = [];

  @override
  void initState() {
    super.initState();
    // _requestPermissions();
    // query.getAllThreads.then((value) {
    //   threads = value;
    //   setState(() {});
    // });
  }

  // void _requestPermissions() async {
  //   await Permission.sms.request();
  // }

  // void sendSMS(String message) async {
  //   try {
  //     // String result = await sendSMS(message: message, recipients: []);
  //     print("SMS Sent: $result");
  //   } catch (e) {
  //     print("Error Sending SMS: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Halaman Fitur SMS"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // final _sms = 'sms:$_nomorArduino';
            // if (await canLaunch(_sms)) {
            //   await launch(_sms);
            // }
            final Uri url = Uri(
              scheme: 'sms',
              path: '',
            );
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              print('error');
            }
          }, 
          child: Text("test sms")
        ),
      ),
      // body: ListView.builder(
      //   itemCount: threads.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         ListTile(
      //           minVerticalPadding: 8,
      //           minLeadingWidth: 4,
      //           title: Text(threads[index].messages.last.body ?? 'empty'),
      //           subtitle: Text(threads[index].contact?.address ?? 'empty'),
      //         ),
      //         const Divider()
      //       ],
      //     );
      //   },
      // ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //       onPressed: () => sendSMS("ON"),
      //       child: Text("Hidupkan Relay"),
      //     ),
      //     ElevatedButton(
      //       onPressed: () => sendSMS("OFF"),
      //       child: Text("Matikan Relay"),
      //     ),
      //     ElevatedButton(
      //       onPressed: () => sendSMS("SET ARUS 15.0"),
      //       child: Text("Set Batas Arus ke 15A"),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.all(20),
      //       child: Text("Pesan Terbaru: $receivedMessage"),
      //     ),
      //   ],
      // ),
      // body: Center(
      //   child: Text("Halaman Fitur SMS"),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         TextButton.icon(
      //           onPressed: () {
      //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => akdm_monitor(),));
      //           }, 
      //           icon: Icon(Icons.bluetooth_audio),
      //           label: Text("Monitoring"),
      //         ),
      //         TextButton.icon(
      //           onPressed: () {}, 
      //           icon: Icon(Icons.sms),
      //           label: Text("SMS"),
      //         ),
      //         TextButton.icon(
      //           onPressed: () {
      //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => akdm_history(),));
      //           }, 
      //           icon: Icon(Icons.history),
      //           label: Text("History"),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}