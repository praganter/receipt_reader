import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:receipt_reader/View/home_view.dart';
import 'package:receipt_reader/Provider/home_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        // title: 'Flutter Demo',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: HomeView(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
