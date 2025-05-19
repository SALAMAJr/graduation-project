import 'package:flutter/material.dart';
import 'package:furniswap/icons/icons.dart';
import 'package:furniswap/presentation/screens/messages_list_screen.dart';
import 'package:furniswap/presentation/screens/notifications_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _paymentData = {};
  List<Map<String, String>> paymentMethods = [];
  String? selectedPaymentType;

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        paymentMethods.insert(0, Map.from(_paymentData));
      });
      _formKey.currentState!.reset();
      selectedPaymentType = null;
    }
  }

  void _editPaymentMethod(int index) {
    setState(() {
      _paymentData.addAll(paymentMethods[index]);
      selectedPaymentType = _paymentData["type"];
    });
    _deletePaymentMethod(index);
  }

  void _deletePaymentMethod(int index) {
    setState(() {
      paymentMethods.removeAt(index);
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
          "My Payments",
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
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                var payment = paymentMethods[index];
                return _buildPaymentCard(index, payment);
              },
            ),
            SizedBox(height: 10),
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
                      "Add Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff4A3427),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildPaymentDropdown(),
                    if (selectedPaymentType == 'Visa') ...[
                      _buildTextField(
                        label: "Card Number",
                        keyName: "cardNumber",
                        type: TextInputType.number,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: _buildTextField(
                              label: "Expiration Date",
                              keyName: "expirationDate",
                              type: TextInputType.datetime,
                            ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: _buildTextField(
                              label: "CVV",
                              keyName: "cvv",
                              type: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        label: "Billing Address",
                        keyName: "billingAddress",
                        type: TextInputType.multiline,
                      ),
                    ] else if (selectedPaymentType == 'PayPal') ...[
                      _buildTextField(
                          label: "PayPal Email",
                          keyName: "paypalEmail",
                          type: TextInputType.emailAddress),
                      _buildTextField(
                          label: "Billing Address",
                          keyName: "billingAddress",
                          type: TextInputType.multiline),
                    ] else if (selectedPaymentType == "Apple Pay") ...[
                      Text("Apple Pay is connected",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
                      SizedBox(
                        height: 12,
                      ),
                      _buildTextField(
                          label: "Billing Address",
                          keyName: "billingAddress",
                          type: TextInputType.multiline),
                    ],
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _savePaymentMethod,
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Color(0xff694A38),
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Save Payment Method",
                          style: TextStyle(color: Colors.white)),
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

  Widget _buildPaymentDropdown() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF8F5F1),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5DDD3), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5DDD3), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          value: selectedPaymentType,
          hint: Text("Select Payment Type"),
          items: ["Visa", "PayPal", "Apple Pay"].map((method) {
            return DropdownMenuItem(value: method, child: Text(method));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPaymentType = value;
              _paymentData["type"] = value!;
            });
          },
          dropdownColor: Colors.white,
        ),
        SizedBox(
          height: 18,
        )
      ],
    );
  }

  Widget _buildTextField(
      {required String label,
      required String keyName,
      required TextInputType type}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Color(0xff4A3419))),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: type,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF8F5F1),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5DDD3), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xffE5DDD3), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? "This field is required" : null,
          onSaved: (value) => _paymentData[keyName] = value!,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildPaymentCard(int index, Map<String, String> payment) {
    IconData icon;
    String subtitle = "";

    switch (payment["type"]) {
      case "Visa":
        icon = MyFlutterApp.cc_visa;
        subtitle = "Expires ${payment["expirationDate"] ?? "N/A"}";
        break;
      case "PayPal":
        icon = MyFlutterApp.paypal;
        subtitle = payment["paypalEmail"] ?? "No email provided";
        break;
      case "Apple Pay":
        icon = MyFlutterApp.apple_pay;
        subtitle = "Connected";
        break;
      default:
        icon = Icons.payment;
        subtitle = "Unknown Payment Method";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
          size: 25,
        ),
        title: Text(
          payment["type"] == "Visa"
              ? "Visa ending in ${payment["cardNumber"]?.substring(payment["cardNumber"]!.length - 4)}"
              : payment["type"] == "PayPal"
                  ? "PayPal"
                  : payment["type"] == "Apple Pay"
                      ? "Apple Pay"
                      : "Unknown Payment Method",
          style:
              TextStyle(color: Color(0xff4A3427), fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(MyFlutterApp.edit, size: 19, color: Colors.black),
              onPressed: () => _editPaymentMethod(index),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            IconButton(
              icon:
                  Icon(MyFlutterApp.trash_empty, size: 21, color: Colors.black),
              onPressed: () => _deletePaymentMethod(index),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
