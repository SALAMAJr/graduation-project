import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:furniswap/data/models/createproduct/product_item.dart';
import 'package:furniswap/data/models/createproduct/product_entity.dart';
import 'package:furniswap/presentation/manager/productCubit/product_cubit.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductItem product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  Map<String, String> _saveProduct = {};
  String? selectedCategory;
  String selectedCondition = 'New';

  final List<String> _categories = [
    "chair",
    "table",
    "sofa",
    "desk",
    "cabinet",
    "lighting"
  ];

  final List<String> _conditions = ['New', 'Like New', 'Used'];

  Future<void> _pickImages() async {
    final status = Platform.isIOS
        ? await Permission.photos.request()
        : await Permission.storage.request();
    if (!status.isGranted) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Permission Required'),
          content:
              Text('Please enable permission from settings to access images.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel')),
            TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await openAppSettings();
                },
                child: Text('Open Settings')),
          ],
        ),
      );
      return;
    }
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      if (source == ImageSource.gallery) {
        final pickedFiles = await _picker.pickMultiImage(imageQuality: 75);
        if (pickedFiles.isNotEmpty) {
          setState(() {
            _images.addAll(pickedFiles.take(5 - _images.length));
          });
        }
      } else {
        final photo = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 75);
        if (photo != null && _images.length < 5) {
          setState(() {
            _images.add(photo);
          });
        }
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final product = ProductEntity(
        id: widget.product.id,
        name: _saveProduct['title'] ?? '',
        description: _saveProduct['description'] ?? '',
        location: _saveProduct['location'] ?? '',
        category: selectedCategory ?? '',
        condition: selectedCondition.toLowerCase(),
        type: widget.product.type ?? 'sale',
        status: widget.product.status ?? 'active',
        price: double.tryParse(widget.product.price.toString()) ?? 0.0,
        imageFile: _images.isNotEmpty ? File(_images.first.path) : null,
      );

      context.read<ProductCubit>().updateProduct(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F1ED),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Product",
            style: TextStyle(
                color: Color(0xff694A38),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagesListScreen()));
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(state.message, style: TextStyle(color: Colors.red))),
            );
          } else if (state is ProductUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ Product updated successfully!")),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildPhotoUploader(),
                  SizedBox(height: 24),
                  _buildTextField(
                    'Title',
                    'title',
                    TextInputType.text,
                    "Vintage Wooden Chair",
                    initialValue: widget.product.name,
                  ),
                  _buildTextField('Description', 'description',
                      TextInputType.multiline, "Describe your item...",
                      minLines: 5, maxLines: 10),
                  _buildDropdownField("Category", _categories, selectedCategory,
                      (val) {
                    setState(() => selectedCategory = val);
                  }),
                  _buildConditionSelector(),
                  _buildTextField('Location', 'location', TextInputType.text,
                      "Enter location",
                      prefixIcon: Icons.location_on),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state is ProductLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff694A38),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: state is ProductLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Save Changes",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String keyName,
    TextInputType type,
    String hintText, {
    IconData? prefixIcon,
    int? minLines,
    int? maxLines,
    String? initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff6B4423))),
        SizedBox(height: 5),
        TextFormField(
          key: ValueKey(initialValue), // عشان يتجدد لما القيمة تتغير
          initialValue: initialValue,
          keyboardType: type,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Color(0xff8B5E34))
                : null,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE8E2D9), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE8E2D9), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? "This field is required" : null,
          onSaved: (value) => _saveProduct[keyName] = value!,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff6B4423))),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            hintText: "Select $label",
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE8E2D9), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE8E2D9), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          validator: (value) =>
              value == null || value.isEmpty ? 'This field is required' : null,
          dropdownColor: Colors.white,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildConditionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Condition',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff6B4423))),
        SizedBox(height: 5),
        Row(
          children: _conditions.map((condition) {
            final isSelected = selectedCondition == condition;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedCondition = condition),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xff8B5E34) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xffE8E2D9), width: 1),
                  ),
                  child: Center(
                    child: Text(condition,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff4A3419),
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildPhotoUploader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE8E2D9)),
      ),
      child: GestureDetector(
        onTap: _pickImages,
        child: DottedBorder(
          color: Color(0xff8B5E34),
          strokeWidth: 1,
          dashPattern: [6, 3],
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: _images.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt,
                            color: Color(0xff8B5E34), size: 40),
                        SizedBox(height: 8),
                        Text('Add Photos',
                            style: TextStyle(
                                color: Color(0xff8B5E34), fontSize: 16)),
                        Text('Upload up to 5 photos',
                            style: TextStyle(
                                color: Color(0xffA89B8C), fontSize: 12)),
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_images[index].path),
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _images.removeAt(index)),
                                child: Icon(Icons.cancel,
                                    color: Colors.red, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
