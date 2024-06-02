import 'package:brightness_pro/brightness_pro_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  BrightnessProSlider.brightnessProSlideBottom(),

                BrightnessProSlider(
                  display: Display.VERTICAL,
                  sliderSize: 200,
                  visibleWidget: false,
                  sliderActiveColor: Colors.orange,
                ),
                const SizedBox(
                  height: 30,
                ),
                BrightnessProSlider(
                  display: Display.HORIZONTAL,
                ),
                const SizedBox(
                  height: 30,
                ),
                /*  Container(
                    color: Colors.deepOrange,
                    width: 50,
                    height: 250,
                    child: BrightnessProSlider.brightnessProDragDirection()
                    ),*/
              ],
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
