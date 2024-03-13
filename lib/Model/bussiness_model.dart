class BussinessDetailModel {
  final String id;
  final String customer_id;
  final String category_id;
  final String sub_category_id;
  final String service_type;
  final String ads_condition;
  final String ads_name;
  final String ads_description;
  final String ads_image;
  final String ads_price;
  final String city_name;
  final String door_step;
  final String city_id;
  final String type_of_service;
  final String ads_status;
  final String ads_slug;
  final String created_at;
  final String updated_at;
  final String profile_image;
  final String first_name;
  final String last_name;
  final String join_year;
  final String posted_at;
  final String category_name;
  final String ads_price_int;
  String favorite_status;
  final String ads_type;
  final String owner_name;
  final String mobile_number;
  final String email;
  final String address1;
  final String address2;
  final String pincode;
  final String business_since;
  final List working_days;
  final String working_hours_from;
  final String working_hours_to;
  // final String business_city_id;
  BussinessDetailModel({
    this.id,
    this.customer_id,
    this.category_id,
    this.sub_category_id,
    this.service_type,
    this.ads_condition,
    this.ads_name,
    this.ads_description,
    this.ads_image,
    this.ads_price,
    this.city_name,
    this.door_step,
    this.city_id,
    this.type_of_service,
    this.ads_status,
    this.ads_slug,
    this.created_at,
    this.updated_at,
    this.profile_image,
    this.first_name,
    this.last_name,
    this.join_year,
    this.posted_at,
    this.category_name,
    this.ads_price_int,
    this.favorite_status,
    this.ads_type,
    this.owner_name,
    this.mobile_number,
    this.email,
    this.address1,
    this.address2,
    this.pincode,
    this.business_since,
    this.working_days,
    this.working_hours_from,
    this.working_hours_to,
  });

  factory BussinessDetailModel.fromJson(Map<String, dynamic> json) {
    return BussinessDetailModel(
      id: json['id'].toString(),
      customer_id: json['customer_id'].toString(),
      category_id: json['category_id'].toString(),
      sub_category_id: json['sub_category_id'].toString(),
      service_type: json['service_type'],
      ads_condition: json['ads_condition'],
      ads_name: json['ads_name'],
      ads_description: json['ads_description'],
      ads_image: json['ads_image'],
      ads_price: json['ads_price'].toString(),
      city_name: json['city_name'],
      door_step: json['door_step'] != null ? json['door_step'] : 0,
      city_id: json['city_id'].toString(),
      type_of_service: json['type_of_service'],
      ads_status: json['ads_status'].toString(),
      ads_slug: json['ads_slug'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      profile_image: json['profile_image'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      join_year: json['join_year'],
      posted_at: json['posted_at'],
      category_name: json['category_name'],
      ads_price_int: json['ads_price_int'],
      favorite_status: json['favorite_status'],
      ads_type: json['ads_type'],
      owner_name: json['extra']['owner_name'],
      mobile_number: json['extra']['mobile_number'],
      email: json['extra']['email'],
      address1: json['extra']['address1'],
      address2: json['extra']['address2'],
      pincode: json['extra']['pincode'],
      business_since: json['extra']['business_since'],
      working_days: json['extra']['working_days'],
      working_hours_from: json['extra']['working_hours_from'],
      working_hours_to: json['extra']['working_hours_to'],
    );
  }
}

class AllImage {
  String image_name;
  String id;

  AllImage(
    this.image_name,
    this.id,
  );

  AllImage.fromJson(Map<String, dynamic> json) {
    image_name = json['image_name'];
    id = json['id'].toString();
  }
}
