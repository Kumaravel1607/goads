class AdsList {
  String id;
  String ads_name;
  String service_type;
  String city_name;
  String ads_image;
  String category_name;
  String favorite_status;
  String ads_price;

  AdsList(
    this.id,
    this.ads_name,
    this.service_type,
    this.city_name,
    this.ads_image,
    this.category_name,
    this.favorite_status,
    this.ads_price,
  );

  AdsList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    ads_name = json['ads_name'];
    service_type = json['service_type'];
    city_name = json['city_name'];
    ads_image = json['ads_image'];
    category_name = json['category_name'];
    favorite_status = json['favorite_status'];
    ads_price = json['ads_price'].toString();
  }
}