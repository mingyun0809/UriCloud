import 'package:flutter/material.dart';
import 'package:uricloud/db/my_database.dart';
import 'package:uricloud/widgets/drawer.dart';
import 'db/db_connector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyDatabase.getConnection();
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("URICLOUD"),
        ),
        drawer: MenuDrawer(),
      ),
    );
  }
}


