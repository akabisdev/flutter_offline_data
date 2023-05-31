import 'package:isar/isar.dart';

part 'new_customer.g.dart';

@collection
class NewCustomer {
  Id id = Isar.autoIncrement;
  late String name;
  late int age;
  late String email;
  late List<Add> addresses;
}

@embedded
class Add {
  String? street;
  String? state;
  String? pincode;
}
