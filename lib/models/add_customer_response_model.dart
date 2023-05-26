// To parse this JSON data, do
//
//     final addCustomerResponse = addCustomerResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddCustomerResponse addCustomerResponseFromJson(String str) =>
    AddCustomerResponse.fromJson(json.decode(str));

String addCustomerResponseToJson(AddCustomerResponse data) =>
    json.encode(data.toJson());

class AddCustomerResponse {
  final String message;
  final Data data;

  AddCustomerResponse({
    required this.message,
    required this.data,
  });

  factory AddCustomerResponse.fromJson(Map<String, dynamic> json) =>
      AddCustomerResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String name;
  final int age;
  final String email;
  final List<String> addresses;
  final String id;
  final int v;

  Data({
    required this.name,
    required this.age,
    required this.email,
    required this.addresses,
    required this.id,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        age: json["age"],
        email: json["email"],
        addresses: List<String>.from(json["addresses"].map((x) => x)),
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "email": email,
        "addresses": List<dynamic>.from(addresses.map((x) => x)),
        "_id": id,
        "__v": v,
      };
}
