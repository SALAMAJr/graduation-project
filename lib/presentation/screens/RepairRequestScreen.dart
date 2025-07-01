import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RepairRequestScreen extends StatefulWidget {
  @override
  _RepairRequestScreenState createState() => _RepairRequestScreenState();
}

class _RepairRequestScreenState extends State<RepairRequestScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expectedPriceController =
      TextEditingController();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 70);

    if (pickedFiles != null && pickedFiles.length <= 3) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        height: 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffF3EDE7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _selectedImages.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Color(0xff694A38)),
                    SizedBox(height: 8),
                    Text("Add up to 3 images",
                        style: TextStyle(color: Color(0xff694A38))),
                  ],
                ),
              )
            : Row(
                children: _selectedImages
                    .map((file) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(file,
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Text("Repair Request", style: TextStyle(color: Color(0xff694A38))),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xff694A38)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImagePicker(),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Describe the issue...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _expectedPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Expected price (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // send request logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff694A38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    Text("Send Request", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
