import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String customerUid;
  final String customerName;
  final int customerAmount;
  final String customerEmail;
  final String customerAddress;
  final String customerPhone;
  final DateTime date;

  CustomerModel({
    required this.customerUid,
    required this.customerName,
    required this.customerAmount,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerPhone,
    required this.date,
  });

  Map<String, dynamic> tomap() {
    return {
      'customerUid': customerUid,
      'customerName': customerName,
      'customerAmount': customerAmount,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'date': Timestamp.fromDate(date),
    };
  }

  factory CustomerModel.formmap(Map<String, dynamic> json) {
    DateTime parsedDate;

    if (json['date'] is Timestamp) {
      parsedDate = (json['date'] as Timestamp).toDate();
    } else if (json['date'] is String) {
      parsedDate = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return CustomerModel(
      customerUid: json['customerUid'] ?? '',
      customerName: json['customerName'] ?? '',
      customerAmount: json['customerAmount'] ?? 0,
      customerEmail: json['customerEmail'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      date: parsedDate,
    );
  }
}
