class CategoryList {
  String id;
  String category_name;
  int subcategory;
  String category_image;
  String category_type;

  CategoryList(
    this.id,
    this.category_name,
    this.subcategory,
    this.category_image,
    this.category_type,
  );

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    category_name = json['category_name'];
    subcategory = json['subcategory'];
    category_image = json['category_image'];
    category_type = json['category_type'];
  }
}

class SubCategoryList {
  int id;
  String category_name;
  String sub_category_name;
  String sub_category_type;

  SubCategoryList(
    this.id,
    this.category_name,
    this.sub_category_name,
    this.sub_category_type,
  );

  SubCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_name = json['category_name'];
    sub_category_name = json['sub_category_name'];
    sub_category_type = json['sub_category_type'];
  }
}
