class AdsDetail {
  final String id;
  final String customer_id;
  final String category_id;
  final String sub_category_id;
  final String service_type;
  final int ads_condition;
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
  final String share_link;
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
  final String brand_name;
  final String model;
  final String registration_date;
  final String fuel_type;
  final String engine_size;
  final String insurance_valid;
  final String transmission;
  final String km_driven;
  final String no_of_owner;
  final String seller_by;
  final String type_of_property;
  final String bedrooms_type;
  final String furnished;
  final String construction_status;
  final String listed_by;
  final String car_parking_space;
  final String facing;
  final String form_whom;
  final String super_buildup_area_sq_ft;
  final String carpet_area_sq_ft;
  final String washrooms;
  final String rent_monthly;
  final String property_type;
  final String plot_area;
  final String length;
  final String breadth;
  final String pg_sub_type;
  final String meal_included;
  final String floor;
  final String company_name;
  final String salary_period;
  final String job_type;
  final String qualification;
  final String english;
  final String experience;
  final String gender;
  final String salary_from;
  final String salary_to;
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
  final String working_days_number;
  final List business_city_names;
  final String brand;
  final String purchased_year;
  final String vehicle_type;
  AdsDetail({
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
    this.share_link,
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
    this.brand_name,
    this.model,
    this.registration_date,
    this.fuel_type,
    this.engine_size,
    this.insurance_valid,
    this.transmission,
    this.km_driven,
    this.no_of_owner,
    this.seller_by,
    this.type_of_property,
    this.bedrooms_type,
    this.furnished,
    this.construction_status,
    this.listed_by,
    this.car_parking_space,
    this.facing,
    this.form_whom,
    this.super_buildup_area_sq_ft,
    this.carpet_area_sq_ft,
    this.washrooms,
    this.rent_monthly,
    this.property_type,
    this.plot_area,
    this.length,
    this.breadth,
    this.pg_sub_type,
    this.meal_included,
    this.floor,
    this.company_name,
    this.salary_period,
    this.job_type,
    this.qualification,
    this.english,
    this.experience,
    this.gender,
    this.salary_from,
    this.salary_to,
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
    this.working_days_number,
    this.business_city_names,
    this.brand,
    this.purchased_year,
    this.vehicle_type,
  });

  factory AdsDetail.fromJson(Map<String, dynamic> json) {
    return AdsDetail(
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
      share_link: json['share_link'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      profile_image: json['profile_image'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      join_year: json['join_year'],
      posted_at: json['posted_at'],
      category_name: json['category_name'],
      ads_price_int: json['ads_price_int'].toString(),
      favorite_status: json['favorite_status'],
      ads_type: json['ads_type'],
      brand_name: json['extra']['brand_name'],
      model: json['extra']['model'],
      registration_date: json['extra']['registration_date'],
      fuel_type: json['extra']['fuel_type'],
      engine_size: json['extra']['engine_size'],
      insurance_valid: json['extra']['insurance_valid'],
      transmission: json['extra']['transmission'],
      km_driven: json['extra']['km_driven'],
      no_of_owner: json['extra']['no_of_owner'],
      seller_by: json['extra']['seller_by'],
      type_of_property: json['extra']['type_of_property'],
      bedrooms_type: json['extra']['bedrooms_type'],
      furnished: json['extra']['furnished'],
      construction_status: json['extra']['construction_status'],
      listed_by: json['extra']['listed_by'],
      car_parking_space: json['extra']['car_parking_space'],
      facing: json['extra']['facing'],
      form_whom: json['extra']['form_whom'],
      super_buildup_area_sq_ft: json['extra']['super_buildup_area_sq_ft'],
      carpet_area_sq_ft: json['extra']['carpet_area_sq_ft'],
      washrooms: json['extra']['washrooms'],
      rent_monthly: json['extra']['rent_monthly'],
      property_type: json['extra']['property_type'],
      plot_area: json['extra']['plot_area'],
      length: json['extra']['length'],
      breadth: json['extra']['breadth'],
      pg_sub_type: json['extra']['pg_sub_type'],
      meal_included: json['extra']['meal_included'],
      floor: json['extra']['floor'],
      company_name: json['extra']['company_name'],
      salary_period: json['extra']['salary_period'],
      job_type: json['extra']['job_type'],
      qualification: json['extra']['qualification'],
      english: json['extra']['english'],
      experience: json['extra']['experience'],
      gender: json['extra']['gender'],
      salary_from: json['extra']['salary_from'],
      salary_to: json['extra']['salary_to'],
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
      working_days_number: json['extra']['working_days_number'],
      business_city_names: json['extra']['business_city_names'],
      brand: json['extra']['brand'],
      purchased_year: json['extra']['purchased_year'],
      vehicle_type: json['extra']['vehicle_type'],
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
