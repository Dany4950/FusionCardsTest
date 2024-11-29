import 'package:buildittt/providers/scanProvider.dart';
import 'package:buildittt/screens/location_scanning/resultLocationBarcode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Scanlbarcode extends StatefulWidget {
  const Scanlbarcode({super.key});

  @override
  State<Scanlbarcode> createState() => ScanlbarcodeState();
}

class ScanlbarcodeState extends State<Scanlbarcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => 
         Column(

          children: [
            Center(
              child: Consumer<scanLocationBarcode>(
                  builder: (context, scanProvider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    await scanProvider.scanBarcode();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => scan_location_Items_result()),
                    );
                  },
                  child: Center(child: Text('Scan Barcode')),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
