import 'package:isar/isar.dart';

part 'address.g.dart';

@collection
class Address {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String addressId;
  String? street;
  String? state;
  String? pincode;
}
