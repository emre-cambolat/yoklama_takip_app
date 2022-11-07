import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yoklama_takip/pages/home_page.dart';
import '../../services/api_service.dart';
import '../../services/file_service.dart';
import '../../utils/app_size.dart';
import '../../utils/app_svgs.dart';
import 'login.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({Key? key}) : super(key: key);

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  bool _isLoading = false;
  bool _onErrror = false;
  double _widgetSize = 0;
  double _svgOpactiy = 0;

  @override
  void initState() {
    // TODO: implement initState
    // _checkLoginInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _svgOpactiy = 1;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _checkLoginInfo() async {
    _onErrror = !await ApiServices.isInternetConnection();
    setState(() {});
    if (_onErrror) {
      return;
    }

    await SecureFileService.checkUserInfo().then(
      (result) async {
        if (result) {
          Map<String, String> _userInfo =
              await SecureFileService.readUserInfo();
          Map<String, String> loginStatus = await ApiServices.login(
            user: _userInfo["user"]!,
            pass: _userInfo["pass"]!,
          );

          if (loginStatus["status"] == "1") {
            // Timer(Duration(seconds: 0), () async {
            //   await ApiServices.getSituations();
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => HomePageUI(),
            //     ),
            //   );
            // });
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginUI(),
            ),
          );
        }
      },
    );
  }

  Widget _progresIndicator() {
    if (_onErrror) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSize.width / 1.8,
            child: Text(
              "İnternet bağlantınızı kontrol edip tekrar deneyiniz",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black54,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.symmetric(
              vertical: 24,
            ),
            onPressed: () {
              setState(() {
                _onErrror = false;
                _isLoading = true;
                _checkLoginInfo();
              });
            },
            icon: Icon(
              Icons.replay_outlined,
              color: Colors.black54,
            ),
          ),
        ],
      );
    }
    if (_isLoading) {
      return CircularProgressIndicator(
        color: Colors.black,
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    AppSize.setSize = MediaQuery.of(context).size;
    // _checkLoginInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _svgOpactiy,
            curve: Curves.easeInCirc,
            duration: Duration(milliseconds: 500),
            onEnd: () {
              setState(() {
                _widgetSize = AppSize.height / 3.5;
              });
            },
            child: SizedBox(
              width: AppSize.width,
              // child: SvgPicture.string(
              //   AppSVG.logo,
              //   alignment: Alignment.center,
              //   height: 75,
              // ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedContainer(
                height: _widgetSize,
                curve: Curves.easeInOutQuart,
                duration: Duration(
                  milliseconds: 500,
                ),
                onEnd: () async {
                  setState(
                    () {
                      _isLoading = true;
                    },
                  );
                  Timer(
                    Duration(milliseconds: 500),
                    () {
                      _checkLoginInfo();
                    },
                  );
                },
              ),
              _progresIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}
