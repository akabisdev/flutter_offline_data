import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_data/models/add_customer_request_model.dart'
    as arm;
import 'package:flutter_offline_data/services/isar_service.dart';
import 'package:flutter_offline_data/views/add_customer_screen.dart';
import 'package:flutter_offline_data/views/customer_details_screen.dart';
import 'package:http/http.dart' as http;

import '../models/customer_list_model.dart';
import 'package:flutter_offline_data/entities/customer.dart' as c;
import 'package:flutter_offline_data/entities/address.dart' as a;

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<c.Customer>> customerList;
  final service = IsarService();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    customerList = _getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            onPressed: () async {
              await _updateNewCustomerData();
              setState(() {});
            },
            icon: const Icon(Icons.sync),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCustomerScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<c.Customer>>(
        future: customerList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 32,
                    animating: true,
                  ),
                );
              }
            case ConnectionState.done:
              return RefreshIndicator(
                  onRefresh: () async {
                    final customerResp = _getCustomers();
                    setState(() {
                      customerList = customerResp;
                    });
                  },
                  child: _buildCustomerList(snapshot.data ?? []));
          }
        },
      ),
    );
  }

  Widget _buildCustomerList(List<c.Customer> list) {
    return list.isEmpty
        ? const Center(
            child: Text('No customers'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CustomerDetailsScreen(
                          customerId: list[index].customerId,
                        );
                      },
                    ),
                  );
                },
                title: Text(list[index].name),
              );
            },
          );
  }

  Future<List<c.Customer>> _getCustomers() async {
    ///TODO: check if network is not present, get data from db
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(
            'http://192.168.68.109:3000/users/m-customers?limit=20&pageNumber=1'),
      );
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final r = CustomerListResponse.fromJson(decodedResponse);
      final customerList = r.data.map((e) {
        final addressList = e.addresses.map((e) {
          print(jsonEncode(e));
          final address = a.Address()
            ..addressId = e.id
            ..state = e.state
            ..street = e.street
            ..pincode = e.pincode;
          return address;
        }).toList();

        ///Save addresses
        service.saveAddresses(addressList);
        final addressIds = addressList.map((e) => e.addressId).toList();
        final customer = c.Customer()
          ..name = e.name
          ..age = e.age
          ..customerId = e.id
          ..email = e.email
          ..addresses = addressIds;
        return customer;
      }).toList();
      // print(jsonEncode(customerList));

      ///Save this data in local db, and get data from db and return list
      service.saveCustomers(customerList);
      return customerList;
    } catch (e) {
      print('Exception : $e');
      return [];
    } finally {
      client.close();
    }
  }

  Future<void> _updateNewCustomerData() async {
    final nc = await service.getNewCustomers();
    if (nc.isNotEmpty) {
      for (var newCustomer in nc) {
        var client = http.Client();
        try {
          final ncAdd = newCustomer.addresses.map((e) {
            return arm.Address(
              street: e.street!,
              state: e.state!,
              pincode: e.pincode!,
            );
          }).toList();
          final nc = arm.AddCustomer(
            name: newCustomer.name,
            age: newCustomer.age,
            email: newCustomer.email,
            addresses: ncAdd,
          );
          var response = await client.post(
            Uri.parse(
              'http://192.168.68.109:3000/users/m-customers',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(nc),
          );
          print('Response : ${response.body}');

          ///Delete new customer from db
          await service.deleteNewCustomer(newCustomer);
        } catch (e) {
          print(e);
        } finally {
          client.close();
        }
      }
    }
  }
}
