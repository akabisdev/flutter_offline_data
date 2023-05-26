import 'dart:convert';

AddCustomer addCustomerFromJson(String str) =>
    AddCustomer.fromJson(json.decode(str));

String addCustomerToJson(AddCustomer data) => json.encode(data.toJson());

class AddCustomer {
  final String name;
  final int age;
  final String email;
  final List<Address> addresses;

  AddCustomer({
    required this.name,
    required this.age,
    required this.email,
    required this.addresses,
  });

  factory AddCustomer.fromJson(Map<String, dynamic> json) => AddCustomer(
        name: json["name"],
        age: json["age"],
        email: json["email"],
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "email": email,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}

class Address {
  final String street;
  final String state;
  final String pincode;

  Address({
    required this.street,
    required this.state,
    required this.pincode,
  });

  factory Address.empty() => Address(street: '', state: '', pincode: '');

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "state": state,
        "pincode": pincode,
      };
}
