import 'package:isar/isar.dart';
import 'package:flutter_offline_data/entities/address.dart';

part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;
  late String customerId; // ID can be of any type
  late String name;
  late int age;
  late String email;
  final addresses = IsarLinks<Address>();
}
