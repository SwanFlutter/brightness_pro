import 'dart:async';

import 'package:brightness_pro/src/brightness_pro_drag_base.dart';
import 'package:brightness_pro/src/brightness_pro_slide_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

///Example:
///
/// ```dart
/// BrightnessProSlider(
///   display: Display.vertical,
///   sliderSize: 200,
///   visibleWidget: true,
///   sliderActiveColor: Colors.orange,
///   );
/// ```
// ignore: must_be_immutable
class BrightnessProSlider extends StatefulWidget {
  /// Determines the display orientation of the slider (vertical or horizontal).
  final Display display;

  /// The color of the active portion of the slider.
  final Color sliderActiveColor;

  /// The color of the inactive portion of the slider.
  final Color sliderInActiveColor;

  /// The icon used for decreasing the brightness.
  final IconData downBrightnessIcon;

  /// The size of the brightness decrease icon.
  final double? downBrightnessIconSize;

  /// The color of the brightness decrease icon.
  final Color downBrightnessIconColor;

  /// The icon used for increasing the brightness.
  final IconData upBrightnessIcon;

  /// The size of the brightness increase icon.
  final double? upBrightnessIconSize;

  /// The color of the brightness increase icon.
  final Color upBrightnessIconColor;

  /// Determines the initial visibility of the widget.
  ///
  /// When `visibleWidget` is set to `false`, the widget is initially hidden.
  late bool visibleWidget;

  /// The size of the slider widget.
  final double sliderSize;

  /// The number of divisions/markers on the slider track.
  final int? sliderDivisions;

  BrightnessProSlider({
    super.key,
    this.display = Display.vertical,
    this.sliderActiveColor = Colors.blueAccent,
    this.sliderInActiveColor = Colors.grey,
    this.downBrightnessIcon = CupertinoIcons.brightness,
    this.downBrightnessIconSize = 25.0,
    this.downBrightnessIconColor = Colors.blueAccent,
    this.upBrightnessIcon = CupertinoIcons.brightness_solid,
    this.upBrightnessIconSize = 25.0,
    this.upBrightnessIconColor = Colors.blueAccent,
    this.visibleWidget = true,
    this.sliderSize = 175,
    this.sliderDivisions = 50,
  });

  static Widget brightnessProDragDirection({
    /// [width] : The width of the widget. Defaults to 50.
    final double width = 50,

    /// [height] : The height of the widget. Defaults to 250.
    final double height = 250,

    /// [textFontSize]: The font size of the text.
    final double? textFontSize,

    /// [textColor]: The color of the text. Defaults to white.
    final Color? textColor,

    /// [iconColor]: The color of the icon.
    final Color? iconColor,

    /// [brightnessIcon]: The icon to use for the brightness control. Defaults to CupertinoIcons.brightness_solid.
    final IconData? brightnessIcon,
  }) {
    return BrightnessProDragDirection(
      width: width,
      height: height,
      textFontSize: textFontSize,
      textColor: textColor,
      iconColor: iconColor,
      brightnessIcon: brightnessIcon,
    );
  }

  static Widget brightnessProSlideBottom({
    /// The width of the slider widget.
    /// This defines how wide the slider will be on the screen.
    final double width = 100,

    /// The height of the slider widget.
    /// This sets the vertical size of the slider.
    final double height = 150,

    /// A widget to display the icon representing brightness.
    /// This can be any widget such as an [Icon] or an [Image].
    final Widget brightnessIcon =
        const Icon(CupertinoIcons.brightness, size: 50),

    /// Specifies the height of the button used in the slider.
    /// This determines how tall the button within the slider will be.
    final double btnHeight = 25,

    /// Defines the color of the button in the slider.
    /// This sets the button's color, which can be any [Color].
    final Color btnColor = Colors.white,

    /// Sets the elevation of the button, giving it a shadow effect.
    /// This adds a visual depth to the button.
    final double elevation = 3.0,

    /// A widget to display the icon at the top button.
    /// This can be any widget such as an [Icon] or an [Image].
    final Widget topBtnIcon = const Icon(
      CupertinoIcons.add,
      color: Colors.black,
    ),

    /// A widget to display the icon at the bottom button.
    /// This can be any widget such as an [Icon] or an [Image].
    final Widget bottomBtnIcon = const Icon(
      Icons.horizontal_rule,
      color: Colors.black,
    ),
  }) {
    return BrightnessProSlideBottom(
      width: width,
      height: height,
      btnHeight: btnHeight,
      btnColor: btnColor,
      elevation: elevation,
      topBtnIcon: topBtnIcon,
      bottomBtnIcon: bottomBtnIcon,
      brightnessIcon: brightnessIcon,
    );
  }

  @override
  State<BrightnessProSlider> createState() => _BrightnessProSliderState();
}

