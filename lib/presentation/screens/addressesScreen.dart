import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniswap/data/models/adress/address_model.dart';
import 'package:furniswap/presentation/manager/adressCubit/cubit/address_cubit.dart';
import 'package:furniswap/presentation/screens/messagesListScreen.dart';
import 'package:furniswap/presentation/screens/notificationsScreen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _addressData = {};

  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().getAllAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
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
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressCreatedSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Address added ✅")),
            );
            _formKey.currentState?.reset();
            context.read<AddressCubit>().getAllAddresses(); // ✅ refresh list
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildForm(context, state),
                const SizedBox(height: 20),
                if (state is AddressListLoaded)
                  ...state.addresses
                      .map((address) => buildAddressCard(address))
                      .toList()
                else if (state is AddressLoading)
                  const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildForm(BuildContext context, AddressState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Add New Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            buildTextFormField("Full Name", "fullName", TextInputType.name),
            buildTextFormField(
                "Street Address", "streetAddress", TextInputType.streetAddress),
            Row(
              children: [
                Expanded(
                    child: buildDropdownField(
                        "City", "city", ["Cairo", "Giza", "Alexandria"])),
                const SizedBox(width: 10),
                Expanded(
                    child: buildDropdownField(
                        "State", "state", ["Cairo", "Giza", "Dakahlia"])),
              ],
            ),
            buildDropdownField("Country", "country", ["Egypt"]),
            buildTextFormField(
                "Postal Code", "postalCode", TextInputType.number),
            buildTextFormField(
                "Phone Number", "phoneNumber", TextInputType.phone),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final address = AddressModel(
                    fullName: _addressData['fullName']!,
                    streetAddress: _addressData['streetAddress']!,
                    city: _addressData['city']!,
                    state: _addressData['state']!,
                    country: _addressData['country']!,
                    phoneNumber: _addressData['phoneNumber']!,
                    postalCode: _addressData['postalCode'],
                  );
                  context.read<AddressCubit>().createNewAddress(address);
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xff694A38)),
              child: state is AddressLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Address",
                      style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, String key, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: type,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        onSaved: (value) => _addressData[key] = value!,
      ),
    );
  }

  Widget buildDropdownField(String label, String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: _addressData[key],
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => setState(() => _addressData[key] = val!),
        validator: (value) => value == null ? 'Required' : null,
        onSaved: (value) => _addressData[key] = value!,
      ),
    );
  }

  Widget buildAddressCard(AddressModel address) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 ${address.fullName}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
                "${address.streetAddress}, ${address.city}, ${address.state}, ${address.country}"),
            Text("📬 ${address.postalCode ?? "-"}"),
            Text("📞 ${address.phoneNumber}"),
          ],
        ),
      ),
    );
  }
}
