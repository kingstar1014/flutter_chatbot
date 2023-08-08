class CustomerSubscriptionModel {
  Entitlements? entitlements;
  AllPurchaseDates? allPurchaseDates;
  List<String>? activeSubscriptions;
  List<String>? allPurchasedProductIdentifiers;
  List<String>? nonSubscriptionTransactions;
  String? firstSeen;
  String? originalAppUserId;
  AllPurchaseDates? allExpirationDates;
  String? requestDate;
  String? latestExpirationDate;
  String? originalPurchaseDate;
  String? originalApplicationVersion;
  String? managementURL;

  CustomerSubscriptionModel(
      {this.entitlements,
      this.allPurchaseDates,
      this.activeSubscriptions,
      this.allPurchasedProductIdentifiers,
      this.nonSubscriptionTransactions,
      this.firstSeen,
      this.originalAppUserId,
      this.allExpirationDates,
      this.requestDate,
      this.latestExpirationDate,
      this.originalPurchaseDate,
      this.originalApplicationVersion,
      this.managementURL});

  CustomerSubscriptionModel.fromJson(Map<String, dynamic> json) {
    entitlements = json['entitlements'] != null ? Entitlements.fromJson(json['entitlements']) : null;
    allPurchaseDates = json['allPurchaseDates'] != null ? AllPurchaseDates.fromJson(json['allPurchaseDates']) : null;
    activeSubscriptions = json['activeSubscriptions'].cast<String>();
    allPurchasedProductIdentifiers = json['allPurchasedProductIdentifiers'].cast<String>();
    nonSubscriptionTransactions = json['nonSubscriptionTransactions'].cast<String>();
    firstSeen = json['firstSeen'];
    originalAppUserId = json['originalAppUserId'];
    allExpirationDates = json['allExpirationDates'] != null ? AllPurchaseDates.fromJson(json['allExpirationDates']) : null;
    requestDate = json['requestDate'];
    latestExpirationDate = json['latestExpirationDate'];
    originalPurchaseDate = json['originalPurchaseDate'];
    originalApplicationVersion = json['originalApplicationVersion'];
    managementURL = json['managementURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (entitlements != null) {
      data['entitlements'] = entitlements!.toJson();
    }
    if (allPurchaseDates != null) {
      data['allPurchaseDates'] = allPurchaseDates!.toJson();
    }
    data['activeSubscriptions'] = activeSubscriptions;
    data['allPurchasedProductIdentifiers'] = allPurchasedProductIdentifiers;
    data['nonSubscriptionTransactions'] = nonSubscriptionTransactions;
    data['firstSeen'] = firstSeen;
    data['originalAppUserId'] = originalAppUserId;
    if (allExpirationDates != null) {
      data['allExpirationDates'] = allExpirationDates!.toJson();
    }
    data['requestDate'] = requestDate;
    data['latestExpirationDate'] = latestExpirationDate;
    data['originalPurchaseDate'] = originalPurchaseDate;
    data['originalApplicationVersion'] = originalApplicationVersion;
    data['managementURL'] = managementURL;
    return data;
  }
}

class Entitlements {
  All? all;
  All? active;

  Entitlements({this.all, this.active});

  Entitlements.fromJson(Map<String, dynamic> json) {
    all = json['all'] != null ? All.fromJson(json['all']) : null;
    active = json['active'] != null ? All.fromJson(json['active']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (all != null) {
      data['all'] = all!.toJson();
    }
    if (active != null) {
      data['active'] = active!.toJson();
    }
    return data;
  }
}

class All {
  Quicklai? quicklai;

  All({this.quicklai});

  All.fromJson(Map<String, dynamic> json) {
    quicklai = json['quicklai'] != null ? Quicklai.fromJson(json['quicklai']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (quicklai != null) {
      data['quicklai'] = quicklai!.toJson();
    }
    return data;
  }
}

class Quicklai {
  String? identifier;
  bool? isActive;
  bool? willRenew;
  String? latestPurchaseDate;
  String? originalPurchaseDate;
  String? productIdentifier;
  bool? isSandbox;
  String? ownershipType;
  String? store;
  String? periodType;
  String? expirationDate;
  String? unsubscribeDetectedAt;
  String? billingIssueDetectedAt;

  Quicklai(
      {this.identifier,
      this.isActive,
      this.willRenew,
      this.latestPurchaseDate,
      this.originalPurchaseDate,
      this.productIdentifier,
      this.isSandbox,
      this.ownershipType,
      this.store,
      this.periodType,
      this.expirationDate,
      this.unsubscribeDetectedAt,
      this.billingIssueDetectedAt});

  Quicklai.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    isActive = json['isActive'];
    willRenew = json['willRenew'];
    latestPurchaseDate = json['latestPurchaseDate'];
    originalPurchaseDate = json['originalPurchaseDate'];
    productIdentifier = json['productIdentifier'];
    isSandbox = json['isSandbox'];
    ownershipType = json['ownershipType'];
    store = json['store'];
    periodType = json['periodType'];
    expirationDate = json['expirationDate'];
    unsubscribeDetectedAt = json['unsubscribeDetectedAt'];
    billingIssueDetectedAt = json['billingIssueDetectedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['isActive'] = isActive;
    data['willRenew'] = willRenew;
    data['latestPurchaseDate'] = latestPurchaseDate;
    data['originalPurchaseDate'] = originalPurchaseDate;
    data['productIdentifier'] = productIdentifier;
    data['isSandbox'] = isSandbox;
    data['ownershipType'] = ownershipType;
    data['store'] = store;
    data['periodType'] = periodType;
    data['expirationDate'] = expirationDate;
    data['unsubscribeDetectedAt'] = unsubscribeDetectedAt;
    data['billingIssueDetectedAt'] = billingIssueDetectedAt;
    return data;
  }
}

class AllPurchaseDates {
  String? quicklaiMonthly;
  String? quicklaiWeekly;

  AllPurchaseDates({this.quicklaiMonthly, this.quicklaiWeekly});

  AllPurchaseDates.fromJson(Map<String, dynamic> json) {
    quicklaiMonthly = json['quicklai_monthly'];
    quicklaiWeekly = json['quicklai_weekly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quicklai_monthly'] = quicklaiMonthly;
    data['quicklai_weekly'] = quicklaiWeekly;
    return data;
  }
}
