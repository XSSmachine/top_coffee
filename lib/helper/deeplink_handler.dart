import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/base/show_custom_snackbar.dart';
import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../models/group_data.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/group/group_list_screen.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  final AuthController _authController = Get.find<AuthController>();
  final notificationController = Get.find<NotificationController>();

  void onInit() {
    _appLinks = AppLinks();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      handleDeepLink(appLink);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('====>>> error : $err');
      },
      onDone: () {
        _linkSubscription?.cancel();
      },
    );
  }

  void handleDeepLink(Uri uri) {
    if (uri.pathSegments.contains('join')) {
      final groupCode = uri.pathSegments.last;
      if (_authController.userLoggedIn()) {
        _joinGroup(groupCode);
      } else {
        _saveGroupCodeLocally(groupCode);
        Get.to(() => SignInPage());
      }
    }
  }

  void _joinGroup(String groupCode) {
    try {
      _authController
          .joinGroupViaInvitation(groupCode, notificationController)
          .then((group) {
        Group? groupInfo = group;
        if (groupInfo != null) {
          Get.to(() => GroupListScreen());
          Future.delayed(const Duration(milliseconds: 1000), () {
            showCustomEventSnackBar(
                name: groupInfo.name,
                surname: groupInfo.description,
                eventTitle: "Success",
                imageUrl:
                    groupInfo.photoUrl ?? "https://via.placeholder.com/50x50");
          });
        } else {
          Get.snackbar(
              'Issue', 'There was an issue when trying to join the group.');
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to join the group. Please try again.');
    }
  }

  void _saveGroupCodeLocally(String groupCode) {
    // Save the group code locally, e.g., using shared preferences or GetX storage
    // For this example, we'll use a simple variable in the AuthController
    _authController.pendingGroupCode = groupCode;
  }

  // Call this method after successful login or registration
  void checkPendingGroupJoin() {
    if (_authController.pendingGroupCode != null) {
      _joinGroup(_authController.pendingGroupCode!);
      _authController.pendingGroupCode = null;
    }
  }
}
