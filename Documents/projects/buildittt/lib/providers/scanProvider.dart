import 'package:buildittt/models/barcodeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class scanLocationBarcode extends ChangeNotifier {
  List<ScanModel> barcodes = [];
  List<ScanModel> get scannedBarcodes => barcodes;

 Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', 
      'Cancel', 
      true, 
      ScanMode.BARCODE, 
    );

    if (barcode != '-1') { 
      scannedBarcodes.add(ScanModel(barcode: barcode));
      notifyListeners(); 
    }
  }


  void retryScan() {
    scannedBarcodes.clear();
    notifyListeners();
  }

  }


