import 'package:flutter/material.dart';

class AppSize {
  static double _height = 1920;
  static double _width = 1080;
  static late Size _size;

  static double get height => _height;
  static double get width => _width;
  static Size get size => _size;

  static set setSize(Size value) {
    _size = value;
    _height = value.height;
    _width = value.width;
  }
}
