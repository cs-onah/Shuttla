import 'package:flutter/widgets.dart';

class SizeConfig {
  static late final MediaQueryData _mediaQueryData;
  static late final double screenWidth;
  static late final double screenHeight;
  static double? _blockSizeHorizontal;
  static double? _blockSizeVertical;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth -
        _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight -
        _safeAreaVertical!) / 100;
  }

  static double widthOf(double val) => val * _blockSizeHorizontal!;

  static double heightOf(double val) => val * _blockSizeVertical!;

}