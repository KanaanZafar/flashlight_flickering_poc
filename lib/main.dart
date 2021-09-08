import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flashlight/flashlight.dart';
import 'package:string_validator/string_validator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasFlashlight = false;
  bool _flickeringTurnedOff = false;
  int _flickeringDuration = 5;
  TextEditingController textEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    initFlashlight();
  }

  initFlashlight() async {
    bool hasFlash = await Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlashlight = hasFlash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flashlight Flickering Demo'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text(_hasFlashlight
                ? 'Your phone has a Flashlight.'
                : 'Your phone has no Flashlight.'),
            RaisedButton(
              child: Text('Turn on Flickering'),
              onPressed: () {
                turnFlashlightOn();
              },
            ),
            RaisedButton(
              child: Text('Turn off Flickering'),
              onPressed: () {
                turnOffFlashLight();
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 50, //width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: textEditingController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(),
                onSubmitted: (value) {
                  if (isNumeric(value)) {
                    setState(() {
                      _flickeringDuration = int.parse(value);
                    });
                  }
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  turnFlashlightOn() async {
    if (_flickeringTurnedOff) {
      return;
    }
    await Flashlight.lightOn();
    // isFlashLightOn = true;
    await Future.delayed(Duration(milliseconds: _flickeringDuration));
    await Flashlight.lightOff().then((value) async {
      await Future.delayed(Duration(milliseconds: _flickeringDuration));
      turnFlashlightOn();
    });
  }

  turnOffFlashLight() async {
    setState(() {
      _flickeringTurnedOff = true;
    });
    await Flashlight.lightOff();
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _flickeringTurnedOff = false;
    });
  }
}
