import 'package:faizal/ui/home_page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'db/db_helper1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //WidgetidgetsFlutterBinding.ensureInitialized();
  await DBHelper1.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Location',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      darkTheme: ThemeData(

      ),
      home: HomePage()
    );
  }
}
