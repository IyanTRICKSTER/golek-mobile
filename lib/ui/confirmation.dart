import 'package:flutter/material.dart';

class ItemReturnConfirmationPage extends StatefulWidget {
  const ItemReturnConfirmationPage({super.key});

  @override
  State<ItemReturnConfirmationPage> createState() => _ItemReturnConfirmationPageState();
}

class _ItemReturnConfirmationPageState extends State<ItemReturnConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Scan QR Code Here"));
  }
}
