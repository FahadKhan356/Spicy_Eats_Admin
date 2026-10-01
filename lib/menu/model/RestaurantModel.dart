import 'package:spicy_eats_admin/utils/json_coercion.dart';

class RestaurantModel {
  String? restuid;
  String? restaurantName;
  double? deliveryFee;
  int? minTime;
  int? maxTime;
  double? averageRatings;
  int? totalRatings;
  String? address;
  int? phoneNumber;
  String? deliveryArea;
  String? postalCode;
  int? idNumber;
  String? description;
  double? lat;
  double? long;
  String? email;
  String? idFirstName;
  String? idLastName;
  String? idPhotoUrl;
  String? userId;
  String? paymentMethod;
  Map<String, Map<String, dynamic>>? openingHours;
  String? restaurantImageUrl;
  String? restaurantLogoImageUrl;
  double? platformfee;
  List<int>? cuisineIds;

  RestaurantModel copywith({
    String? restaurantName,
    double? deliveryFee,
    int? minTime,
    int? maxTime,
    double? averageRatings,
    int? totalRatings,
    String? address,
    int? phoneNumber,
    String? deliveryArea,
    String? postalCode,
    int? idNumber,
    String? description,
    double? lat,
    double? long,
    String? email,
    String? idFirstName,
    String? idLastName,
    String? idPhotoUrl,
    String? userId,
    String? paymentMethod,
    Map<String, Map<String, dynamic>>? openingHours,
    String? restaurantImageUrl,
    List<int>? cuisineIds,
  }) {
    return RestaurantModel(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        restaurantName: restaurantName ?? this.restaurantName,
        averageRatings: averageRatings ?? this.averageRatings,
        totalRatings: totalRatings ?? this.totalRatings,
        email: email ?? this.email,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        description: description ?? this.description,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        minTime: minTime ?? this.minTime,
        maxTime: maxTime ?? this.maxTime,
        deliveryArea: deliveryArea ?? this.deliveryArea,
        postalCode: postalCode ?? this.postalCode,
        idNumber: idNumber ?? this.idNumber,
        idFirstName: idFirstName ?? this.idFirstName,
        idLastName: idLastName ?? this.idLastName,
        idPhotoUrl: idPhotoUrl ?? this.idPhotoUrl,
        openingHours: openingHours ?? this.openingHours,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
        cuisineIds: cuisineIds ?? this.cuisineIds);
  }

  RestaurantModel({
    this.phoneNumber,
    this.address,
    this.restaurantName,
    this.averageRatings,
    this.totalRatings,
    this.email,
    this.lat,
    this.long,
    this.description,
    this.deliveryFee,
    this.minTime,
    this.maxTime,
    this.deliveryArea,
    this.postalCode,
    this.idNumber,
    this.idFirstName,
    this.idLastName,
    this.idPhotoUrl,
    this.openingHours,
    this.paymentMethod,
    this.restaurantImageUrl,
    this.restuid,
    this.restaurantLogoImageUrl,
    this.platformfee,
    this.cuisineIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurantName': restaurantName,
      'deliveryFee': deliveryFee,
      'minTime': minTime,
      'maxTime': maxTime,
      'average_ratings': averageRatings,
      'total_ratngs': totalRatings,
      'address': address,
      'phoneNumber': phoneNumber,
      'deliveryArea': deliveryArea,
      'postalCode': postalCode,
      'idNumber': idNumber,
      'description': description,
      'lat': lat,
      'long': long,
      'businessEmail': email,
      'idFirstName': idFirstName,
      'idLastName': idLastName,
      'idPhotoUrl': idPhotoUrl,
      'paymentMethod': paymentMethod,
      'openingHours': openingHours,
      'restaurantImageUrl': restaurantImageUrl,
      'rest_uid': restuid,
      'restLogoUrl': restaurantLogoImageUrl,
      'platformfee': platformfee,
      'cuisineIds': cuisineIds,
    };
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      restaurantName: asString(json['restaurantName']),
      deliveryFee: asDoubleOrNull(json['deliveryFee']),
      minTime: asIntOrNull(json['minTime']),
      maxTime: asIntOrNull(json['maxTime']),
      averageRatings: asDoubleOrNull(json['average_ratings']),
      totalRatings: asIntOrNull(json['total_ratings']),
      address: asString(json['address']),
      phoneNumber: asIntOrNull(json['phoneNumber']),
      deliveryArea: asString(json['deliveryArea']),
      postalCode: asString(json['postalCode']),
      idNumber: asIntOrNull(json['idNumber']),
      description: asString(json['description']),
      lat: asDoubleOrNull(json['lat']),
      long: asDoubleOrNull(json['long']),
      email: asString(json['businessEmail']),
      idFirstName: asString(json['idFirstMiddleName'] ?? json['idFirstName']),
      idLastName: asString(json['idLastName']),
      idPhotoUrl: asString(json['idPhotoUrl']),
      paymentMethod: asString(json['paymentMethod']),
      openingHours: asNestedDayMap(json['openingHours']),
      restaurantImageUrl: asString(json['restaurantImageUrl']),
      restuid: asStringOrNull(json['rest_uid']),
      restaurantLogoImageUrl: asStringOrNull(json['restLogoUrl']),
      platformfee: asDoubleOrNull(json['platformfee']),
      cuisineIds: asIntList(json['cuisineIds']),
    );
  }
}
