import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furniswap/presentation/manager/cubit/product_cubit.dart';
import 'package:furniswap/data/models/createproduct/product_entity.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _conditionOptions = ['used', 'likeNew'];
  final _typeOptions = ['buy', 'repair', 'swap']; // ✅ أنواع صحيحة
  final _statusOptions = ['active', 'on_hold', 'sold'];

  String? _selectedCondition;
  String? _selectedType;
  String? _selectedStatus;
  File? _selectedImage;
  bool _isPicking = false;

  Future<void> pickImage() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      print("Image Picker Error: $e");
    } finally {
      _isPicking = false;
    }
  }

  void _submitProduct(BuildContext context) {
    if (!_formKey.currentState!.validate() ||
        _selectedCondition == null ||
        _selectedType == null ||
        _selectedStatus == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك املا كل البيانات واختر صورة")),
      );
      return;
    }

    final product = ProductEntity(
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      imageFile: _selectedImage!, // ✅ مهمة
      condition: _selectedCondition!,
      type: _selectedType!,
      status: _selectedStatus!,
      imageUrl: null, // ✅ مش مطلوب وقت الإنشاء
    );

    context.read<ProductCubit>().createProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ تم إنشاء المنتج بنجاح")),
          );
          Navigator.pop(context);
        } else if (state is ProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ فشل: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF5EFE6),
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Create Product",
              style: TextStyle(
                  color: Color(0xff694A38),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: _selectedImage == null
                          ? const Center(
                              child: Icon(Icons.add_a_photo, size: 40))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInput("Name", _nameController),
                  _buildInput("Price", _priceController,
                      inputType: TextInputType.number),
                  _buildInput("Description", _descriptionController,
                      maxLines: 3),
                  _buildDropdown(
                      "Condition",
                      _conditionOptions,
                      _selectedCondition,
                      (val) => setState(() => _selectedCondition = val)),
                  _buildDropdown("Type", _typeOptions, _selectedType,
                      (val) => setState(() => _selectedType = val)),
                  _buildDropdown("Status", _statusOptions, _selectedStatus,
                      (val) => setState(() => _selectedStatus = val)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is ProductLoading
                        ? null
                        : () => _submitProduct(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff694A38),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: state is ProductLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Product",
                            style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item[0].toUpperCase() + item.substring(1)),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (val) => val == null ? "Required" : null,
      ),
    );
  }
}
