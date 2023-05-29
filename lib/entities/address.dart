import 'package:flutter_offline_data/entities/customer.dart';
import 'package:isar/isar.dart';

part 'address.g.dart';

@embedded
// @collection
class Address {
  // Id id = Isar.autoIncrement;
  String? street;
  String? state;
  String? pincode;
  // @Backlink(to: 'addresses')
  // final customer = IsarLink<Customer>();
}
