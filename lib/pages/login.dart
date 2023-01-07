import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:safe_device/safe_device.dart';
import 'package:yoklama_takip/models/student.dart';
import 'package:yoklama_takip/pages/home_page.dart';
import 'package:yoklama_takip/services/api_service.dart';
import 'package:yoklama_takip/services/file_service.dart';
import 'package:yoklama_takip/utils/navigation_helper.dart';
import 'package:yoklama_takip/widgets/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_size.dart';
import '../utils/app_svgs.dart';
import '../widgets/loading_listener.dart';
// import 'package:kablonetkonya/model/user.dart';
// import 'package:kablonetkonya/services/api_service.dart';
// import 'package:kablonetkonya/services/file_service.dart';
// import 'package:kablonetkonya/utils/app_colors.dart';
// import 'package:kablonetkonya/utils/app_size.dart';
// import 'package:kablonetkonya/utils/app_svgs.dart';
// import 'package:kablonetkonya/utils/extensions.dart';
// import 'package:kablonetkonya/view/pages/applications.dart';
// import '../widgets/loading_listener.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  late TextEditingController _user;
  late TextEditingController _pass;
  bool _isLoading = false;

  @override
  void initState() {
    _user = TextEditingController(text: "183301070");
    _pass = TextEditingController(text: "123");
    // TODO: implement initState
    super.initState();
  }

  // Future<void> _getPermission() async {
  //   // if (await Permission.contacts.request().isGranted) {
  //   //   // Either the permission was already granted before or the user just granted it.
  //   // }

  //   // You can request multiple permissions at once.
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.locationAlways,
  //   ].request();

  //   print(statuses[Permission.location]);
  // }

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingListenerUI(
          isLoading: _isLoading,
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSize.width,
                      // child: SvgPicture.string(
                      //   AppSVG.logo,
                      //   alignment: Alignment.center,
                      //   height: 75,
                      // ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Giriş Yap",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    context.textFieldTitle("Kullanıcı Adı Veya E-posta"),
                    TextFormField(
                      controller: _user,
                      style: GoogleFonts.poppins(
                        fontSize: 10.2,
                        color: AppColors.black,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColors.black,
                      decoration: context.appInputDecoration(
                          hintText: "Kullanıcı Adı Veya E-posta"),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    context.textFieldTitle("Şifre"),
                    TextFormField(
                      controller: _pass,
                      style: GoogleFonts.poppins(
                        fontSize: 10.2,
                        color: AppColors.black,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      cursorColor: AppColors.black,
                      decoration: context.appInputDecoration(hintText: ""),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          var loginStatus = await ApiServices.login(
                              user: _user.text, pass: _pass.text);

                          if (loginStatus["status"] == "1") {
                            String? deviceId =
                                await PlatformDeviceId.getDeviceId;
                            if (StudentModel.cihazId.isEmpty) {
                              setState(() {
                                _isLoading = false;
                              });
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Cihaz kayıt edilsin mi?"),
                                    content: Text(
                                      "Bu cihaz \'" +
                                          StudentModel.adSoyad +
                                          "\' isimli öğrenci ile eşleştirilirse sadece bu cihazdan yoklamaya katılabileceksiniz. Cihaz eşleştirmesini yeniden yapmak için öğrenci işlerine başvurmanız gerekmektedir.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          // setState(() {
                                          //   _isLoading = true;
                                          // });
                                          // Navigator.pop(context);
                                          if (!_isLoading) {
                                            _isLoading = true;
                                            await _writeUser();
                                            await ApiServices.studentUpdate(
                                                deviceId: deviceId!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    loginStatus["text"]
                                                        .toString()),
                                              ),
                                            );
                                            Navigator.pop(context);
                                            NavigatorHelper.pushReplacement(
                                                context,
                                                child: HomePageUI());
                                          }
                                        },
                                        child: Text("Devam"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("İptal"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (StudentModel.cihazId == deviceId!){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loginStatus["text"].toString()),
                                ),
                              );
                              await _writeUser();
                              NavigatorHelper.pushReplacement(context,
                                  child: HomePageUI());
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Hata!"),
                                    content: Text(
                                        "Bu öğrenci daha önce başka bir cihaz ile eşleştirilmiş. Sorun olduğunu düşünüyorsanız öğrenci işleri ile irtibata geçiniz."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Tamam")),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loginStatus["text"].toString()),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.04),
                          ),
                        ),
                        child: Text(
                          "Giriş Yap",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _writeUser() async {
    await SecureFileService
        .writeUserInfo(
      user: _user.text.trim(),
      pass: _pass.text.trim(),
    );
  }
}
