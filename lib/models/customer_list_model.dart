import 'dart:convert';

CustomerListResponse customerListFromJson(String str) =>
    CustomerListResponse.fromJson(json.decode(str));

String customerListToJson(CustomerListResponse data) =>
    json.encode(data.toJson());

class CustomerListResponse {
  final String message;
  final List<Customer> data;
  final int totalCount;

  CustomerListResponse({
    required this.message,
    required this.data,
    required this.totalCount,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) =>
      CustomerListResponse(
        message: json['message'],
        data:
            List<Customer>.from(json["data"].map((x) => Customer.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class Customer {
  final String id;
  final String name;
  final int age;
  final String email;
  final List<Address> addresses;
  final int v;

  Customer({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.addresses,
    required this.v,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["_id"],
        name: json["name"],
        age: json["age"],
        email: json["email"],
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "age": age,
        "email": email,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "__v": v,
      };
}

class Address {
  final String id;
  final String street;
  final String state;
  final String pincode;
  final int v;

  Address({
    required this.id,
    required this.street,
    required this.state,
    required this.pincode,
    required this.v,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"],
        street: json["street"],
        state: json["state"],
        pincode: json["pincode"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "street": street,
        "state": state,
        "pincode": pincode,
        "__v": v,
      };
}
