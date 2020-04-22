import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/screens/home_screen.dart';
import 'package:will_do/store/constants.dart';
import 'package:will_do/ui/custom_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
//import 'package:android_alarm_manager/android_alarm_manager.dart';

Future _initHive () async {
  final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocsDir.path);
  Hive.registerAdapter(TodoAdapter());
}

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  //  setting up an alarm
  //final int helloAlarmID = 0;
  //await AndroidAlarmManager.initialize();
  runApp(MyApp());
  //await AndroidAlarmManager.periodic(Duration(minutes: 1), helloAlarmID, printHello);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Will Do',
      themeMode: ThemeMode.light,
      theme: purpleTheme(),
      darkTheme: basicDarkTheme(),
      home: FutureBuilder(
        future: Hive.openBox<Todo>(todoBoxName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text("${snapshot.error}"),
                  ),
                ),
              );
            }
            else
              return HomeScreen();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
