import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantDuesModel {
  final String merchantUid;

  final String merchantName;
  final int dueAmount;
  final int paidAmount;
  final DateTime date;
  final String items;
  final String? imageurl;

  MerchantDuesModel({
    required this.merchantUid,
    required this.merchantName,
    required this.dueAmount,
    required this.paidAmount,
    required this.date,
    required this.items,
    required this.imageurl,
  });

  Map<String, dynamic> tomap() {
    return {
      'merchantUid': merchantUid,
      'merchantName': merchantName,
      'dueAmount': dueAmount,
      'paidAmount': paidAmount,
      'date': date,
      'items': items,
      'imageurl': imageurl,
    };
  }

  factory MerchantDuesModel.formmap(Map<String, dynamic> json) {
    return MerchantDuesModel(
      merchantUid: json['merchantUid'] ?? '',
      merchantName: json['merchantName'] ?? '',
      dueAmount: (json['dueAmount'] ?? 0) as int,
      paidAmount: (json['paidAmount'] ?? 0) as int,
      date: (json['date'] as Timestamp).toDate(),
      items: json['items'] ?? '',
      imageurl: json['imageurl'] ?? '',
    );
  }
}
