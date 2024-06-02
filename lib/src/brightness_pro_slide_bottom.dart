import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BrightnessProSlideBottom extends StatefulWidget {
  /// The width of the slider widget.
  /// This defines how wide the slider will be on the screen.
  final double width;

  /// The height of the slider widget.
  /// This sets the vertical size of the slider.
  final double height;

  /// A widget to display the icon representing brightness.
  /// This can be any widget such as an [Icon] or an [Image].
  final Widget brightnessIcon;

  /// Specifies the height of the button used in the slider.
  /// This determines how tall the button within the slider will be.
  final double btnHeight;

  /// Defines the color of the button in the slider.
  /// This sets the button's color, which can be any [Color].
  final Color btnColor;

  /// Sets the elevation of the button, giving it a shadow effect.
  /// This adds a visual depth to the button.
  final double elevation;

  /// A widget to display the icon at the top button.
  /// This can be any widget such as an [Icon] or an [Image].
  final Widget topBtnIcon;

  /// A widget to display the icon at the bottom button.
  /// This can be any widget such as an [Icon] or an [Image].
  final Widget bottomBtnIcon;
  const BrightnessProSlideBottom({
    super.key,
    this.width = 100,
    this.height = 150,
    this.brightnessIcon = const Icon(CupertinoIcons.brightness, size: 50),
    this.btnHeight = 25,
    this.btnColor = Colors.white,
    this.elevation = 3.0,
    this.topBtnIcon = const Icon(
      CupertinoIcons.add,
      color: Colors.black,
    ),
    this.bottomBtnIcon = const Icon(
      Icons.horizontal_rule,
      color: Colors.black,
    ),
  });

  @override
  State<BrightnessProSlideBottom> createState() =>
      _BrightnessProSlideBottomState();
}

class _BrightnessProSlideBottomState extends State<BrightnessProSlideBottom> {
  double _brightnessLevel = 0.5;
  final double _brightnessIncrement = 0.05;
  double _opacityIcons = 0;

  Future<void> setBrightness(double value) async {
    try {
      double brightnessValue =
          value.clamp(0.0, 1.0); // Clamp the value between 0 and 1
      await ScreenBrightness().setScreenBrightness(brightnessValue);
      setState(() {
        _brightnessLevel = brightnessValue;
        _opacityIcons = brightnessValue;
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacityIcons,
              duration: const Duration(microseconds: 200),
              child: widget.brightnessIcon,
            ),
            const SizedBox(height: 4),
            MaterialButton(
              onPressed: () => increaseBrightness(),
              minWidth: size.width,
              height: widget.btnHeight,
              color: widget.btnColor,
              elevation: widget.elevation,
              child: widget.topBtnIcon,
            ),
            const SizedBox(height: 4),
            MaterialButton(
              onPressed: () => decreaseBrightness(),
              minWidth: size.width,
              height: widget.btnHeight,
              color: widget.btnColor,
              elevation: widget.elevation,
              child: widget.bottomBtnIcon,
            ),
          ],
        ),
      ),
    );
  }
}
