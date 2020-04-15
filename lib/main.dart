import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:will_do/models/todo.dart';
import 'package:will_do/pages/home_page.dart';
import 'package:will_do/store/constants.dart';
import 'package:will_do/store/todo_data.dart';
import 'package:will_do/ui/custom_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // todo permissions
    final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocsDir.path);
    Hive.registerAdapter(TodoAdapter());
    runApp(MyApp());
  } catch (e) {
    print("[main] error: ${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: basicTheme(),
      darkTheme: basicDarkTheme(),
      home: FutureBuilder(
        future: Hive.openBox(todoBoxName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text("${snapshot.error}");
            else
              return ChangeNotifierProvider<TodoData>(
                create: (_) => TodoData(),
                child: HomePage(),
              );
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
