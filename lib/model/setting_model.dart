class SettingModel {
  String? success;
  String? error;
  SettingData? data;

  SettingModel({this.success, this.error, this.data});

  SettingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? SettingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SettingData {
  int? id;
  String? writerLimit;
  String? chatLimit;
  String? imageLimit;
  String? apikeyAndroidRevenuecat;
  String? apikeyIosRevenuecat;
  String? openaiApiKey;
  String? addIsEnabled;
  String? androidAppId;
  String? iosAppId;
  String? androidBannerId;
  String? iosBannerId;
  String? androidInterstitialId;
  String? iosInterstitialId;
  String? supportEmail;
  String? privacyPolicy;
  String? termsAndConditions;
  String? faq;
  String? appVersion;
  String? adsWriterLimit;
  String? adsChatLimit;
  String? adsImageLimit;
  String? androidRewardAdsId;
  String? iosRewardAdsId;

  SettingData(
      {this.id,
        this.writerLimit,
        this.chatLimit,
        this.imageLimit,
        this.apikeyAndroidRevenuecat,
        this.apikeyIosRevenuecat,
        this.openaiApiKey,
        this.addIsEnabled,
        this.androidAppId,
        this.iosAppId,
        this.androidBannerId,
        this.iosBannerId,
        this.androidInterstitialId,
        this.iosInterstitialId,
        this.supportEmail,
        this.privacyPolicy,
        this.termsAndConditions,
        this.faq,
        this.appVersion,
        this.adsWriterLimit,
        this.adsChatLimit,
        this.adsImageLimit,
        this.androidRewardAdsId,
        this.iosRewardAdsId});

  SettingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    writerLimit = json['writer_limit'];
    chatLimit = json['chat_limit'];
    imageLimit = json['image_limit'];
    apikeyAndroidRevenuecat = json['apikey_android_revenuecat'];
    apikeyIosRevenuecat = json['apikey_ios_revenuecat'];
    openaiApiKey = json['openai_api_key'];
    addIsEnabled = json['add_is_enabled'];
    androidAppId = json['android_app_id'];
    iosAppId = json['ios_app_id'];
    androidBannerId = json['android_banner_id'];
    iosBannerId = json['ios_banner_id'];
    androidInterstitialId = json['android_interstitial_id'];
    iosInterstitialId = json['ios_interstitial_id'];
    supportEmail = json['support_email'];
    privacyPolicy = json['privacy_policy'];
    termsAndConditions = json['terms_and_conditions'];
    faq = json['faq'];
    appVersion = json['app_version'];
    adsWriterLimit = json['ads_writer_limit'];
    adsChatLimit = json['ads_chat_limit'];
    adsImageLimit = json['ads_image_limit'];
    androidRewardAdsId = json['android_reward_ads_id'];
    iosRewardAdsId = json['ios_reward_ads_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['writer_limit'] = writerLimit;
    data['chat_limit'] = chatLimit;
    data['image_limit'] = imageLimit;
    data['apikey_android_revenuecat'] = apikeyAndroidRevenuecat;
    data['apikey_ios_revenuecat'] = apikeyIosRevenuecat;
    data['openai_api_key'] = openaiApiKey;
    data['add_is_enabled'] = addIsEnabled;
    data['android_app_id'] = androidAppId;
    data['ios_app_id'] = iosAppId;
    data['android_banner_id'] = androidBannerId;
    data['ios_banner_id'] = iosBannerId;
    data['android_interstitial_id'] = androidInterstitialId;
    data['ios_interstitial_id'] = iosInterstitialId;
    data['support_email'] = supportEmail;
    data['privacy_policy'] = privacyPolicy;
    data['terms_and_conditions'] = termsAndConditions;
    data['faq'] = faq;
    data['app_version'] = appVersion;
    data['ads_writer_limit'] = adsWriterLimit;
    data['ads_chat_limit'] = adsChatLimit;
    data['ads_image_limit'] = adsImageLimit;
    data['android_reward_ads_id'] = androidRewardAdsId;
    data['ios_reward_ads_id'] = iosRewardAdsId;
    return data;
  }
}
