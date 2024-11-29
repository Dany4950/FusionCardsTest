import 'package:buildittt/providers/scanProvider.dart';
import 'package:buildittt/screens/landingPage.dart';
import 'package:buildittt/utils/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => scanLocationBarcode(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Apptheme.theme,
        home: Landingpage(),
      ),
    );
  }
}
