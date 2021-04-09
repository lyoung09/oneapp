import 'package:wellhada_oneapp/listitem/shop/shopInfoListItem.dart';

class Map_model {
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
  Map_model(
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
  double _lat = 0;
  double _lng = 0;
  bool check = false;

  setLocation(double lat, double lng) {
    _lat = lat;
    _lng = lng;
  }

  set setLats(double lat) => _lat = lat;
  set setLngs(double lng) => _lat = lng;

  double get lats => _lat;
  double get lngs => _lng;

  double methodLat() {
    return _lat;
  }
}

class MyClass {
  int _aProperty = 0;

  int get aProperty => _aProperty;

  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}
