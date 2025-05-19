import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _addressData = {};
  List<Map<String, String>> addresses = [];

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        addresses.insert(0, Map.from(_addressData));
      });
      _formKey.currentState!.reset();
    }
  }

  void _editAddress(int index) {
    setState(() {
      _addressData.addAll(addresses[index]);
    });
    _deleteAddress(index);
  }

  void _deleteAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Addresses",
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 3),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sms_outlined, color: Color(0xff694A38)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagesListScreen()));
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.only(left: 3, right: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                var address = addresses[index];
                return _buildAddressCard(index, address);
              },
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(2, 0),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff4A3427),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildTextFormField(
                      label: "Full Name",
                      key: "name",
                      type: TextInputType.name,
                    ),
                    buildTextFormField(
                      label: "Street Address",
                      key: "street",
                      type: TextInputType.streetAddress,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: buildDropdownField(
                            label: "City",
                            options: [
                              "Cairo",
                              "Giza",
                              "Alexandria",
                              "Port Said",
                              "Suez",
                              "Luxor",
                              "Aswan",
                              "Assiut",
                              "Mansoura",
                              "Tanta",
                              "Zagazig",
                              "Ismailia",
                              "Fayoum",
                              "Qena",
                              "Beni Suef",
                              "Damietta",
                              "Sohag",
                              "Marsa Matruh",
                              "Kafr El Sheikh",
                              "Minya",
                              "New Valley",
                              "Hurghada",
                              "Sharm El Sheikh",
                              "Arish"
                            ],
                            key: "city",
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: buildDropdownField(
                            label: "State",
                            options: [
                              "Cairo",
                              "Giza",
                              "Alexandria",
                              "Suez",
                              "Port Said",
                              "Damietta",
                              "Dakahlia",
                              "Sharqia",
                              "Qalyubia",
                              "Kafr El Sheikh",
                              "Gharbia",
                              "Menoufia",
                              "Beheira",
                              "Ismailia",
                              "Fayoum",
                              "Beni Suef",
                              "Minya",
                              "Assiut",
                              "Sohag",
                              "Qena",
                              "Luxor",
                              "Aswan",
                              "Red Sea",
                              "New Valley",
                              "Matrouh",
                              "North Sinai",
                              "South Sinai"
                            ],
                            key: "state",
                          ),
                        ),
                      ],
                    ),
                    buildDropdownField(
                      label: "Country",
                      options: ["Egypt"],
                      key: "country",
                    ),
                    buildTextFormField(
                      label: "Postal Code",
                      key: "postalCode",
                      type: TextInputType.text,
                    ),
                    buildTextFormField(
                      label: "Phone Number",
                      key: "phone",
                      type: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Color(0xff694A38),
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Save Address",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    required String key,
    required TextInputType type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
        ),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: type,
          initialValue: _addressData[key],
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? "This field is required" : null,
          onSaved: (value) => _addressData[key] = value!,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required List<String> options,
    required String key,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Color(0xff4B5563)),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            hintText: "Select $label",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          value: _addressData[key],
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _addressData[key] = value!;
            });
          },
          dropdownColor: Colors.white,
          validator: (value) => value == null ? "Please select a $label" : null,
          onSaved: (value) => _addressData[key] = value!,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildAddressCard(int index, Map<String, String> address) {
    return Card(
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address["name"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A3427),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  address["street"]!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  "${address["city"]}, ${address["postalCode"]}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  address["country"]!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(MyFlutterApp.edit,
                      size: 19, color: Colors.black),
                  onPressed: () => _editAddress(index),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                IconButton(
                  icon: const Icon(MyFlutterApp.trash_empty,
                      size: 21, color: Colors.black),
                  onPressed: () => _deleteAddress(index),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
