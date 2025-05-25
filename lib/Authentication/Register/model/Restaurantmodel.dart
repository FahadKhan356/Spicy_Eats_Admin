class Restaurant {
  final String userId;
  final String restaurantName;
  final double? deliveryFee;
  final int? minTime;
  final int? maxTime;
  final String address;
  final String phoneNumber;
  final String? deliveryArea;
  final String? postalCode;
  final String? description;
  final double long;
  final double lat;
  final String businessEmail;
  final String idFirstMiddleName;
  final String idLastName;
  final String? openingHours;
  final String? restaurantImageUrl;
  final String idPhotoUrl;
  final String bankname;
  final String bankownerTitle;
  final String iban;
  final String? restLogoUrl;

  Restaurant({
    required this.iban,
    required this.bankownerTitle,
    required this.bankname,
    required this.userId,
    required this.restaurantName,
    this.deliveryFee,
    this.minTime,
    this.maxTime,
    required this.address,
    required this.phoneNumber,
    this.deliveryArea,
    this.postalCode,
    this.description,
    required this.long,
    required this.lat,
    required this.businessEmail,
    required this.idFirstMiddleName,
    required this.idLastName,
    this.openingHours,
    this.restaurantImageUrl,
    required this.idPhotoUrl,
    this.restLogoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'restaurantName': restaurantName,
      'deliveryFee': deliveryFee,
      'minTime': minTime,
      'maxTime': maxTime,
      'address': address,
      'phoneNumber': phoneNumber,
      'deliveryArea': deliveryArea,
      'postalCode': postalCode,
      'description': description,
      'long': long,
      'lat': lat,
      'businessEmail': businessEmail,
      'idFirstMiddleName': idFirstMiddleName,
      'idLastName': idLastName,
      'openingHours': openingHours,
      'restaurantImageUrl': restaurantImageUrl,
      'idPhotoUrl': idPhotoUrl,
      'restLogoUrl': restLogoUrl,
      'bankname': bankname,
      'bankownerTitle': bankownerTitle,
      'iban': iban,
    };
  }
}
