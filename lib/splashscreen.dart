import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/tictactoe/ScorePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:gamedise/ChoosePage.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splashPage';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PlayerInfo player;
  @override
  Widget build(BuildContext context) {
    // User result = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Colors.tealAccent,
        body: SizedBox.expand(
          child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/Game-Dise.png'),
                    fit: BoxFit.fill),
              ),
              child: SplashScreen(
                imageBackground: AssetImage('assets/Game-Dise.png'),
                seconds: 5,
                photoSize: 0.0,
                navigateAfterSeconds: ChoosePage(user: player),// navPage(player),
              )
              // ],
              ),
        ));
  }

  navPage(PlayerInfo player) {
    Navigator.pushNamed(context, ScorePage.routeName, arguments: player);
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  dynamic _deviceId;

  @override
  void initState() {
    super.initState();
    setValue();
  }

  void setValue() async {
    var id = await initPlatformState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    player = name==null ? await new PlayerInfo(_deviceId): await new PlayerInfo(_deviceId, name: name);
  }

  dynamic initPlatformState() async {
    dynamic deviceId;
    try {
      if (Platform.isAndroid) {
        deviceId = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceId = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceId = 'Error: Failed to get platform version.';
    }
    setState(() {
      _deviceId = deviceId;
    });
    return _deviceId;
  }

  dynamic _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.androidId;
  }

  dynamic _readIosDeviceInfo(IosDeviceInfo data) {
    return data.utsname.sysname +
        " " +
        data.utsname.nodename +
        " " +
        data.utsname.machine;
  }
}
