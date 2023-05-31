import 'package:flutter_offline_data/entities/address.dart' as a;
import 'package:flutter_offline_data/entities/address.dart';
import 'package:flutter_offline_data/entities/customer.dart';
import 'package:flutter_offline_data/entities/new_customer.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveCustomer(Customer customer) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.customers.putSync(customer));
  }

  Future<void> saveNewCustomer(NewCustomer newCustomer) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.newCustomers.putSync(newCustomer));
  }

  Future<void> saveAddresses(List<a.Address> addresses) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.address.putAllSync(addresses));
  }

  Future<void> saveCustomers(List<Customer> customers) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.customers.putAllSync(customers));
  }

  Future<List<Customer>> getAllCustomers() async {
    final isar = await db;
    return await isar.customers.where().findAll();
  }

  Stream<List<Customer>> listenToCustomers() async* {
    final isar = await db;
    yield* isar.customers.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // Future<List<Student>> getStudentsFor(Course course) async {
  //   final isar = await db;
  //   return await isar.students
  //       .filter()
  //       .courses((q) => q.idEqualTo(course.id))
  //       .findAll();
  // }
  //
  // Future<Teacher?> getTeacherFor(Course course) async {
  //   final isar = await db;
  //
  //   final teacher = await isar.teachers
  //       .filter()
  //       .course((q) => q.idEqualTo(course.id))
  //       .findFirst();
  //
  //   return teacher;
  // }

  Future<Customer?> getCustomer(String customerId) async {
    final isar = await db;
    final customer = await isar.customers.getByCustomerId(customerId);
    return customer;
  }

  Future<Address?> getAddress(String addressId) async {
    final isar = await db;
    final address = await isar.address.getByAddressId(addressId);
    return address;
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [CustomerSchema, AddressSchema, NewCustomerSchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
