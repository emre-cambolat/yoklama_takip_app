import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yoklama_takip/models/student.dart';
import 'package:yoklama_takip/pages/about_app.dart';
import 'package:yoklama_takip/pages/check_location.dart';
import 'package:yoklama_takip/pages/login.dart';
import 'package:yoklama_takip/pages/my_lessons.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppWillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
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
        endDrawer: _AppDrawerMenu(context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _WelcomeTitle(),
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
                      _ItemBox(
                        onTap: () {
                          NavigatorHelper.push(context,
                              child: CheckLocationUI());
                        },
                        child: _ItemChild(
                            svgPath: AppSVGPaths.qrCodeIcon,
                            label: "Yoklamaya Katıl"),
                      ),
                      _ItemBox(
                        onTap: () {
                          NavigatorHelper.push(context, child: MyLessonsUI());
                        },
                        child: _ItemChild(
                            svgPath: AppSVGPaths.lessonIcon,
                            label: "Derslerim"),
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

class _AppDrawerMenu extends StatelessWidget {
  const _AppDrawerMenu({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
              _UserInfoBox(),
              _DrawerMenuButton(
                context: context,
                title: "Yoklamaya Katıl",
                onTap: () =>
                    NavigatorHelper.push(context, child: CheckLocationUI()),
              ),
              _DrawerMenuButton(
                context: context,
                title: "Derslerim",
                onTap: () =>
                    NavigatorHelper.push(context, child: MyLessonsUI()),
              ),
              _DrawerMenuButton(
                context: context,
                title: "Uygulama Hakkında",
                onTap: () => NavigatorHelper.push(context, child: AboutAppUI()),
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
}

class _UserInfoBox extends StatelessWidget {
  const _UserInfoBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Row(
        children: [
          _userPhoto(),
          _userNameSurname(context),
        ],
      ),
    );
  }

  Column _userNameSurname(BuildContext context) {
    return Column(
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
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(
          height: 4,
        ),
        _ExitButton(context: context),
      ],
    );
  }

  Container _userPhoto() {
    return Container(
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
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ItemBox extends StatelessWidget {
  const _ItemBox({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
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
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 10,
              color: Colors.black.withOpacity(0.2)
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _ItemChild extends StatelessWidget {
  const _ItemChild({
    Key? key,
    required this.svgPath,
    required this.label,
  }) : super(key: key);

  final String svgPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          svgPath,
          width: AppSize.width / 8,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppSize.width / 22,
          ),
        ),
      ],
    );
  }
}

class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool isClicked = false;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Emin misiniz?",
              ),
              content: Text(
                "Devam ederseniz bu cihazdan çıkış yapılacak. Cihaz değişikliği yapmadığınız sürece bu cihazdan tekrar giriş yapabilirsiniz.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("İptal"),
                ),
                TextButton(
                  onPressed: isClicked
                      ? null
                      : () async {
                          isClicked = true;
                          await SecureFileService.exitUser();
                          NavigatorHelper.pushAndRemoveUntil(context,
                              page: LoginUI());
                        },
                  child: Text("Devam Et"),
                ),
              ],
            );
          },
        );
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
    );
  }
}

class _DrawerMenuButton extends StatelessWidget {
  const _DrawerMenuButton({
    Key? key,
    required this.context,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
