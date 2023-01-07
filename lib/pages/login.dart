import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_device_id/platform_device_id.dart';
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
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(flex: 1),
                        _AppIcon(),
                        SizedBox(height: 24),
                        _PageTitle(),
                        SizedBox(height: 24),
                        context.textFieldTitle("Kullanıcı Adı Veya E-posta"),
                        _UsernameField(user: _user),
                        SizedBox(height: 24),
                        context.textFieldTitle("Şifre"),
                        _PasswordField(pass: _pass),
                        SizedBox(height: 36),
                        _loginButton(),
                        Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await _loginButtonClick(context);
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
              color: Colors.white, fontSize: 14.1, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _loginButtonClick(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var loginStatus =
        await ApiServices.login(user: _user.text, pass: _pass.text);

    if (loginStatus["status"] == "1") {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      if (StudentModel.cihazId.isEmpty) {
        await _registerDevice(context, deviceId, loginStatus);
      } else if (StudentModel.cihazId == deviceId!) {
        await _accountRegisteredOnThisDevice(context, loginStatus);
      } else {
        await _accountRegisteredOnAnotherDevice(context);
      }
    } else {
      _statusFail(context, loginStatus);
    }
  }

  Future<void> _registerDevice(BuildContext context, String? deviceId,
      Map<String, String> loginStatus) async {
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
                if (!_isLoading) {
                  _isLoading = true;
                  await _writeUser();
                  await ApiServices.studentUpdate(deviceId: deviceId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loginStatus["text"].toString()),
                    ),
                  );
                  Navigator.pop(context);
                  NavigatorHelper.pushAndRemoveUntil(context,
                      page: HomePageUI());
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
  }

  Future<void> _accountRegisteredOnThisDevice(
      BuildContext context, Map<String, String> loginStatus) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loginStatus["text"].toString()),
      ),
    );
    await _writeUser();
    NavigatorHelper.pushAndRemoveUntil(context, page: HomePageUI());
  }

  Future<void> _accountRegisteredOnAnotherDevice(BuildContext context) async {
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

  void _statusFail(BuildContext context, Map<String, String> loginStatus) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loginStatus["text"].toString()),
      ),
    );
  }

  Future<void> _writeUser() async {
    await SecureFileService.writeUserInfo(
      user: _user.text.trim(),
      pass: _pass.text.trim(),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required TextEditingController pass,
  })  : _pass = pass,
        super(key: key);

  final TextEditingController _pass;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _pass,
      style: GoogleFonts.poppins(
        fontSize: 10.2,
        color: AppColors.black,
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      cursorColor: AppColors.black,
      decoration: context.appInputDecoration(hintText: ""),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({
    Key? key,
    required TextEditingController user,
  })  : _user = user,
        super(key: key);

  final TextEditingController _user;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _user,
      style: GoogleFonts.poppins(
        fontSize: 10.2,
        color: AppColors.black,
      ),
      keyboardType: TextInputType.emailAddress,
      cursorColor: AppColors.black,
      decoration:
          context.appInputDecoration(hintText: "Kullanıcı Adı Veya E-posta"),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Giriş Yap",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 21,
        color: AppColors.black,
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.width,
      child: SvgPicture.asset(
        AppSVGPaths.lessonIcon,
        alignment: Alignment.center,
        height: AppSize.height / 6,
      ),
    );
  }
}
