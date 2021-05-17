import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class ShopInfo {
  String status;
  int cnt;
  UsagePoint inFolist;
  final List<UsagePoint> list;

  ShopInfo({this.status, this.cnt, this.list, this.inFolist});

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        status: json["STATUS"],
        inFolist: UsagePoint.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": inFolist.toJson(),
      };

  factory ShopInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$ShopInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ShopInfoItemToJsonMap(this);
}

ShopInfo _$ShopInfoItemFromJsonMap(Map<String, dynamic> json) {
  return ShopInfo(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : UsagePoint.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ShopInfoItemToJsonMap(ShopInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class UsagePoint {
  String usingPoint;
  String dateTime;
  String placeName;
  String order;
  String point;

  String id;

  UsagePoint(
      {this.usingPoint,
      this.dateTime,
      this.placeName,
      this.order,
      this.point,
      this.id});
  factory UsagePoint.fromJson(Map<String, dynamic> json) => UsagePoint(
        usingPoint: json["usingPoint"],
        dateTime: json["date_time"],
        order: json["order"],
        point: json["point"],
        placeName: json['place_name'],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "usingPoint": usingPoint,
        "date_time": dateTime,
        "place_name": placeName,
        "order": order,
        "point": point,
        "id": id,
      };
  factory UsagePoint.fromJsonMap(Map<String, dynamic> json) =>
      _$UsagePointFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$UsagePointToJsonMap(this);
}

UsagePoint _$UsagePointFromJsonMap(Map<String, dynamic> json) {
  return UsagePoint(
    usingPoint: json['usingPoint'] as String,
    placeName: json['place_name'] as String,
    dateTime: json['date_time'] as String,
    order: json['order'] as String,
    point: json['point'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$UsagePointToJsonMap(UsagePoint instance) =>
    <String, dynamic>{
      'usingPoint': instance.usingPoint,
      'place_name': instance.placeName,
      'date_time': instance.dateTime,
      'order': instance.order,
      'point': instance.point,
      'id': instance.id,
    };

Future<Map<String, dynamic>> getUsagePointList() async {
  final response = await http
      .get('https://run.mocky.io/v3/cdccb31e-5ced-4ee3-9cfb-810827f8e068');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<ShopInfo> getUsagePointEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/cdccb31e-5ced-4ee3-9cfb-810827f8e068');

  if (response.statusCode == 200) {
    return ShopInfo.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
////////////USERFAVORITE/////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

class FavoriteInfo {
  String status;
  int cnt;
  Favorite favoriteList;
  final List<Favorite> list;

  FavoriteInfo({this.status, this.cnt, this.list, this.favoriteList});

  factory FavoriteInfo.fromJson(Map<String, dynamic> json) => FavoriteInfo(
        status: json["STATUS"],
        favoriteList: Favorite.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": favoriteList.toJson(),
      };

  factory FavoriteInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$FavoriteInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$FavoriteInfoItemToJsonMap(this);
}

FavoriteInfo _$FavoriteInfoItemFromJsonMap(Map<String, dynamic> json) {
  return FavoriteInfo(
    list: (json['LIST'] as List)
        ?.map((e) =>
            e == null ? null : Favorite.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$FavoriteInfoItemToJsonMap(FavoriteInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class Favorite {
  String placeUrl;
  String placeName;
  String roadAddressName;
  String addressName;
  String userId;
  String wellhadaShop;
  String favorite;
  String shopId;
  String phone;
  Favorite(
      {this.placeUrl,
      this.placeName,
      this.roadAddressName,
      this.addressName,
      this.shopId,
      this.userId,
      this.favorite,
      this.wellhadaShop});
  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        placeUrl: json["place_url"],
        roadAddressName: json["road_address_name"],
        addressName: json["address_name"],
        placeName: json['place_name'],
        shopId: json["shopId"],
        userId: json["userId"],
        favorite: json["favorite"],
        wellhadaShop: json["wellhada_shop"],
      );

  Map<String, dynamic> toJson() => {
        "place_url": placeUrl,
        "road_address_name": roadAddressName,
        "place_name": placeName,
        "address_name": addressName,
        "shopId": shopId,
        "userId": userId,
        "favorite": favorite,
        "wellhada_shop": wellhadaShop,
      };
  factory Favorite.fromJsonMap(Map<String, dynamic> json) =>
      _$FavoriteFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$FavoriteToJsonMap(this);
}

Favorite _$FavoriteFromJsonMap(Map<String, dynamic> json) {
  return Favorite(
    placeUrl: json['place_url'] as String,
    placeName: json['place_name'] as String,
    roadAddressName: json['road_address_name'] as String,
    addressName: json['address_name'] as String,
    shopId: json['shopId'] as String,
    userId: json['userId'] as String,
    favorite: json['favorite'] as String,
    wellhadaShop: json['wellhada_shop'] as String,
  );
}

Map<String, dynamic> _$FavoriteToJsonMap(Favorite instance) =>
    <String, dynamic>{
      'place_url': instance.placeUrl,
      'place_name': instance.placeName,
      'road_address_name': instance.roadAddressName,
      'address_name': instance.addressName,
      'shopId': instance.shopId,
      'userId': instance.userId,
      'favorite': instance.favorite,
      'wellhada_shop': instance.wellhadaShop,
    };

Future<Map<String, dynamic>> getFavoriteList() async {
  final response = await http
      .get('https://run.mocky.io/v3/937ec6e2-6911-4c2b-91b4-b4880ce776c1');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<Favorite> getFavoriteEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/937ec6e2-6911-4c2b-91b4-b4880ce776c1');

  if (response.statusCode == 200) {
    return Favorite.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
////////////USERREVIEW///////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

class ReviewInfo {
  String status;
  int cnt;
  Review reviewList;
  final List<Review> list;

  ReviewInfo({this.status, this.cnt, this.list, this.reviewList});

  factory ReviewInfo.fromJson(Map<String, dynamic> json) => ReviewInfo(
        status: json["STATUS"],
        reviewList: Review.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": reviewList.toJson(),
      };

  factory ReviewInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$ReviewInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$ReviewInfoItemToJsonMap(this);
}

ReviewInfo _$ReviewInfoItemFromJsonMap(Map<String, dynamic> json) {
  return ReviewInfo(
    list: (json['LIST'] as List)
        ?.map((e) =>
            e == null ? null : Review.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$ReviewInfoItemToJsonMap(ReviewInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class Review {
  String placeUrl;
  String placeName;
  String userId;
  String userName;
  String userProfile;
  String date;
  String order;
  String review;
  String shopId;
  String using;
  Review(
      {this.placeUrl,
      this.placeName,
      this.date,
      this.order,
      this.shopId,
      this.userId,
      this.userProfile,
      this.review,
      this.userName,
      this.using});
  factory Review.fromJson(Map<String, dynamic> json) => Review(
        placeUrl: json["place_url"],
        date: json["date"],
        order: json["order"],
        placeName: json['place_name'],
        shopId: json["shopId"],
        userId: json["userId"],
        userName: json["userName"],
        userProfile: json["user_profile"],
        review: json["review"],
        using: json["using"],
      );

  Map<String, dynamic> toJson() => {
        "place_url": placeUrl,
        "place_name": placeName,
        "date": date,
        "order": order,
        "shopId": shopId,
        "userId": userId,
        "user_name": userName,
        "user_profile": userProfile,
        "review": review,
        "using": using,
      };
  factory Review.fromJsonMap(Map<String, dynamic> json) =>
      _$ReviewFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$ReviewToJsonMap(this);
}

Review _$ReviewFromJsonMap(Map<String, dynamic> json) {
  return Review(
    placeUrl: json['place_url'] as String,
    placeName: json['place_name'] as String,
    date: json['date'] as String,
    order: json['order'] as String,
    shopId: json['shopId'] as String,
    userId: json['userId'] as String,
    userName: json['user_name'] as String,
    userProfile: json['user_profile'] as String,
    review: json['review'] as String,
    using: json['using'] as String,
  );
}

Map<String, dynamic> _$ReviewToJsonMap(Review instance) => <String, dynamic>{
      'place_url': instance.placeUrl,
      'place_name': instance.placeName,
      'date': instance.date,
      'order': instance.order,
      'shopId': instance.shopId,
      'userId': instance.userId,
      'user_name': instance.userName,
      'user_profile': instance.userProfile,
      'using': instance.using,
      'review': instance.review,
    };

Future<Map<String, dynamic>> getReviewList() async {
  final response = await http
      .get('https://run.mocky.io/v3/20c189c1-8ae8-445e-8b07-c65edad3026b');

  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<Review> getReviewEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/20c189c1-8ae8-445e-8b07-c65edad3026b');

  if (response.statusCode == 200) {
    return Review.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
////////////MyReview/////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

class MyMyReviewInfo {
  String status;
  int cnt;
  MyReview myReviewList;
  final List<MyReview> list;

  MyMyReviewInfo({this.status, this.cnt, this.list, this.myReviewList});

  factory MyMyReviewInfo.fromJson(Map<String, dynamic> json) => MyMyReviewInfo(
        status: json["STATUS"],
        myReviewList: MyReview.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": myReviewList.toJson(),
      };

  factory MyMyReviewInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$MyMyReviewInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$MyMyReviewInfoItemToJsonMap(this);
}

MyMyReviewInfo _$MyMyReviewInfoItemFromJsonMap(Map<String, dynamic> json) {
  return MyMyReviewInfo(
    list: (json['LIST'] as List)
        ?.map((e) =>
            e == null ? null : MyReview.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
//      meta: (json['meta'] as List)
//          ?.map((e) =>
//      e == null ? null : Meta.fromJson(e as Map<String, dynamic>))
//          ?.toList()
  );
}

Map<String, dynamic> _$MyMyReviewInfoItemToJsonMap(MyMyReviewInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class MyReview {
  String placeUrl;
  String placeName;
  String userId;
  String date;
  String order;
  String review;
  String shopId;
  String reviewPicutre;
  String story;
  String using;
  MyReview({
    this.placeUrl,
    this.placeName,
    this.date,
    this.order,
    this.shopId,
    this.userId,
    this.review,
    this.story,
    this.using,
    this.reviewPicutre,
  });
  factory MyReview.fromJson(Map<String, dynamic> json) => MyReview(
        placeUrl: json["place_url"],
        date: json["date"],
        order: json["order"],
        placeName: json['place_name'],
        shopId: json["shopId"],
        userId: json["userId"],
        review: json["review"],
        story: json["story"],
        using: json["using"],
        reviewPicutre: json["review_picutre"],
      );

  Map<String, dynamic> toJson() => {
        "place_url": placeUrl,
        "place_name": placeName,
        "date": date,
        "order": order,
        "shopId": shopId,
        "userId": userId,
        "review": review,
        "story": story,
        "using": using,
        "review_picutre": reviewPicutre,
      };
  factory MyReview.fromJsonMap(Map<String, dynamic> json) =>
      _$MyReviewFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$MyReviewToJsonMap(this);
}

MyReview _$MyReviewFromJsonMap(Map<String, dynamic> json) {
  return MyReview(
    placeUrl: json['place_url'] as String,
    placeName: json['place_name'] as String,
    date: json['date'] as String,
    order: json['order'] as String,
    shopId: json['shopId'] as String,
    userId: json['userId'] as String,
    review: json['review'] as String,
    story: json['story'] as String,
    reviewPicutre: json['review_picutre'] as String,
    using: json['using'] as String,
  );
}

Map<String, dynamic> _$MyReviewToJsonMap(MyReview instance) =>
    <String, dynamic>{
      'place_url': instance.placeUrl,
      'place_name': instance.placeName,
      'date': instance.date,
      'order': instance.order,
      'shopId': instance.shopId,
      'userId': instance.userId,
      'story': instance.story,
      'review_picutre': instance.reviewPicutre,
      'review': instance.review,
      'using': instance.using,
    };

Future<Map<String, dynamic>> getMyReviewList() async {
  final response = await http
      .get('https://run.mocky.io/v3/ecacd0f4-3bc4-45ce-ae27-44d24340ff57');
  if (200 == response.statusCode) {
    var datauser = json.decode(response.body);
    return datauser;
  } else {
    return json.decode(response.body);
  }
}

Future<MyReview> getMyReviewEntire() async {
  // http.Response response = await http.post(
  //   Uri.encodeFull('https://wellhada.com/getAppNoticeList'),
  //   headers: {"Accept": "application/json"},
  //   body: {'period': 'ALL'},
  // );
  final response = await http
      .get('https://run.mocky.io/v3/ecacd0f4-3bc4-45ce-ae27-44d24340ff57');

  if (response.statusCode == 200) {
    return MyReview.fromJsonMap(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////실제 서버///////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////회원 가입///////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

class Insert {
  final String status;
  final int resultCount;

  Insert(
    this.status,
    this.resultCount,
  );
  // Status.fromJson(Map<String,dynamic> json):STATUS:json['STATUS'],resultCount:json['resultCount'];

  Insert.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        resultCount = json['resultCount'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'resultCount': resultCount,
      };
}

Future<Insert> insertUser(
  String userChk,
  String userId,
  String userPassword,
  String email,
  String userPhoneNumber,
  String userName,
  String gender,
  String birthdayJson,
  String marketing,
  String appPushToken,
  String appAgreeService,
  String appAgreePrivacy,
  String appAgreePush,
) async {
  var bodyParam = new Map();
  bodyParam['userChk'] = userChk;
  bodyParam['userId'] = userId;
  bodyParam['userPassword'] = userPassword;
  bodyParam['userEmail'] = email;
  bodyParam['userPhoneNumber'] = userPhoneNumber;
  bodyParam['userName'] = userName;
  bodyParam['gender'] = gender == null ? null : gender;
  bodyParam['birthdayJson'] = birthdayJson == null ? null : birthdayJson;
  bodyParam['marketing'] = marketing;
  bodyParam['appPushToken'] = appPushToken;
  bodyParam['appAgreeService'] = appAgreeService;
  bodyParam['appAgreePrivacy'] = appAgreePrivacy;
  bodyParam['appAgreePush'] = appAgreePush;
  print(bodyParam);
  http.Response response = await http.post(
    Uri.encodeFull('http://192.168.0.47:8080/insertUser'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    return Insert.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////로그인///////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

@JsonSerializable()
class Status {
  final String status;
  final String accessToken;
  final int cnt;

  Status(
    this.status,
    this.accessToken,
    this.cnt,
  );
  Status.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        accessToken = json['ACCESSTOKEN'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        'STATUS': status,
        'ACCESSTOKEN': accessToken,
        'cnt': cnt,
      };
}

class UserItem {
  UserItem({
    this.userID,
    this.userPassword,
    this.idIntre,
    this.userChk,
    this.limitYn,
  });
  final String userID;
  final String userPassword;
  final String idIntre;
  final String userChk;
  final String limitYn;

  factory UserItem.fromJson(Map<String, dynamic> json) =>
      _$UserItemFromJson(json);
  Map<String, dynamic> toJson() => _$UserItemToJson(this);
}

UserItem _$UserItemFromJson(Map<String, dynamic> json) {
  return UserItem(
    userID: json['userId'] as String,
    userPassword: json['userPassword'] as String,
    idIntre: json['id_intre'] as String,
    limitYn: json['limitYn'] as String,
    userChk: json['userChk'] as String,
  );
}

Map<String, dynamic> _$UserItemToJson(UserItem instance) => <String, dynamic>{
      'userId': instance.userID,
      'userPassword': instance.userPassword,
      'id_intre': instance.idIntre,
      'limitYn': instance.limitYn,
      'userChk': instance.userChk,
    };

Future<Status> loginUser(String userEmail, String userPassword, String idIntre,
    String userChk, String limitYn) async {
  var bodyParam = new Map();

  bodyParam['userId'] = userEmail;
  bodyParam['userPassword'] = userPassword;
  bodyParam['id_intre'] = idIntre;
  bodyParam['limitYn'] = limitYn;
  bodyParam['userChk'] = userChk;

  http.Response response = await http.post(
    //Uri.encodeFull('http://hndsolution.iptime.org:8080/login'),
    Uri.encodeFull('http://192.168.0.47:8080/login'),

    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    print(bodyParam);
    return Status.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////회원 정보 조회//////////////////
////////////////get user info//////////////////
///////////////////////////////////////////////

class UserInfo {
  String status;
  int cnt;
  UserInfoDetail userList;
  final List<UserInfoDetail> list;

  UserInfo({this.status, this.cnt, this.list, this.userList});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        status: json["STATUS"],
        userList: UserInfoDetail.fromJson(json["LIST"]),
        cnt: json["CNT"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cnt": cnt,
        "list": userList.toJson(),
      };

  factory UserInfo.fromJsonMap(Map<String, dynamic> json) =>
      _$UserInfoItemFromJsonMap(json);

  Map<String, dynamic> toJsonMap() => _$UserInfoItemToJsonMap(this);
}

UserInfo _$UserInfoItemFromJsonMap(Map<String, dynamic> json) {
  return UserInfo(
    list: (json['LIST'] as List)
        ?.map((e) => e == null
            ? null
            : UserInfoDetail.fromJsonMap(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserInfoItemToJsonMap(UserInfo instance) =>
    <String, dynamic>{'documents': instance.list};

class UserInfoDetail {
  String userEmail;
  String userId;
  String userName;
  String userPhoneNumber;
  String appAgreeMarketing;
  String userCheck;

  UserInfoDetail({
    this.userEmail,
    this.userId,
    this.userName,
    this.userPhoneNumber,
    this.appAgreeMarketing,
    this.userCheck,
  });
  factory UserInfoDetail.fromJson(Map<String, dynamic> json) => UserInfoDetail(
        userEmail: json["USER_EMAIL"],
        userId: json["USER_ID"],
        userName: json["USER_NAME"],
        userPhoneNumber: json['USER_PHONE_NUMBER'],
        appAgreeMarketing: json["APP_AGREE_MARKETING_YN"],
        userCheck: json["USER_CHECK"],
      );

  Map<String, dynamic> toJson() => {
        "USER_EMAIL": userEmail,
        "USER_ID": userId,
        "USER_NAME": userName,
        "USER_PHONE_NUMBER": userPhoneNumber,
        "APP_AGREE_MARKETING_YN": appAgreeMarketing,
        "USER_CHECK": userCheck,
      };
  factory UserInfoDetail.fromJsonMap(Map<String, dynamic> json) =>
      _$UserInfoDetailFromJsonMap(json);
  Map<String, dynamic> toJsonMap() => _$UserInfoDetailToJsonMap(this);
}

UserInfoDetail _$UserInfoDetailFromJsonMap(Map<String, dynamic> json) {
  return UserInfoDetail(
    userEmail: json['USER_EMAIL'] as String,
    userId: json['USER_ID'] as String,
    userName: json['USER_NAME'] as String,
    userPhoneNumber: json['USER_PHONE_NUMBER'] as String,
    appAgreeMarketing: json['APP_AGREE_MARKETING_YN'] as String,
    userCheck: json['USER_CHECK'] as String,
  );
}

Map<String, dynamic> _$UserInfoDetailToJsonMap(UserInfoDetail instance) =>
    <String, dynamic>{
      'USER_EMAIL': instance.userEmail,
      'USER_ID': instance.userId,
      'USER_NAME': instance.userName,
      'USER_PHONE_NUMBER': instance.userPhoneNumber,
      'APP_AGREE_MARKETING_YN': instance.appAgreeMarketing,
      'USER_CHECK': instance.userCheck,
    };

Future<UserInfo> getUserInfoDetailList(String userEmail) async {
  var bodyParam = new Map();
  bodyParam['userId'] = userEmail;

  http.Response response = await http.post(
    //Uri.encodeFull('http://hndsolution.iptime.org:8080/getUserInfo'),
    Uri.encodeFull('http://192.168.0.47:8080/getUserInfo'),
    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (200 == response.statusCode) {
    print(response.body);
    return UserInfo.fromJsonMap(json.decode(response.body));
  } else {
    return json.decode(response.body);
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////회원 정보 수정//////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
@JsonSerializable()
class UpdateUser {
  final String status;
  final int cnt;

  UpdateUser(this.status, this.cnt);

  UpdateUser.fromJson(Map<String, dynamic> json)
      : status = json['STATUS'],
        cnt = json['CNT'];

  Map<String, dynamic> toJson() => {
        "STATUS": status,
        "CNT": cnt,
      };
}

Future<UpdateUser> updateUser(
  String userId,
  String userPassword,
  String userProfile,
  String userEmail,
  String userName,
  String userPhoneNumber,
  String birthdayJson,
  String gender,
) async {
  var bodyParam = new Map();

  bodyParam["userPhoneNumber"] = userPhoneNumber;

  bodyParam["userEmail"] = userEmail;

  bodyParam['userPassword'] = userPassword;
  bodyParam["gender"] = gender;
  bodyParam["userId"] = userId;
  bodyParam["userName"] = userName;
  bodyParam["user_profile"] = userProfile;
  bodyParam["birthdayJson"] = birthdayJson;

  http.Response response = await http.post(
    //Uri.encodeFull('http://hndsolution.iptime.org:8080/updateUserInfo'),
    Uri.encodeFull('http://192.168.0.47:8080/updateUserInfo'),

    headers: {"Accept": "application/json"},
    body: bodyParam,
  );

  if (response.statusCode == 200) {
    return UpdateUser.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
      'Unexpected status code ${response.statusCode}:'
      ' ${response.reasonPhrase}',
      //uri: Uri.parse(query)
    );
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////회원 탈퇴///////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

///////////////////////////////////////////////
///////////////////////////////////////////////
////////////////로그아웃//////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
