enum AppMode { balance, apps }

class UserProfileSettings {
  final String? userID; // Unused Field
  final String? name;
  final String? color;
  final String? animal;
  final String? image;
  final String token;
  final bool registrationRequested; // Unused Field
  final bool hideBalance;
  final AppMode appMode;
  final bool expandPreferences;

  const UserProfileSettings._({
    this.userID,
    this.name,
    this.color,
    this.animal,
    this.image,
    this.token = '',
    this.registrationRequested = false,
    this.hideBalance = false,
    this.appMode = AppMode.balance,
    this.expandPreferences = true,
  });

  UserProfileSettings.initial() : this._();

  UserProfileSettings copyWith({
    String? name,
    String? color,
    String? animal,
    String? image,
    String? token,
    String? userID,
    bool? registrationRequested,
    bool? hideBalance,
    AppMode? appMode,
    bool? expandPreferences,
  }) {
    return UserProfileSettings._(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      color: color ?? this.color,
      animal: animal ?? this.animal,
      image: image ?? this.image,
      token: token ?? this.token,
      registrationRequested: registrationRequested ?? this.registrationRequested,
      hideBalance: hideBalance ?? this.hideBalance,
      appMode: appMode ?? this.appMode,
      expandPreferences: expandPreferences ?? this.expandPreferences,
    );
  }

  bool get registered {
    return userID != null;
  }

  String? get avatarURL =>
      image ?? (animal != null && color != null ? 'breez://profile_image?animal=$animal&color=$color' : null);

  UserProfileSettings.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        token = json['token'],
        name = json['name'],
        color = json['color'],
        animal = json['animal'],
        image = json['image'],
        registrationRequested = json['registrationRequested'] ?? json['token'] != null,
        hideBalance = json['hideBalance'] ?? false,
        appMode = AppMode.values[json["appMode"] ?? 0],
        expandPreferences = json['expandPreferences'] ?? true;

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'token': token,
        'name': name,
        'color': color,
        'animal': animal,
        'image': image,
        'registrationRequested': registrationRequested,
        'hideBalance': hideBalance,
        'appMode': appMode.index,
        'expandPreferences': expandPreferences,
      };
}
