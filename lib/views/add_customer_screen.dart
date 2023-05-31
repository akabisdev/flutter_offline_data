import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline_data/services/isar_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_offline_data/models/add_customer_request_model.dart';
import 'package:flutter_offline_data/views/address_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_offline_data/entities/address.dart' as a;
import 'package:flutter_offline_data/entities/new_customer.dart' as nc;

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCont = TextEditingController();
  final _ageCont = TextEditingController();
  final _emailCont = TextEditingController();

  final addresses = <Address>[Address.empty()];

  final service = IsarService();

  @override
  void dispose() {
    _nameCont.dispose();
    _ageCont.dispose();
    _emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCont,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: 'Enter your name'),
                validator: (v) {
                  if (v != null && v.trim().isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageCont,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter your age'),
                validator: (v) {
                  if (v != null && v.trim().isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailCont,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
                validator: (v) {
                  if (v != null && v.trim().isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add addresses',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: AddressWidget(
                              index: index,
                              key: UniqueKey(),
                              initialValue: addresses[index],
                              onChange: (address) {
                                addresses[index] = address;
                              },
                            ),
                          ),
                          _addRemoveBtn(index),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 2),
                    itemCount: addresses.length,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final customer = AddCustomer(
                      name: _nameCont.text,
                      age: int.parse(_ageCont.text),
                      email: _emailCont.text,
                      addresses: addresses,
                    );
                    final success = await _addCustomer(customer);
                    if (success) {
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    } else {
                      print('Something went wrong');
                    }
                  }
                },
                child: const Text('Add customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addRemoveBtn(int index) {
    bool isLast = index == addresses.length - 1;

    return InkWell(
      onTap: () {
        setState(
          () => isLast
              ? addresses.add(Address.empty())
              : addresses.removeAt(index),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLast ? Colors.green : Colors.red,
        ),
        child: Icon(
          isLast ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> _addCustomer(AddCustomer customer) async {
    ///TODO: if network is not present store customer locally, update when network comes back
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ///TODO: save in local db
      final newCustomer = nc.NewCustomer()
        ..name = customer.name
        ..email = customer.email
        ..age = customer.age
        ..addresses = customer.addresses.map((e) {
          final add = nc.Add()
            ..pincode = e.pincode
            ..state = e.state
            ..street = e.street;
          return add;
        }).toList();

      service.saveNewCustomer(newCustomer);
      return false;
    }

    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse(
          'http://192.168.68.112:3000/users/m-customers',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(customer),
      );
      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }
}
