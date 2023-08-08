import 'dart:io';

import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/utils/Preferences.dart';

class ApiServices {
  // API
  static const baseUrlOfAPI = "https://admin.realjarvis.com/";
  static const apiKey = "base64:cChX/y8POXgM37FyaFOEDpwnpdV9iD2Yb2Q22WK5aAo=";

  static const forgotPassword = "${baseUrlOfAPI}api/v1/forgot-password";
  static const register = "${baseUrlOfAPI}api/v1/register";
  static const login = "${baseUrlOfAPI}api/v1/login";
  static const guestLogin = "${baseUrlOfAPI}api/v1/guest";
  static const getUser = "${baseUrlOfAPI}api/v1/get-user";
  static const categories = "${baseUrlOfAPI}api/v1/categories";
  static const characters = "${baseUrlOfAPI}api/v1/characters";
  static const adsSeenUnlockCharacter =
      "${baseUrlOfAPI}api/v1/ads-seen-unlock-character";
  static const adsSeenLimitIncrease =
      "${baseUrlOfAPI}api/v1/ads-seen-limit-increase";
  static const banners = "${baseUrlOfAPI}api/v1/banners";
  static const subscriptions = "${baseUrlOfAPI}api/v1/subscriptions";
  static const suggestionByCategpry =
      "${baseUrlOfAPI}api/v1/suggestion-by-categpry";
  static const updateProfilePicture =
      "${baseUrlOfAPI}api/v1/update-profile-picture";
  static const settings = "${baseUrlOfAPI}api/v1/settings";
  static const updateProfile = "${baseUrlOfAPI}api/v1/update-profile";
  static const resetLimit = "${baseUrlOfAPI}api/v1/reset-limit";
  static const guestResetLimit = "${baseUrlOfAPI}api/v1/guest-reset-limit";
  static const createUserSubscription =
      "${baseUrlOfAPI}api/v1/create-user-subscription";
  static const deleteAccount = "${baseUrlOfAPI}api/v1/delete-account";
  static const getPromsHistory = "${baseUrlOfAPI}api/v1/get-proms-history";
  static const getChatHistory = "${baseUrlOfAPI}api/v1/get-chat-history";
  static const savePromsHistory = "${baseUrlOfAPI}api/v1/save-proms-history";
  static const saveChatHistory = "${baseUrlOfAPI}api/v1/save-chat-history";
  static const checkEmail = "${baseUrlOfAPI}api/v1/check-email";
  static const updatePassword = "${baseUrlOfAPI}api/v1/update-password";
  static const languages = "${baseUrlOfAPI}api/v1/languages";
  static const socialLogin = "${baseUrlOfAPI}api/v1/social-login";

  static Map<String, String> authHeader = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.connectionHeader: 'keep-alive',
    HttpHeaders.contentTypeHeader: 'application/json',
    'apikey': apiKey,
  };

  static Map<String, String> header = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.connectionHeader: 'keep-alive',
    HttpHeaders.contentTypeHeader: 'application/json',
    'apikey': apiKey,
    'accesstoken': Preferences.getString(Preferences.accessToken)
  };

  // Open AI API
  static const baseUrlOfOpenAi = "https://api.openai.com/v1/";
  static const completions = "${baseUrlOfOpenAi}chat/completions";
  static const generations = "${baseUrlOfOpenAi}images/generations";

  static Map<String, String> headerOpenAI = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.connectionHeader: 'keep-alive',
    HttpHeaders.contentTypeHeader: 'application/json',
    'Authorization': "Bearer ${Constant.openAiApiKey.toString()}",
  };
}
