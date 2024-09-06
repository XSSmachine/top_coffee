import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/controllers/notification_controller.dart';
import 'package:team_coffee/utils/string_resources.dart';

import '../../models/notification.dart';
import '../../utils/dimensions.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final NotificationController _service = Get.find<NotificationController>();
  final List<NotificationModel> _notifications = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  static const int _pageSize = 11;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    print("CALLING NOTIFICATIONS: Page $_currentPage, Size $_pageSize");

    _service
        .fetchNotifications(_currentPage, _pageSize)
        .then((newNotifications) {
      print("Loaded ${newNotifications.length} new notifications");

      setState(() {
        _notifications.addAll(newNotifications);
        _currentPage++;
        _hasMore = newNotifications.length == _pageSize;
      });
    }).catchError((e) {
      print("Error loading notifications: $e");
      Get.snackbar('Error', 'Failed to load notifications');
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.notifications.tr),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () => Get.back(),
          // ),
        ),
        body: _notifications.isEmpty && !_isLoading
            ? Center(
                child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/image/no_notifications.json",
                      height: Dimensions.height45 * 6,
                      width: Dimensions.width30 * 9),
                  Text(AppStrings.noNotifications.tr),
                ],
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _notifications.clear();
                    _currentPage = 0;
                    _hasMore = true;
                  });
                  _loadMore();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _notifications.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _notifications.length) {
                      final notification = _notifications[index];
                      return _buildNotificationTile(notification);
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              notification.photoUri ?? "https://via.placeholder.com/50x50"),
        ),
        title: Text(
          notification.firstName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.additionalOptions['description'] ??
            notification.description),
        // trailing: notification.
        //     ? Icon(Icons.access_time, color: Colors.orange)
        //     : null,
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }
}
