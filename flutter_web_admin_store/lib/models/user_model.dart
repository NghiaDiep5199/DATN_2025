class UserModel {
  final String? address;
  final String? buyerId;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? profileImage;

  UserModel({
    required this.address,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.profileImage,
  });

  UserModel.fromJson(Map<String, Object?> json)
    : this(
        address: json['address']! as String,
        buyerId: json['buyerId']! as String,
        fullName: json['fullName']! as String,
        phoneNumber: json['phoneNumber']! as String,
        profileImage: json['profileImage']! as String,
        email: json['email']! as String,
      );

  Map<String, Object?> toJson() {
    return {
      'address': address,
      'buyerId': buyerId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'email': email,
    };
  }
}
