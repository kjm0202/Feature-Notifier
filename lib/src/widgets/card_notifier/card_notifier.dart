import 'package:feature_notifier/feature_notifier.dart';
import 'package:feature_notifier/src/interface/interface_notifier.dart';
import 'package:feature_notifier/src/utils/icon_selector.dart';
import 'package:flutter/material.dart';

///This widget returns a highly customizable card that allows you notify users of your new feature.
///
///When a user closes this Notifier, the closed state is persisted and is never displayed again.
///To reset the closed state, call the `FeatureNotifier.persist()` method to persist the open
///state, and refresh or update your state after persisting to display and re-insert the feature
/// notifier into the widget tree.
class FeatureCardNotifier extends StatefulWidget implements IFeatureNotifier {
  FeatureCardNotifier(
      {super.key,
      required this.featureKey,
      required this.onClose,
      required this.description,
      required this.onTapCard,
      required this.title,
      this.buttonText,
      this.backgroundColor,
      this.buttonTextColor,
      this.closeIconColor,
      this.buttonTextFontSize,
      this.descriptionColor,
      this.descriptionFontSize,
      this.icon,
      this.onTapButton,
      this.strokeColor,
      this.strokeWidth,
      this.titleColor,
      this.titleFontSize,
      this.hasButton,
      this.showIcon,
      this.buttonBackgroundColor});

  @override
  State<FeatureCardNotifier> createState() => _FeatureCardNotifierState();

  @override
  final Color? backgroundColor;

  @override
  final Color? closeIconColor;

  @override
  final String? buttonText;

  @override
  final Color? buttonTextColor;

  @override
  final double? buttonTextFontSize;

  @override
  final String description;

  @override
  final Color? descriptionColor;

  @override
  final double? descriptionFontSize;

  @override
  final Widget? icon;

  @override
  final void Function() onClose;

  @override
  final void Function()? onTapButton;

  @override
  final void Function() onTapCard;

  @override
  final Color? strokeColor;

  @override
  final double? strokeWidth;

  ///This is the title of the feature that you want to show to your users
  @override
  final String title;

  @override
  final Color? titleColor;

  @override
  final double? titleFontSize;

  @override
  final Color? buttonBackgroundColor;

  @override
  final bool? showIcon;

  ///This key is used to identify the particular feature that was built in the UI. Two features should not have the same feature key to avoid mis-behaviours
  @override
  final String featureKey;

  @override
  final bool? hasButton;
}

class _FeatureCardNotifierState extends State<FeatureCardNotifier> {
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
    final defaultDescriptionColor =
        isDarkMode ? Colors.grey[300] : theme.textTheme.bodyMedium?.color;
    final defaultCloseIconColor = isDarkMode ? Colors.white70 : Colors.black54;
    final defaultButtonBackgroundColor =
        isDarkMode ? Colors.teal[700] : const Color.fromARGB(255, 43, 93, 45);
    final defaultButtonTextColor = Colors.white;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: (widget.showIcon ?? false
                                              ? 12
                                              : 0)),
                                      child: selectIcon(
                                        showIcon: widget.showIcon,
                                        icon: widget.icon,
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraint.maxWidth * .7,
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                widget.titleFontSize ?? 16,
                                            color: widget.titleColor ??
                                                defaultTitleColor),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.close,
                                    color: widget.closeIconColor ??
                                        defaultCloseIconColor,
                                  ),
                                  onTap: () async {
                                    await FeatureNotifierStorage.write(
                                        value: true, id: widget.featureKey);
                                    if (mounted) {
                                      setState(() {
                                        _isVisible = false;
                                      });
                                    }
                                    widget.onClose();
                                  },
                                )
                              ]),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                              fontSize: widget.descriptionFontSize ?? 16,
                              color: widget.descriptionColor ??
                                  defaultDescriptionColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: widget.hasButton != null &&
                                  widget.hasButton != false
                              ? ElevatedButton(
                                  onPressed: widget.onTapButton,
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(10),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color?>(
                                      widget.buttonBackgroundColor ??
                                          defaultButtonBackgroundColor,
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color?>(
                                      widget.buttonTextColor ??
                                          defaultButtonTextColor,
                                    ),
                                  ),
                                  child: Text(
                                    widget.buttonText == null
                                        ? "Explore Feature"
                                        : widget.buttonText!,
                                    style: TextStyle(
                                      fontSize: widget.buttonTextFontSize,
                                    ),
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    ),
                  )),
            );
          })
        : Container();
  }
}
