import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/plugins/notifications_plugin.dart';
import 'package:will_do/screens/home_screen.dart';
import 'package:will_do/store/constants.dart';
import 'package:will_do/ui/custom_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future _initHive () async {
  final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocsDir.path);
  Hive.registerAdapter(TodoAdapter());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("[MyApp] build...");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationPlugin>(create: (_) => NotificationPlugin(),)
      ],
      child: MaterialApp(
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
                      padding: EdgeInsets.all(40.0),
                      child: Text("${snapshot.error.toString()}"),
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
      ),
    );
  }
}
