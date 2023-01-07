import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:yoklama_takip/models/join_inspection.dart';
import 'package:yoklama_takip/pages/home_page.dart';
import 'package:yoklama_takip/services/api_service.dart';
import 'package:yoklama_takip/utils/navigation_helper.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key? key,
    required this.lat,
    required this.long,
  }) : super(key: key);

  final double lat;
  final double long;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       if (result != null)
          //         Text(
          //           'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
          //           maxLines: 3,
          //         )
          //       else
          //         const Text('Scan a code'),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           Container(
          //             margin: const EdgeInsets.all(8),
          //             child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.toggleFlash();
          //                   setState(() {});
          //                 },
          //                 child: FutureBuilder(
          //                   future: controller?.getFlashStatus(),
          //                   builder: (context, snapshot) {
          //                     return Text('Flash: ${snapshot.data}');
          //                   },
          //                 )),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.all(8),
          //             child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.flipCamera();
          //                   setState(() {});
          //                 },
          //                 child: FutureBuilder(
          //                   future: controller?.getCameraInfo(),
          //                   builder: (context, snapshot) {
          //                     if (snapshot.data != null) {
          //                       return Text(
          //                           'Camera facing ${describeEnum(snapshot.data!)}');
          //                     } else {
          //                       return const Text('loading');
          //                     }
          //                   },
          //                 )),
          //           )
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           Container(
          //             margin: const EdgeInsets.all(8),
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 await controller?.pauseCamera();
          //               },
          //               child:
          //                   const Text('pause', style: TextStyle(fontSize: 20)),
          //             ),
          //           ),
          //           Container(
          //             margin: const EdgeInsets.all(8),
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 await controller?.resumeCamera();
          //               },
          //               child: const Text('resume',
          //                   style: TextStyle(fontSize: 20)),
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    var scanArea = MediaQuery.of(context).size.width * 0.8;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      log(scanData.code.toString());
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      String? deviceId = await PlatformDeviceId.getDeviceId;
      var _inspectionStatus = await ApiServices.getInspectionInfo(
        deviceId: deviceId!,
        inspectionCode: result!.code.toString(),
      );
      // log(_inspectionStatus.toString());
      if (_inspectionStatus['status'] == "1") {
        double _distance = Geolocator.distanceBetween(
          JoinInspectionModel.fakulteLat,
          JoinInspectionModel.fakulteLong,
          widget.lat,
          widget.long,
        );
        if (_distance > 100) {
          var _joinInspectionStatus = await ApiServices.joinTheInspection(
            deviceId: deviceId,
            inspectionCode: result!.code.toString(),
          );
          log(_joinInspectionStatus.toString());
          if (_joinInspectionStatus['status'] == "1") {
            _showDialog(
                content: _joinInspectionStatus['text'].toString(),
                actionTap: () {
                  NavigatorHelper.pushReplacement(
                    context,
                    child: HomePageUI(),
                  );
                });
          }
        } else {
          var _error = "Dersin işlendiği fakülteden çok uzaktasınız.";
          log(_error);
          await _showDialog(
            content: _error,
            isError: true,
            actionTap: () {
              Navigator.pop(context);
            },
          );
        }
        log(_distance.toString() + " meters");
      } else {
        log("Lütfen geçerli bir kare kod okutunuz");
        controller.resumeCamera();
      }
      // if(result!.code != null){

      //   Navigator.pop(context);
      // }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _showDialog(
      {required String content,
      required void Function() actionTap,
      bool isError = false}) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: isError
                ? Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 32,
                  )
                : Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 32,
                  ),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: actionTap,
                child: Text("Devam"),
              ),
            ],
          );
        });
  }
}
