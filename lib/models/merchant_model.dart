import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantModel {
  final String merchantUid;
  final String merchantName;
  final String merchantEmail;
  final String merchantAddress;
  final String merchantPhone;
  final DateTime date;
  final int merchantAmount;

  MerchantModel({
    required this.merchantUid,
    required this.merchantName,
    required this.merchantEmail,
    required this.merchantAddress,
    required this.merchantPhone,
    required this.date,
    required this.merchantAmount,
  });

  Map<String, dynamic> tomap() {
    return {
      'merchantUid': merchantUid,
      'merchantName': merchantName,
      'merchantEmail': merchantEmail,
      'merchantAddress': merchantAddress,
      'merchantPhone': merchantPhone,
      'date': Timestamp.fromDate(date),
      'merchantAmount': merchantAmount,
    };
  }

  factory MerchantModel.formmap(Map<String, dynamic> json) {
    DateTime parsedate;
    if (json['date'] is Timestamp) {
      parsedate = (json['date'] as Timestamp).toDate();
    } else if (json['date'] is String) {
      parsedate = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else {
      parsedate = DateTime.now();
    }
    return MerchantModel(
      merchantUid: json['merchantUid'] ?? '',
      merchantName: json['merchantName'] ?? '',
      merchantEmail: json['merchantEmail'] ?? '',
      merchantAddress: json['merchantAddress'] ?? '',
      merchantPhone: json['merchantPhone'] ?? '',
      date: parsedate,
      merchantAmount: json['merchantAmount'] ?? 0,
    );
  }
}
