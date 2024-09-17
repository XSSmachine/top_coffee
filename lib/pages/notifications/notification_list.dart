import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/controllers/notification_controller.dart';
import 'package:team_coffee/utils/string_resources.dart';

import '../../models/notification.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/icon_and_text_widget.dart';

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
    final bool isRecent =
        DateTime.now().difference(notification.createdAt).inHours < 24;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: isRecent ? 3 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and New Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.photoUri ??
                        "https://via.placeholder.com/80x80",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isRecent)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.mainBlueColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'New',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.contentColorYellow,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12),
            // Title, Description, and Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.firstName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.additionalOptions['description'] ??
                        notification.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatCreationTime(notification.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            // Food Category
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: _buildFilterChip(notification.eventType),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String? foodType) {
    IconData icon;
    String label;
    Color backgroundColor;

    switch (foodType?.toUpperCase()) {
      case "COFFEE":
        icon = Icons.coffee;
        label = AppStrings.coffeeFilter.tr;
        backgroundColor = AppColors.orangeChipColor;
        break;
      case "FOOD":
        icon = Icons.restaurant;
        label = AppStrings.foodFilter.tr;
        backgroundColor = AppColors.greenChipColor;
        break;
      default:
        icon = Icons.liquor;
        label = AppStrings.beverageFilter.tr;
        backgroundColor = AppColors.blueChipColor;
    }

    return FilterChip(
      label: IconAndTextWidget(
        icon: icon,
        text: label,
        iconColor: Colors.white,
        size: IconAndTextSize.extraSmall,
      ),
      backgroundColor: backgroundColor,
      onSelected: (bool value) {},
      selected: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: backgroundColor),
      ),
    );
  }

  String _formatCreationTime(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min ago';
    } else {
      return 'Just now';
    }
  }
}
