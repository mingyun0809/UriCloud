import 'package:flutter/material.dart';
import 'package:uricloud/db/my_database.dart';
import 'package:uricloud/main.dart';
import 'package:uricloud/screen/EditMaterialPage.dart';
import 'package:uricloud/screen/add_material.dart';

class RawMaterialInputPage extends StatefulWidget {

  const RawMaterialInputPage({super.key});

  @override
  State<RawMaterialInputPage> createState() => _RawMaterialInputPageState();
}

class _RawMaterialInputPageState extends State<RawMaterialInputPage> {
  late Future<List<Map<String, String>>> _materials;

  @override
  void initState() {
    super.initState();
    _materials = MyDatabase.getRawMaterials();
  }

  void loadMaterials() {
    setState(() {
      _materials = MyDatabase.getRawMaterials();
    });
  }

  void _deleteMaterial(String materialId) async {
    try {
      await MyDatabase.deleteRawMaterial(materialId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터가 성공적으로 삭제되었습니다.')),
      );
      loadMaterials();
    }catch(e) {
      print("데이터 삭제 중 오류 발생:$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터 삭제 중 오류가 발생했습니다.'))
      );
    }
  }

  void showDeleteDialog(String materialId, String materialName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: Text("'$materialName' 항목을 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMaterial(materialId);
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("원자재 입력"),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _materials,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center (child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final material = snapshot.data![index];
                final materialId = material['material_id']!;
                final materialName = material['material_name'] ?? '';

                return ListTile(
                  title: Text(material['material_name'] ?? ''),
                  subtitle: Text('분류: ${material['classcification']?? ''}\n단위: ${material['stock_unit'] ?? ''}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMaterial(material: material),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDeleteDialog(materialId, materialName);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => add_material()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("신규 등록"),
        elevation: 0,
      ),
    );
  }
}

