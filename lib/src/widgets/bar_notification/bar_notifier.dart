import 'package:feature_notifier/feature_notifier.dart';
import 'package:feature_notifier/src/utils/icon_selector.dart';
import 'package:flutter/material.dart';

///This widget returns a highly customizable bar that allows you notify users of your new feature.
///
///When a user closes this Notifier, the closed state is persisted and is never displayed again.
///To reset the closed state, call the `FeatureNotifier.persist()` method to persist the open
///state, and refresh or update your state after persisting to display and re-insert the feature
/// notifier into the widget tree.

class FeatureBarNotifier extends StatefulWidget {
  const FeatureBarNotifier(
      {super.key,
      required this.featureKey,
      required this.onClose,
      required this.onTapCard,
      required this.title,
      this.backgroundColor,
      this.icon,
      this.strokeColor,
      this.strokeWidth,
      this.fontWeight,
      this.titleColor,
      this.closeIconColor,
      this.titleFontSize,
      this.showIcon,
      this.showCloseIcon = true});

  @override
  State<FeatureBarNotifier> createState() => _FeatureBarNotifierState();

  final Color? backgroundColor;
  final Widget? icon;
  final void Function() onClose;
  final void Function() onTapCard;
  final Color? strokeColor;
  final double? strokeWidth;
  final FontWeight? fontWeight;

  ///This is the tile of the feature that you want to show to your users
  final Widget title;
  final Color? titleColor;
  final Color? closeIconColor;
  final double? titleFontSize;
  final bool? showIcon;

  ///This key is used to identify the particular feature that was built in the UI. Two features should not have the same feature key to avoid mis-behaviours
  final String featureKey;
  final bool? showCloseIcon;
}

class _FeatureBarNotifierState extends State<FeatureBarNotifier> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _checkVisibility();
  }

  Future<void> _checkVisibility() async {
    final isClosed = await FeatureNotifierStorage.read(widget.featureKey);
    if (mounted) {
      setState(() {
        _isVisible = !isClosed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 다크모드에 따른 기본 색상
    final defaultBackgroundColor =
        isDarkMode ? Colors.grey[800] : Colors.green[50];
    final defaultStrokeColor = isDarkMode ? Colors.grey[600] : Colors.green;
    final defaultTitleColor =
        isDarkMode ? Colors.white : theme.textTheme.titleLarge?.color;
    final defaultCloseIconColor = isDarkMode ? Colors.white70 : Colors.black54;

    return _isVisible
        ? LayoutBuilder(builder: (context, constraint) {
            return GestureDetector(
              onTap: widget.onTapCard,
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: widget.backgroundColor ?? defaultBackgroundColor,
                      border: Border.all(
                          width: widget.strokeWidth ?? 1,
                          color: widget.strokeColor ?? defaultStrokeColor!),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          selectIcon(
                            showIcon: widget.showIcon,
                            icon: widget.icon,
                          ),
                          SizedBox(
                            width: constraint.maxWidth * .7,
                            child: widget.title,
                          ),
                          if (widget.showCloseIcon ?? true)
                            IconButton(
                              onPressed: () async {
                                await FeatureNotifierStorage.write(
                                    value: true, id: widget.featureKey);
                                if (mounted) {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                }
                              },
                              icon: Icon(Icons.close,
                                  color: widget.closeIconColor ??
                                      defaultCloseIconColor),
                            ),
                        ]),
                  )),
            );
          })
        : Container();
  }
}
