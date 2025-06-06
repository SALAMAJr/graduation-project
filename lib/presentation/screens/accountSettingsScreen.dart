import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furniswap/presentation/manager/userCubit/user_details_cubit.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';
import 'package:furniswap/data/models/UserModel/UpdateUserRequestModel.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _selectedImage;
  bool _isPickingImage = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
    setState(() => _isPickingImage = true);

    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      print('Image picking error: $e');
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void _saveChanges() {
    setState(() => _isUpdating = true);
    final userCubit = context.read<UserCubit>();
    userCubit.updateUser(
      data: UpdateUserRequestModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
      ),
      image: _selectedImage,
    );
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MessagesListScreen()),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.message}")),
            );
          } else if (state is UserLoaded && _isUpdating) {
            setState(() {
              _firstNameController.text = state.user.firstName;
              _lastNameController.text = state.user.lastName;
              _dobController.text = state.user.dateOfBirth;
              _emailController.text = state.user.email;
              _phoneController.text = state.user.phone;
              _isUpdating = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Profile updated successfully!")),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final user = state.user;

            if (!_isUpdating) {
              _firstNameController.text = user.firstName;
              _lastNameController.text = user.lastName;
              _dobController.text = user.dateOfBirth;
              _emailController.text = user.email;
              _phoneController.text = user.phone;
            }

            return SingleChildScrollView(
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
                              : NetworkImage(user.image) as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff4A3C2E))),
                            Text(user.email,
                                style: const TextStyle(
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
                  _buildDateField(
                      label: 'Date of birth', controller: _dobController),
                  _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      isEnabled: false),
                  _buildTextField(
                      label: 'Phone',
                      controller: _phoneController,
                      isEnabled: false),
                  const SizedBox(height: 16),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const SizedBox.shrink();
        },
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isEnabled = true,
  }) {
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
            enabled: isEnabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: isEnabled ? Colors.white : const Color(0xFFE8E2D9),
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

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
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
