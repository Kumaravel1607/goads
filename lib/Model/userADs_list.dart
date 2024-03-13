class UserAdsList {
  String id;
  String ads_name;
  String service_type;
  String city_name;
  String ads_image;
  String created_at;
  String ads_description;
  String ads_price;
  String ads_status;
  String posted_at;

  UserAdsList(
    this.id,
    this.ads_name,
    this.service_type,
    this.city_name,
    this.ads_image,
    this.created_at,
    this.ads_description,
    this.ads_price,
    this.ads_status,
    this.posted_at,
  );

  UserAdsList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    ads_name = json['ads_name'];
    service_type = json['service_type'];
    city_name = json['city_name'];
    ads_image = json['ads_image'];
    created_at = json['created_at'];
    ads_description = json['ads_description'];
    ads_price = json['ads_price'].toString();
    ads_status = json['ads_status'].toString();
    posted_at = json['posted_at'];
  }
}