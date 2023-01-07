import 'package:flutter/material.dart';

class AboutAppUI extends StatelessWidget {
  const AboutAppUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bu Uygulama Hakkında"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            8,
          ),
          child: Column(
            children: [
              Text(
                "Bu Uygulama 183301070 numaralı Emre Cambolat isimli öğrenci tarafından 2022-2023 eğitim öğretim yılı güz dönemi \'Bilgisayar Mühendisliği Uygulamaları\' dersinin proje ödevi kapsamında Dr. Öğr. Üyesi Onur İNAN'ın danışmanlığında yazılmıştır.\n\nBu uygulama, öğrencilerin ders yoklamalarına QR kod okutarak katılmalarını sağlamak amacını taşımaktadır. Cihaz güvenliği, konum kontrolü, cihaz kontrolü gibi gerekli güvenlik kontrollerini yaparak çalışmaktadır.",
                textScaleFactor: 1.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
