import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:safe_device/safe_device.dart';
import 'package:yoklama_takip/models/student.dart';
import 'package:yoklama_takip/pages/about_app.dart';
import 'package:yoklama_takip/pages/check_location.dart';
import 'package:yoklama_takip/pages/login.dart';
import 'package:yoklama_takip/pages/my_lessons.dart';
import 'package:yoklama_takip/pages/qr_code.dart';
import 'package:yoklama_takip/services/file_service.dart';
import 'package:yoklama_takip/utils/app_colors.dart';
import 'package:yoklama_takip/utils/app_size.dart';
import 'package:yoklama_takip/utils/app_svgs.dart';
import 'package:yoklama_takip/utils/navigation_helper.dart';
import 'package:yoklama_takip/widgets/app_willpopscope.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _itemBox({Widget? child, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
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
          // color: Colors.black,
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

  Widget _drawerMenu() {


    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 96,
                child: Row(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      margin: EdgeInsets.only(
                        right: 16,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.userAvatarColor1,
                        borderRadius: BorderRadius.circular(6.5),
                      ),
                      child: Text(
                        StudentModel.adSoyadBasHarf,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StudentModel.adSoyad,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          StudentModel.ogrenciNo,
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        InkWell(
                          onTap: () async {
                            // setState(() {
                            //   _isSaving = true;
                            // });
                            // await OneSignal.shared.removeExternalUserId();
                            // await SecureFileService.exitUser();
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => LoginUI(),
                            //   ),
                            // );
                            await SecureFileService.exitUser();
                            NavigatorHelper.pushReplacement(context,
                                child: LoginUI());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6.5)),
                            child: Text(
                              "Çıkış Yap",
                              style: TextStyle(
                                color: AppColors.userAvatarColor1,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Divider(
              //   height: 8,
              //   // indent: 2,
              // ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => RemindersUI(),
                    //   ),
                    // );
                    // _scaffoldKey.currentState!.closeEndDrawer();
                    NavigatorHelper.push(context, child: CheckLocationUI());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Yoklamaya Katıl",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                child: InkWell(
                  onTap: () {
                    NavigatorHelper.push(context, child: MyLessonsUI());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Derslerim",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => RemindersTwoUI(),
                    //   ),
                    // );
                    NavigatorHelper.push(context, child: AboutAppUI());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Uygulama Hakkında",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 12,
                // thickness: 1.2,
                color: Colors.black26,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppWillPopScope(
      child: Scaffold(
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
        endDrawer: _drawerMenu(),
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
                    "Hoşgeldin,\n${StudentModel.adSoyad}",
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
                      _itemBox(
                        onTap: () {
                          NavigatorHelper.push(context,
                              child: CheckLocationUI());

                        },
                        child: _itemChild(
                          svgPath: AppSVG.qrCodeIcon,
                          label: "Yoklamaya Katıl",
                        ),
                      ),
                      _itemBox(
                        onTap: () {
                          NavigatorHelper.push(context, child: MyLessonsUI());
                        },
                        child: _itemChild(
                          svgPath: AppSVG.lessonIcon,
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
      ),
    );
  }
}
