import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_data/views/add_customer_screen.dart';
import 'package:http/http.dart' as http;

import '../models/customer_list_model.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<CustomerListResponse> customerList;

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
      body: FutureBuilder<CustomerListResponse>(
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
                  child: _buildCustomerList(snapshot.data?.data ?? []));
          }
        },
      ),
    );
  }

  Widget _buildCustomerList(List<Customer> list) {
    return list.isEmpty
        ? const Center(
            child: Text('No customers'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(list[index].name),
              );
            },
          );
  }

  Future<CustomerListResponse> _getCustomers() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(
            'http://192.168.68.126:3000/users/m-customers?limit=20&pageNumber=1'),
      );
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final r = CustomerListResponse.fromJson(decodedResponse);
      return r;
    } finally {
      client.close();
    }
  }
}
