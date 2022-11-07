import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:safe_device/safe_device.dart';
import 'package:yoklama_takip/pages/qr_code.dart';
import 'package:yoklama_takip/utils/app_colors.dart';
import 'package:yoklama_takip/utils/app_size.dart';
import 'package:yoklama_takip/utils/app_svgs.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  Widget _itemBox({Widget? child}) {
    return Container(
      width: AppSize.width / 2.5,
      height: AppSize.width / 2.5,
      padding: EdgeInsets.all(AppSize.width / 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(),
        ],
      ),
      child: child,
    );
  }

  Widget _itemChild({
    required String svgPath,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.string(
          // AppSVG.qrCodeIcon,
          svgPath,
          width: AppSize.width / 8,
          color: Colors.black,
        ),
        Text(
          // "Yoklamaya Katıl",
          label,
          style: TextStyle(
            fontSize: AppSize.width / 22,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Yoklama Takip Sistemi",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TextButton(
            //   onPressed: () async {
            //     if (await SafeDevice.isSafeDevice) {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => QRViewExample()));
            //     } else {
            //       log("hackersın sen");
            //     }
            //   },
            //   child: Text("QR View"),
            // ),
            // TextButton(
            //   onPressed: () async {
            //     Location location = new Location();
            //     bool ison = await location.serviceEnabled();
            //     if (!ison) {
            //       //if defvice is off
            //       bool isturnedon = await location.requestService();
            //       if (isturnedon) {
            //         log("GPS device is turned ON");
            //       } else {
            //         log("GPS Device is still OFF");
            //       }
            //     } else {
            //       location.requestPermission();
            //       var xd = await location.hasPermission();
            //       if (xd == PermissionStatus.denied ||
            //           xd == PermissionStatus.deniedForever) {
            //         permissionHandler.openAppSettings();
            //       } else {
            //         log("Konum izni verildi");
            //       }
            //     }
            //   },
            //   child: Text(
            //     "Konum ayarı açık mı kontrolü? ",
            //   ),
            // ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              color: AppColors.backgroundColor1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Hoşgeldin,\nEmre Cambolat",
                  style: TextStyle(
                    fontSize: AppSize.width / 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: AppSize.width,
                  height: AppSize.width / 5,
                  color: AppColors.backgroundColor1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRViewExample()));
                      },
                      child: _itemBox(
                        child: _itemChild(
                          svgPath: AppSVG.qrCodeIcon,
                          label: "Yoklamaya Katıl",
                        ),
                      ),
                    ),
                    _itemBox(
                      child: _itemChild(
                        svgPath: AppSVG.qrCodeIcon,
                        label: "Derslerim",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
