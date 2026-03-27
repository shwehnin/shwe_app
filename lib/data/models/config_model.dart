import 'gift_type_model.dart';
import 'in_app_message.dart';
import 'set_model.dart';
import 'slider_model.dart';
import 'stock_model.dart';
import 'user_model.dart';

class ConfigModel {
  final List<String>? bannedKeywords;
  final List<String>? avatars;
  final AppMessage? appMessage;
  final MarqueeText? marqueeText;
  final List<SETModel>? setHoliday;
  final List<SliderModel>? slider;
  final List<GiftTypeModel>? giftType;
  final StockModel? latestData;
  final User? user;
  final String? today;
  const ConfigModel({
    this.bannedKeywords,
    this.avatars,
    this.today,
    this.appMessage,
    this.marqueeText,
    this.setHoliday,
    this.slider,
    this.giftType,
    this.latestData,
    this.user,
  });
  ConfigModel copyWith({
    List<String>? bannedKeywords,
    List<String>? avatars,
    AppMessage? appMessage,
    String? today,
    MarqueeText? marqueeText,
    List<SETModel>? setHoliday,
    List<SliderModel>? slider,
    List<GiftTypeModel>? giftType,
    StockModel? latestData,
    User? user,
  }) {
    return ConfigModel(
      bannedKeywords: bannedKeywords ?? this.bannedKeywords,
      avatars: avatars ?? this.avatars,
      appMessage: appMessage ?? this.appMessage,
      marqueeText: marqueeText ?? this.marqueeText,
      setHoliday: setHoliday ?? this.setHoliday,
      slider: slider ?? this.slider,
      today: today ?? this.today,
      giftType: giftType ?? this.giftType,
      latestData: latestData ?? this.latestData,
      user: user ?? this.user,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'banned_keywords': bannedKeywords,
      'avatars': avatars,
      'today': today,
      'app_message': appMessage?.toJson(),
      'marquee_text': marqueeText?.toJson(),
      'set_holiday': setHoliday
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'slider': slider
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'gift_type': giftType
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'latest_data': latestData?.toJson(),
      'user': user?.toJson(),
    };
  }

