import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uricloud/db/my_database.dart';

class EditMaterial extends StatefulWidget {
  final Map<String, String> material;

  EditMaterial({required this.material});

  @override
  State<EditMaterial> createState() => _EditMaterialState();
}

class _EditMaterialState extends State<EditMaterial> {
  List<String> MaterialClass1 = ['RS-ONE 본체', '마운트', '포장', '케이스', '구성품'];
  List<String> MaterialClass2 = ['일', '주', '월'];
  String? selectedMaterial1;
  String? selectedMaterial2;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _materialNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _materialNameController.text = widget.material['material_name'] ?? '';
    selectedMaterial1 = widget.material['classcification'];
    selectedMaterial2 = widget.material['stock_unit'];

    if(selectedMaterial1 != null && !MaterialClass1.contains(selectedMaterial1)) {
      MaterialClass1.add(selectedMaterial1!);
    }
    if(selectedMaterial2 != null && !MaterialClass2.contains(selectedMaterial2)) {
      MaterialClass2.add(selectedMaterial2!);
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("선택된 이미지가 없습니다.");
      }
    });
  }

  void _update() async {
    final materialName = _materialNameController.text.trim().toString();
    final classcification = selectedMaterial1.toString();
    final stockUnit = selectedMaterial2.toString();

    print("Material Name: $materialName");
    print("classcification: $classcification");
    print("stockUnit: $stockUnit");

    if (materialName.isEmpty || classcification == null || stockUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("모든 항목을 입력해주세요.")),
      );
      return;
    }

    try {
      await MyDatabase.updateRawMaterial(widget.material['id']!, materialName, classcification, stockUnit);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터가 성공적으로 수정되었습니다.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print("데이터 수정 중 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("데이터 수정 중 오류가 발생했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("원자재 수정"),
        actions: [
          TextButton(
            onPressed: _update,
            child: const Text(
              '수정',
              style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text("원자재 분류"),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                      width: 24,
                    ),
                    DropdownButton<String>(
                      value: selectedMaterial2,
                      items: MaterialClass1.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMaterial2 = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text("재고 확인 단위"),
                      const VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        width: 24,
                      ),
                      DropdownButton<String>(
                        value: selectedMaterial1,
                        items: MaterialClass2.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMaterial1 = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text("원자재명"),
                      const VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _materialNameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: _image == null
                    ? const Text("이미지를 선택해 주세요.")
                    : Image.file(
                  _image!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: "이미지 선택",
        child: const Icon(Icons.save),
      ),
    );
  }
}