import 'package:flutter/material.dart';

abstract class IFeatureNotifier {
  String get featureKey;
  String get title;
  Color? get titleColor;
  Color? get closeIconColor;
  double? get titleFontSize;
  String get description;
  Color? get descriptionColor;
  double? get descriptionFontSize;
  String? get buttonText;
  Color? get buttonTextColor;
  double? get buttonTextFontSize;
  Color? get buttonBackgroundColor;
  Widget? get icon;
  bool? get showIcon;
  void Function() get onClose;
  void Function()? get onTapButton;
  Color? get backgroundColor;
  Color? get strokeColor;
  double? get strokeWidth;
  void Function() get onTapCard;
  bool? get hasButton;
}