  static ConfigModel fromJson(Map<String, Object?> json) {
    return ConfigModel(
      today: json['today'] as String?,
      bannedKeywords: json['banned_keywords'] == null
          ? null
          : List.from(json['banned_keywords'] as List<dynamic>),
      avatars: json['avatars'] == null
          ? null
          : List.from(json['avatars'] as List<dynamic>),
      appMessage: json['app_message'] == null
          ? null
          : AppMessage.fromJson(json['app_message'] as Map<String, Object?>),
      marqueeText: json['marquee_text'] == null
          ? null
          : MarqueeText.fromJson(json['marquee_text'] as Map<String, Object?>),
      setHoliday: json['set_holiday'] == null
          ? null
          : (json['set_holiday'] as List)
                .map<SETModel>(
                  (data) => SETModel.fromJson(data as Map<String, Object?>),
                )
                .toList(),
      slider: json['slider'] == null
          ? null
          : (json['slider'] as List)
                .map<SliderModel>(
                  (data) => SliderModel.fromJson(data as Map<String, Object?>),
                )
                .toList(),
      giftType: json['gift_type'] == null
          ? null
          : (json['gift_type'] as List)
                .map<GiftTypeModel>(
                  (data) =>
                      GiftTypeModel.fromJson(data as Map<String, Object?>),
                )
                .toList(),
      latestData: json['latest_data'] == null
          ? null
          : StockModel.fromJson(json['latest_data'] as Map<String, Object?>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return '''ConfigModel(
                bannedKeywords:$bannedKeywords,
                avatars:$avatars,
                today:$today,
appMessage:${appMessage.toString()},
marqueeText:${marqueeText.toString()},
setHoliday:${setHoliday.toString()},
slider:${slider.toString()},
giftType:${giftType.toString()},
latestData:${latestData.toString()},
user:${user.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ConfigModel &&
        other.runtimeType == runtimeType &&
        other.bannedKeywords == bannedKeywords &&
        other.avatars == avatars &&
        other.appMessage == appMessage &&
        other.marqueeText == marqueeText &&
        other.setHoliday == setHoliday &&
        other.slider == slider &&
        other.giftType == giftType &&
        other.latestData == latestData &&
        other.user == user &&
        other.today == today;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      bannedKeywords,
      avatars,
      appMessage,
      marqueeText,
      setHoliday,
      slider,
      giftType,
      latestData,
      user,
      today,
    );
  }
}

class User {
  final UserModel? profile;
  final List<UserModel>? blockList;
  const User({this.profile, this.blockList});

  User copyWith({UserModel? profile, List<UserModel>? blockList}) {
    return User(
      profile: profile ?? this.profile,
      blockList: blockList ?? this.blockList,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'profile': profile?.toJson(),
      'block_list': blockList
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
    };
  }

  static User fromJson(Map<String, Object?> json) {
    return User(
      profile: json['profile'] == null
          ? null
          : UserModel.fromJson(json['profile'] as Map<String, Object?>),
      blockList: json['block_list'] == null
          ? null
          : (json['block_list'] as List)
                .map<UserModel>(
                  (data) => UserModel.fromJson(data as Map<String, Object?>),
                )
                .toList(),
    );
  }

  @override
  String toString() {
    return '''User(
                profile:${profile.toString()},
blockList:${blockList.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
        other.runtimeType == runtimeType &&
        other.profile == profile &&
        other.blockList == blockList;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, profile, blockList);
  }
}

class Profile {
  final String? id;
  final String? email;
  final String? cover;
  final String? bio;
  final bool? isBanned;
  final int? reportCount;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final int? V;
  const Profile({
    this.id,
    this.email,
    this.cover,
    this.bio,
    this.isBanned,
    this.reportCount,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  Profile copyWith({
    String? id,
    String? email,
    String? cover,
    String? bio,
    bool? isBanned,
    int? reportCount,
    String? name,
    String? createdAt,
    String? updatedAt,
    int? V,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      cover: cover ?? this.cover,
      bio: bio ?? this.bio,
      isBanned: isBanned ?? this.isBanned,
      reportCount: reportCount ?? this.reportCount,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      V: V ?? this.V,
    );
  }

  Map<String, Object?> toJson() {
    return {
      '_id': id,
      'email': email,
      'cover': cover,
      'bio': bio,
      'is_banned': isBanned,
      'report_count': reportCount,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': V,
    };
  }

  static Profile fromJson(Map<String, Object?> json) {
    return Profile(
      id: json['_id'] == null ? null : json['_id'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      cover: json['cover'] == null ? null : json['cover'] as String,
      bio: json['bio'] == null ? null : json['bio'] as String,
      isBanned: json['is_banned'] == null ? null : json['is_banned'] as bool,
      reportCount: json['report_count'] == null
          ? null
          : json['report_count'] as int,
      name: json['name'] == null ? null : json['name'] as String,
      createdAt: json['createdAt'] == null ? null : json['createdAt'] as String,
      updatedAt: json['updatedAt'] == null ? null : json['updatedAt'] as String,
      V: json['__v'] == null ? null : json['__v'] as int,
    );
  }

  @override
  String toString() {
    return '''Profile(
                id:$id,
email:$email,
cover:$cover,
bio:$bio,
isBanned:$isBanned,
reportCount:$reportCount,
name:$name,
createdAt:$createdAt,
updatedAt:$updatedAt,
V:$V
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Profile &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.email == email &&
        other.cover == cover &&
        other.bio == bio &&
        other.isBanned == isBanned &&
        other.reportCount == reportCount &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.V == V;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      email,
      cover,
      bio,
      isBanned,
      reportCount,
      name,
      createdAt,
      updatedAt,
      V,
    );
  }
}

class MarqueeText {
  final String? content;
  final String? url;
  const MarqueeText({this.content, this.url});
  MarqueeText copyWith({String? content, String? url}) {
    return MarqueeText(content: content ?? this.content, url: url ?? this.url);
  }

  Map<String, Object?> toJson() {
    return {'content': content, 'url': url};
  }

  static MarqueeText fromJson(Map<String, Object?> json) {
    return MarqueeText(
      content: json['content'] == null ? null : json['content'] as String,
      url: json['url'] == null ? null : json['url'] as String,
    );
  }

  @override
  String toString() {
    return '''MarqueeText(
                content:$content,
url:$url
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is MarqueeText &&
        other.runtimeType == runtimeType &&
        other.content == content &&
        other.url == url;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, content, url);
  }
}
