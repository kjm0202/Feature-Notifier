import 'package:flutter/material.dart';

abstract class IFeatureNotifier {
  String title = "";
  String description = "";
  Color? backgroundColor;
  Widget? icon;
  Color? strokeColor;
  double? strokeWidth;
  bool? showIcon = true;
  Color? titleColor;
  double? titleFontSize;
  Color? descriptionColor;
  double? descriptionFontSize;
  String? buttonText;
  Color? buttonTextColor;
  Color? buttonBackgroundColor;
  double? buttonTextFontSize;
  Color? closeIconColor;
  String featureKey = "";
  bool? hasButton = false;
  void Function() onClose = () => {};
  void Function() onTapCard = () => {};
  void Function()? onTapButton;
}
