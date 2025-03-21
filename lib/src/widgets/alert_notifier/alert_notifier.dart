import 'package:feature_notifier/feature_notifier.dart';
import 'package:feature_notifier/src/utils/icon_selector.dart';
import 'package:flutter/material.dart';

class FeatureAlertNotifier {
  ///This method returns an alert dialog that allows you notify users of your new
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
  static Future<Widget?> notify(
    BuildContext context, {
    required String featureKey,
    required void Function() onClose,
    required Widget description,
    required Widget title,
    String? buttonText,
    Color? backgroundColor,
    Color? closeIconColor,
    Color? buttonTextColor,
    double? buttonTextFontSize,
    Color? descriptionColor,
    double? descriptionFontSize,
    Widget? icon,
    void Function()? onTapButton,
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

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          final theme = Theme.of(context);
          final isDarkMode = theme.brightness == Brightness.dark;

          // 다크모드에 따른 기본 색상
          final defaultBackgroundColor =
              isDarkMode ? Colors.grey[800] : theme.dialogBackgroundColor;
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

          return PopScope(
            onPopInvoked: (didPop) async {
              // 뒤로가기 버튼이나 바깥 클릭으로 닫힐 때도 상태 저장
              if (didPop) {
                await FeatureNotifierStorage.write(value: true, id: featureKey);
                onClose();
              }
            },
            child: AlertDialog(
                backgroundColor: backgroundColor ?? defaultBackgroundColor,
                title: Row(
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
                            // width: MediaQuery.of(context).size.width *
                            //     .7,
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
                          icon: Icon(
                            Icons.close,
                            color: closeIconColor ?? defaultCloseIconColor,
                          ),
                        )
                    ]),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                // width: MediaQuery.of(context).size.width,
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
                )),
          );
        });
  }
}
