import 'package:client/contracts/contract.dart';
import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => Contract(),
        child: const MyWallet(),
      ),
    ),
  );
}

class MyWallet extends StatelessWidget {
  const MyWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWallet',
      home: Login(),
    );
  }
}
