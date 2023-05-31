import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_data/entities/address.dart';
import 'package:flutter_offline_data/entities/customer.dart';
import 'package:flutter_offline_data/services/isar_service.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({Key? key, required this.customerId})
      : super(key: key);
  final String customerId;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late Customer? customer;
  final customerAddresses = <Address>[];
  final service = IsarService();

  @override
  void initState() {
    super.initState();
    // _fetchCustomerDetails();
  }

  Future<Customer?> _fetchCustomerDetails() async {
    customer = await service.getCustomer(widget.customerId);
    if (customer != null) {
      final addIds = customer?.addresses ?? [];
      // final addressList = addIds.map((e) async {
      //   final address = await service.getAddress(e);
      //   if(address != null) {
      //     return address;
      //   }
      // });
      for (var element in addIds) {
        final add = await service.getAddress(element);
        if (add != null) {
          customerAddresses.add(add);
        }
      }
      return customer;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: FutureBuilder<Customer?>(
        future: _fetchCustomerDetails(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _customerDetails(snapshot.data);
            default:
              return const CupertinoActivityIndicator(
                animating: true,
              );
          }
        },
      ),
    );
  }

  Widget _customerDetails(Customer? data) {
    if (customer == null) {
      return Center(child: Text('No customer'));
    } else {
      return Column(
        children: [
          Text(customer?.name ?? ''),
          Text(customer?.email ?? ''),
          Text(customer?.age.toString() ?? ''),
          _addressList()
        ],
      );
    }
  }

  Widget _addressList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: customerAddresses.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text('Address : ${index + 1}'),
            Text('Street : ${customerAddresses[index].street}'),
            Text('State : ${customerAddresses[index].state}'),
            Text('Pincode : ${customerAddresses[index].pincode}'),
          ],
        );
      },
    );
  }
}
