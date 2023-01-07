import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as location;
import 'package:safe_device/safe_device.dart';
import 'package:yoklama_takip/pages/qr_code.dart';
import 'package:yoklama_takip/utils/app_size.dart';

import '../utils/navigation_helper.dart';

class CheckLocationUI extends StatefulWidget {
  const CheckLocationUI({super.key});

  @override
  State<CheckLocationUI> createState() => _CheckLocationUIState();
}

class _CheckLocationUIState extends State<CheckLocationUI> {
  Position? _currentPosition;

  List<String> _checkStatus = [
    "Cihaz güvenliği kontrol ediliyor (1/2)",
    "Konum Kontrolleri Yapılıyor (2/2)",
  ];
  int _stepCount = 0;
  bool _onError = false;

  _showDialog(String content) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hata"),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("Tamam"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkDevice() async {
    SafeDevice.isJailBroken
        .then((value) => log("isJailBroken: " + value.toString()));
    SafeDevice.isDevelopmentModeEnable
        .then((value) => log("isDevelopmentModeEnable: " + value.toString()));
    SafeDevice.isOnExternalStorage
        .then((value) => log("isOnExternalStorage: " + value.toString()));
    SafeDevice.isRealDevice
        .then((value) => log("isRealDevice: " + value.toString()));
    SafeDevice.canMockLocation
        .then((value) => log("canMockLocation: " + value.toString()));

    bool isSafe = (!await SafeDevice.isJailBroken &&
        await SafeDevice.isRealDevice &&
        !_currentPosition!.isMocked);

    if (isSafe) {
      log("Cihaz güvenli");
      // await _getLocation();

      // await Future.delayed(Duration(milliseconds: 1500));

      NavigatorHelper.pushReplacement(
        context,
        child: QRViewExample(
          lat: _currentPosition!.latitude,
          long: _currentPosition!.longitude,
        ),
      );
    } else {
      log("Cihaz güvenli değil");
      setState(() {
        _onError = true;
      });
      _showDialog(
        "Cihazınız güvenli kabul edilmediği için yoklamaya katılamazsınız. Aşağıdaki maddelerden en az bir tanesinin olması cihazınızın güvenli olmadığını kabul eder.\n\n- Cihazda Jailbreak/Root işlemi olması\n- Sahte konum uygulaması kullanılması\n- Sanal bir cihaz kullanılması",
      );
    }
  }

  _check() async {
    bool isLocationServiceEnabled = await _isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      _checkUserPermission();
    } else {
      log('Konum servisi kapalı');
      await location.Location.instance.requestService();
      _check();
    }
  }

  Future<void> _checkUserPermission() async {
    LocationPermission permission;

    permission = await Geolocator.requestPermission();

    // permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("izin verilmedi");
        _checkUserPermission();
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      log("asla izin verilmedi");
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Konum izni gerekli"),
            content: Text(
              "Devam edebilmeniz için uygulama ayarlarından konum iznini etkinleştirmeniz gerekiyor. Uygulama ayarlarına gitmek için 'Devam' butonuna tıklayın.",
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  child: Text("Devam")),
            ],
          );
        },
      );
      _checkUserPermission();
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // _checkDevice();
      await _getCurrentPosition();
      await Future.delayed(Duration(milliseconds: 1500));
      setState(() {
        _stepCount = 1;
      });
      await Future.delayed(Duration(milliseconds: 1500));
      await _checkDevice();
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    bool isLocationServiceEnabled;
    try {
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    } on Exception catch (e) {
      log(e.toString());
      isLocationServiceEnabled = false;
      setState(() {
        _onError = true;
      });
    }
    return isLocationServiceEnabled;
  }

  Future<void> _getCurrentPosition() async {
    // setState(() {
    //   _stepCount = 0;
    // });
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      log('Geolacator mock location detect: ' +
          _currentPosition!.isMocked.toString());
    } on Exception catch (e) {
      log(e.toString());
      // currentPosition = null;
      setState(() {
        _onError = true;
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    // _checkLocationService();
    _check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _onError = true;
    // });
    log('onError: ' + _onError.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontroller yapılıyor"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         _check();
        //       },
        //       icon: Icon(Icons.replay_outlined)),
        // ],
      ),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    if (_onError) {
      return SizedBox(
        width: AppSize.width,
        child: InkWell(
          onTap: () async {
            setState(() {
              _onError = false;
            });
            // await _checkLocationService();
            await _check();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh,
                size: 36,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Konum alınamadı tekrar denemek için tıklayınız",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              _checkStatus[_stepCount],
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
    // return Center(
    //   child: CircularProgressIndicator(),
    // );
  }
}
