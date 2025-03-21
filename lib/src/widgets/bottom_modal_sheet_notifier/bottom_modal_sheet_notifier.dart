import 'package:feature_notifier_plus/feature_notifier.dart';
import 'package:feature_notifier_plus/src/utils/icon_selector.dart';
import 'package:flutter/material.dart';

class FeatureBottomModalSheetNotifier {
  ///This method returns a bottom modal sheet that allows you notify users of your new
  ///features.
  ///
  ///A common use case would be to call this method after your screen has completed it built, and to do this, you need to call the
  ///`WidgetsBinding.instance.addPostFrameCallback()`
  ///inside the init state of your stateful widget. Like so
  /// ```dart
  /// void initState() {
  ///    WidgetsBinding.instance.addPostFrameCallback((_) {
  ///       FeatureBottomModalSheetNotifier.notify();
  ///   }
  /// }
  /// ```
  /// To persist the open/closed state of the notifier, checkout `FeatureNotifier.isClosed()`
  /// method.

  static Future notify(
    BuildContext context, {
    required String featureKey,
    required void Function() onClose,
    required Widget description,
    required Widget title,
    String? buttonText,
    Color? backgroundColor,
    Color? buttonTextColor,
    double? buttonTextFontSize,
    Color? descriptionColor,
    Color? closeIconColor,
    double? descriptionFontSize,
    Widget? icon,
    void Function()? onTapButton,
    Color? strokeColor,
    double? strokeWidth,
    Color? titleColor,
    double? titleFontSize,
    bool? hasButton,
    bool? showIcon,
    Color? buttonBackgroundColor,
    Widget? body,
    bool? showCloseIcon = true,
  }) async {
    final isClosed = await FeatureNotifierStorage.read(featureKey);
    if (isClosed) return Container();

    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          final theme = Theme.of(context);
          final isDarkMode = theme.brightness == Brightness.dark;

          // 다크모드에 따른 기본 색상
          final defaultBackgroundColor =
              isDarkMode ? Colors.grey[850] : Colors.white;
          final defaultTitleColor =
              isDarkMode ? Colors.white : theme.textTheme.titleLarge?.color;
          final defaultDescriptionColor =
              isDarkMode ? Colors.grey[300] : theme.textTheme.bodyMedium?.color;
          final defaultCloseIconColor =
              isDarkMode ? Colors.white70 : Colors.black54;
          final defaultButtonBackgroundColor = isDarkMode
              ? Colors.teal[700]
              : const Color.fromARGB(255, 43, 93, 45);
          final defaultButtonTextColor = Colors.white;

          // 바깥 클릭이나 드래그로 닫을 때 상태 저장을 위한 PopScope 추가
          return PopScope(
            onPopInvoked: (didPop) async {
              if (didPop) {
                await FeatureNotifierStorage.write(value: true, id: featureKey);
                onClose();
              }
            },
            child: LayoutBuilder(builder: (context, constraint) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: backgroundColor ?? defaultBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: showCloseIcon ?? true
                          ? const EdgeInsets.only(bottom: 0)
                          : const EdgeInsets.only(bottom: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: selectIcon(
                                    showIcon: showIcon,
                                    icon: icon,
                                  ),
                                ),
                                SizedBox(
                                  width: constraint.maxWidth * .7,
                                  child: title,
                                ),
                              ],
                            ),
                            if (showCloseIcon ?? true)
                              IconButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await FeatureNotifierStorage.write(
                                      value: true, id: featureKey);
                                  onClose();
                                },
                                icon: Icon(Icons.close,
                                    color: closeIconColor ??
                                        defaultCloseIconColor),
                              )
                          ]),
                    ),
                    description,
                    body ?? Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: hasButton != null && hasButton != false
                          ? ElevatedButton(
                              onPressed: onTapButton,
                              style: ButtonStyle(
                                /* elevation:
                                    MaterialStateProperty.all<double>(10), */
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                  buttonBackgroundColor ??
                                      defaultButtonBackgroundColor,
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color?>(
                                  buttonTextColor ?? defaultButtonTextColor,
                                ),
                              ),
                              child: SizedBox(
                                width: constraint.maxWidth,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    buttonText ?? "Explore Feature",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: buttonTextFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}