class _BrightnessProSliderState extends State<BrightnessProSlider>
    with SingleTickerProviderStateMixin {
  double _brightnessLevel = 0.5;
  final double _brightnessIncrement = 0.05;
  double _opacityIcons = 0;
  late Timer _timer;

  Future<void> setBrightness(double sliderValue) async {
    try {
      double brightnessValue =
          sliderValue.clamp(0.0, 1.0); // Clamp the value between 0 and 1
      await ScreenBrightness().setScreenBrightness(brightnessValue);
      setState(() {
        _brightnessLevel = brightnessValue;
      });
    } catch (e) {
      if (kDebugMode) {
        print(kDebugMode);
      }
      throw Exception('Failed to set brightness');
    }
  }

  void increaseBrightness() {
    double newLevel = _brightnessLevel + _brightnessIncrement;
    if (newLevel <= 1.0) {
      setBrightness(newLevel);
    }
  }

  void decreaseBrightness() {
    double newLevel = _brightnessLevel - _brightnessIncrement;
    if (newLevel >= 0.0) {
      setBrightness(newLevel);
    }
  }

  @override
  void initState() {
    super.initState();
    setBrightness(_brightnessLevel);
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacityIcons = 0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onDoubleTap: () {
        if (_opacityIcons == 0) {
          _opacityIcons = 1;
          setState(() {});
          Future.delayed(const Duration(seconds: 5), () {
            if (_opacityIcons == 1) {
              _opacityIcons = 0;
              setState(() {});
            }
          });
        }
      },
      child: widget.visibleWidget
          ? SizedBox(
              width: size.width,
              child: widget.display == Display.vertical
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _brightnessLevel = 0.9;
                            setState(() {});
                          },
                          icon: Icon(
                            widget.upBrightnessIcon,
                            size: widget.upBrightnessIconSize,
                            color: widget.upBrightnessIconColor,
                          ),
                        ),
                        SizedBox(
                          height: widget.sliderSize,
                          child: Transform.rotate(
                            angle: -90 * 3.141592653589793 / 180,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: widget.sliderSize,
                                  child: Slider(
                                    activeColor: widget.sliderActiveColor,
                                    inactiveColor: widget.sliderInActiveColor,
                                    value: _brightnessLevel.clamp(0.0, 1.0),
                                    divisions: widget.sliderDivisions,
                                    min: 0,
                                    max: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        setBrightness(value);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _brightnessLevel = 0.05;
                            setState(() {});
                          },
                          icon: Icon(
                            widget.downBrightnessIcon,
                            size: widget.downBrightnessIconSize,
                            color: widget.downBrightnessIconColor,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _brightnessLevel = 0.05;
                            setState(() {});
                          },
                          icon: Icon(
                            widget.downBrightnessIcon,
                            size: widget.downBrightnessIconSize,
                            color: widget.downBrightnessIconColor,
                          ),
                        ),
                        SizedBox(
                          height: widget.sliderSize,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: widget.sliderSize,
                                child: Slider(
                                  activeColor: widget.sliderActiveColor,
                                  inactiveColor: widget.sliderInActiveColor,
                                  value: _brightnessLevel.clamp(0.0, 1.0),
                                  divisions: widget.sliderDivisions,
                                  min: 0,
                                  max: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      setBrightness(value);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _brightnessLevel = 0.9;
                            setState(() {});
                          },
                          icon: Icon(
                            widget.upBrightnessIcon,
                            size: widget.upBrightnessIconSize,
                            color: widget.upBrightnessIconColor,
                          ),
                        ),
                      ],
                    ),
            )
          : AnimatedOpacity(
              opacity: _opacityIcons,
              duration: const Duration(milliseconds: 700),
              child: SizedBox(
                child: widget.display == Display.vertical
                    ? SizedBox(
                        width: size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                _brightnessLevel = 0.9;
                                setState(() {});
                              },
                              icon: Icon(
                                widget.upBrightnessIcon,
                                size: widget.upBrightnessIconSize,
                                color: widget.upBrightnessIconColor,
                              ),
                            ),
                            SizedBox(
                              height: widget.sliderSize,
                              child: Transform.rotate(
                                angle: -90 * 3.141592653589793 / 180,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: widget.sliderSize,
                                      child: Slider(
                                        activeColor: widget.sliderActiveColor,
                                        inactiveColor:
                                            widget.sliderInActiveColor,
                                        value: _brightnessLevel.clamp(0.0, 1.0),
                                        divisions: widget.sliderDivisions,
                                        min: 0,
                                        max: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            setBrightness(value);
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _brightnessLevel = 0.05;
                                setState(() {});
                              },
                              icon: Icon(
                                widget.downBrightnessIcon,
                                size: widget.downBrightnessIconSize,
                                color: widget.downBrightnessIconColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _brightnessLevel = 0.05;
                              setState(() {});
                            },
                            icon: Icon(
                              widget.downBrightnessIcon,
                              size: widget.downBrightnessIconSize,
                              color: widget.downBrightnessIconColor,
                            ),
                          ),
                          SizedBox(
                            height: widget.sliderSize,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: widget.sliderSize,
                                  child: Slider(
                                    activeColor: widget.sliderActiveColor,
                                    inactiveColor: widget.sliderInActiveColor,
                                    value: _brightnessLevel.clamp(0.0, 1.0),
                                    divisions: widget.sliderDivisions,
                                    min: 0,
                                    max: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        setBrightness(value);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _brightnessLevel = 0.9;
                              setState(() {});
                            },
                            icon: Icon(
                              widget.upBrightnessIcon,
                              size: widget.upBrightnessIconSize,
                              color: widget.upBrightnessIconColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}

// ignore: duplicate_ignore
enum Display {
  horizontal,
  vertical,
}
