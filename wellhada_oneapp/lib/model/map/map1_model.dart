import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart';

class Map1_model {
  String placeUrl;
  String placeName;
  String categoryGroupName;
  String roadAddressName;
  String categoryName;
  String distance;
  String phone;
  String categoryGroupCode;
  String x;
  String y;
  String addressName;
  String id;
  String wellhadaShop;
  String category;
  Map1_model(
      {this.placeUrl,
      this.placeName,
      this.categoryGroupName,
      this.roadAddressName,
      this.categoryName,
      this.distance,
      this.phone,
      this.categoryGroupCode,
      this.x,
      this.y,
      this.addressName,
      this.id,
      this.wellhadaShop,
      this.category});
}

class ShopCategoryList {
  String categorycdnm;
  String categorycd;
  String fileurl;
  ShopCategoryList({this.categorycdnm, this.categorycd, this.fileurl});
}

class MyMapModel {
  double lat;
  double lng;
  bool check;
  MyMapModel({this.lat, this.lng, this.check});
}
