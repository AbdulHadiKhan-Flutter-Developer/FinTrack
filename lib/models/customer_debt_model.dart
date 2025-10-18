import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDebtModel {
  final String customerdebtUid;
  final String customerName;
  final int debtAmount;
  final int subdebtAmount;
  final DateTime date;
  final String items;
  final String? imageurl;

  CustomerDebtModel({
    required this.customerdebtUid,
    required this.customerName,
    required this.debtAmount,
    required this.subdebtAmount,
    required this.date,
    required this.items,
    this.imageurl,
  });

  Map<String, dynamic> tomap() {
    return {
      'customerdebtUid': customerdebtUid,
      'customerName': customerName,
      'debtAmount': debtAmount,
      'subdebtAmount': subdebtAmount,
      'date': date,
      'items': items,
      'imageurl': imageurl,
    };
  }

  factory CustomerDebtModel.formmap(Map<String, dynamic> json) {
    return CustomerDebtModel(
      customerdebtUid: json['customerdebtUid'] ?? '',
      customerName: json['customerName'] ?? '',
      debtAmount: (json['debtAmount'] ?? 0) as int,
      subdebtAmount: (json['subdebtAmount'] ?? 0) as int,
      date: (json['date'] as Timestamp).toDate(),
      items: json['items'] ?? '',
      imageurl: json['imageurl'] ?? '',
    );
  }
}
