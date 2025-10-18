class UserModel {
  final String userUid;
  final String userShopName;
  final String userEmail;
  final String userPhone;

  UserModel({
    required this.userUid,
    required this.userShopName,
    required this.userEmail,
    required this.userPhone,
  });

  Map<String, dynamic> tomap() {
    return {
      'userUid': userUid,
      'userShopName': userShopName,
      'userEmail': userEmail,
      'userPhone': userPhone,
    };
  }

  factory UserModel.frommap(Map<String, dynamic> json) {
    return UserModel(
      userUid: json['userUid'],
      userShopName: json['userShopName'],
      userEmail: json['userEmail'],
      userPhone: json['userPhone'],
    );
  }
}
