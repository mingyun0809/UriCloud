import 'package:flutter/material.dart';
import 'package:uricloud/screen/raw_material_input.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child:
                Align(alignment: Alignment.centerLeft, child: Text("URICLOUD")),
          ),
          ListTile(
            title: const Text("원자재 입력"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RawMaterialInputPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
