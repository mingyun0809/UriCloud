import 'package:flutter/material.dart';

class RawMaterialDelieverPage extends StatefulWidget {

  const RawMaterialDelieverPage({super.key});

  @override
  State<RawMaterialDelieverPage> createState() => _RawMaterialDelieverPageState();
}

class _RawMaterialDelieverPageState extends State<RawMaterialDelieverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("원자재 입출고"),
        actions: [

        ],
      ),
    );
  }
}
