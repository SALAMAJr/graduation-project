import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _firstNameController = TextEditingController(text: 'Sarah');
  final _lastNameController = TextEditingController(text: 'Mitchell');
  final _dobController = TextEditingController(text: '2003-10-01');
  File? _selectedImage;
  bool _isPickingImage = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 10, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6D4C41),
              onPrimary: Colors.white,
              onSurface: Color(0xFF4A3C2E),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF6D4C41)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image picking error: $e');
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  void _saveChanges() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String dob = _dobController.text;
    File? image = _selectedImage;

    print('Saved: $firstName, $lastName, $dob');
    print('Image path: ${image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Account Settings",
          style: TextStyle(
            color: Color(0xff694A38),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MessagesListScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage("assets/images/Avatar.png")
                            as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sarah Mitchell",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff4A3C2E))),
                      Text("sarahmitchell@gmail.com",
                          style: TextStyle(
                              color: Color(0xff8B7355), fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
                label: 'First Name', controller: _firstNameController),
            _buildTextField(
                label: 'Last Name', controller: _lastNameController),
            _buildDateField(label: 'Date of birth', controller: _dobController),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D4C41),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _saveChanges,
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF6D4C41))),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8E2D9), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8E2D9), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF6D4C41))),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8E2D9), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8E2D9), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
