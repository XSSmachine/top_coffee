import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/utils/dimensions.dart';
import 'package:team_coffee/utils/string_resources.dart';
import 'package:team_coffee/widgets/current_event_widget.dart';
import '../../base/no_data_page.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/event_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/icon_and_text_widget.dart';
import 'all_orders_screen.dart';

class TypeOption {
  final String label;
  final Color color;
  final IconData icon;

  TypeOption({required this.label, required this.color, required this.icon});
}

/// This class displays all events that user placed order on and also will display current
/// event which user created + all past completed events and orders
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with WidgetsBindingObserver {
  final GroupController groupController = Get.find<GroupController>();
  bool isActive = true;
  bool showCurrentEvent = false;
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 10;
  String searchQuery = '';
  String filterRating = '';
  String filterType = '';
  bool showFilters = false;
  bool showCancelledOrders = false;

  final List<String> ratingOptions = ['ANY', '1', '2', '3', '4', '5'];
  int currentRatingIndex = 0;
  final List<String> typeOptionsEnglish = ['ALL', 'COFFEE', 'FOOD', 'BEVERAGE'];
  final List<TypeOption> typeOptions = [
    TypeOption(
        label: AppStrings.allFilter.tr,
        color: AppColors.redChipColor,
        icon: Icons.fastfood),
    TypeOption(
        label: AppStrings.coffeeFilter.tr,
        color: AppColors.orangeChipColor,
        icon: Icons.coffee),
    TypeOption(
        label: AppStrings.foodFilter.tr,
        color: AppColors.greenChipColor,
        icon: Icons.restaurant),
    TypeOption(
        label: AppStrings.beverageFilter.tr,
        color: AppColors.blueChipColor,
        icon: Icons.liquor),
  ];
  int currentTypeIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ever(groupController.currentGroupId, (_) async {
      await _fetchOrders();
      await _fetchCurrentEvent();
    });
    _fetchOrders();
    _fetchCurrentEvent();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_loadMore);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchCurrentEvent();
    }
  }

  void _updateRating() {
    setState(() {
      currentRatingIndex = (currentRatingIndex + 1) % ratingOptions.length;
    });
    _resetAndFetch();
  }

  void _updateType() {
    setState(() {
      currentTypeIndex = (currentTypeIndex + 1) % typeOptions.length;
    });
    _resetAndFetch();
  }

  void _loadMore() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !isLoading &&
        hasMore) {
      _fetchOrders();
    }
  }

  void _onActiveToggleChanged(bool value) {
    setState(() {
      isActive = value;
      currentPage = 0; // Reset currentPage when switching tabs
      showCancelledOrders = false; // Reset cancelled orders toggle
    });
    _resetAndFetch();
  }

  void _onCancelledOrdersToggleChanged(bool value) {
    setState(() {
      showCancelledOrders = value;
      currentPage = 0; // Reset currentPage when switching to cancelled orders
    });
    _resetAndFetch();
  }

  Future<void> _fetchOrders() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final newOrders = await Get.find<OrderController>().getFilteredOrders(
        page: currentPage,
        size: pageSize + 1,
        status: isActive
            ? "IN_PROGRESS"
            : (showCancelledOrders ? "CANCELLED" : "COMPLETED"),
        rating: ratingOptions[currentRatingIndex] == "ANY"
            ? ''
            : ratingOptions[currentRatingIndex],
        type: typeOptionsEnglish[currentTypeIndex],
        search: searchQuery,
      );
      setState(() {
        currentPage++;
        isLoading = false;
        hasMore = newOrders.length > pageSize;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching orders: $e');
    }
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    _resetAndFetch();
  }

  void _onFilterChanged() {
    _resetAndFetch();
  }

  void _resetAndFetch() {
    setState(() {
      currentPage = 0;
      hasMore = true;
    });
    Get.find<OrderController>().clearOrders();
    _fetchOrders();
  }

  Future<void> refresh() async {
    _resetAndFetch();
  }

  Future<void> _fetchCurrentEvent() async {
    try {
      await Get.find<EventController>().getActiveEvent2();
    } catch (e) {
      print('Error fetching current event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            padding: EdgeInsets.only(top: Dimensions.height30),
            decoration: BoxDecoration(
              color: AppColors.mainBlueDarkColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radius20),
                bottomRight: Radius.circular(Dimensions.radius20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            duration: Duration(milliseconds: 300),
            height: showFilters
                ? Dimensions.height30 * 8.8
                : Dimensions.height30 * 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width30,
                        vertical: Dimensions.height10),
                    child: AnimatedToggleSwitch<bool>.size(
                      current: isActive,
                      values: const [true, false],
                      iconOpacity: 0.8,
                      indicatorSize: Size.fromWidth(Dimensions.width30 * 5),
                      customIconBuilder: (context, local, global) => Text(
                        local.value
                            ? AppStrings.activeOrders.tr
                            : AppStrings.completedOrders.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.font16 - 2,
                          color: Colors.black,
                        ),
                      ),
                      borderWidth: 4.6,
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                        indicatorColor: AppColors.mainBlueMediumColor,
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      selectedIconScale: 1.0,
                      onChanged: _onActiveToggleChanged,
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width30),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              cursorColor: Colors.amber,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText:
                                    '${AppStrings.searchOrdersTitle.tr}...',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.filter_list, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                showFilters = !showFilters;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: showFilters
                          ? (isActive
                              ? Dimensions.height10 * 6
                              : Dimensions.height10 * 10)
                          : 0,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: Dimensions.width15,
                              right: Dimensions.width15,
                              top: Dimensions.height10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: Dimensions.width20 * 10,
                                        minWidth: Dimensions.width20 * 5,
                                      ),
                                      child: IntrinsicWidth(
                                        child: _buildRatingButton(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: Dimensions.width20 * 10,
                                        minWidth: Dimensions.width20 * 5,
                                      ),
                                      child: IntrinsicWidth(
                                        child: _buildTypeButton(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isActive)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.height10 / 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: showCancelledOrders,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _onCancelledOrdersToggleChanged(
                                                newValue!);
                                            showCancelledOrders = newValue!;
                                          });
                                        },
                                        fillColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected)) {
                                              return Colors.white;
                                            }
                                            return Colors.grey;
                                          },
                                        ),
                                        checkColor: AppColors.mainPurpleColor,
                                      ),
                                      Text(
                                        AppStrings.showCancelled.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimensions.font16),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          StreamBuilder<EventModel?>(
            stream: Get.find<EventController>().currentEventStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              final currentEvent = snapshot.data;
              return currentEvent != null
                  ? Visibility(
                      visible: isActive,
                      child: Focus(
                        child: CurrentEventWidget(event: currentEvent),
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            _fetchCurrentEvent();
                          }
                        },
                      ))
                  : const SizedBox();
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
                switchInCurve: Curves.bounceIn,
                switchOutCurve: Curves.easeOut,
                duration: const Duration(milliseconds: 800),
                child: _buildOrdersList()),
          ),
          // if (isLoading == true)
          //   Padding(
          //     padding: EdgeInsets.only(
          //         top: Dimensions.height10, bottom: Dimensions.height45),
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            _loadMore();
          }
          return true;
        },
        child: GetBuilder<OrderController>(
          key: ValueKey<bool>(isActive),
          builder: (orderController) {
            final orders = orderController.allOrders;
            return orders.isEmpty
                ? Center(
                    child: NoDataPage(
                    text: "${AppStrings.noOrders.tr}...",
                    size: Dimensions.height45 * 2.5,
                  ))
                : ListView.builder(
                    key: ValueKey<bool>(isActive),
                    padding: EdgeInsets.only(top: Dimensions.height20),
                    controller: _scrollController,
                    itemCount: orders.length + 1,
                    itemBuilder: (context, index) {
                      if (index < orders.length) {
                        final order = orders[index];
                        return OrderCard(
                          status: order.status,
                          time: order.createdAt.toString(),
                          name: order.additionalOptions.toString(),
                          foodType: order.eventType,
                          onTap: () {
                            Get.toNamed(
                              RouteHelper.getEventDetail(
                                order.eventId,
                                "orders",
                                order.orderId,
                              ),
                            );
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : hasMore
                                    ? Text(AppStrings.loadMore.tr)
                                    : Text(AppStrings.noMore.tr),
                          ),
                        );
                      }
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _buildRatingButton() {
    return ElevatedButton(
      onPressed: _updateRating,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainBlueDarkColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ratingOptions[currentRatingIndex] == "ANY")
            Row(
              children: [
                Icon(Icons.star,
                    size: Dimensions.iconSize24, color: Colors.amber),
                SizedBox(width: Dimensions.width10),
                Text(
                  AppStrings.any.tr,
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
              ],
            )
          else
            Row(
              children: [
                ...List.generate(
                  int.parse(ratingOptions[currentRatingIndex]),
                  (index) => Icon(Icons.star,
                      size: Dimensions.iconSize24, color: Colors.amber),
                ),
                // SizedBox(width: Dimensions.width10),
                // Text(
                //   int.parse(ratingOptions[currentRatingIndex]) == 1
                //       ? "Star"
                //       : "Stars",
                //   style: TextStyle(fontSize: Dimensions.font16),
                // ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTypeButton() {
    final currentType = typeOptions[currentTypeIndex];
    return ElevatedButton(
      onPressed: _updateType,
      style: ElevatedButton.styleFrom(
        backgroundColor: currentType.color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currentType.icon, size: Dimensions.iconSize24 * 0.8),
          SizedBox(width: Dimensions.width10),
          Text(
            currentType.label,
            style: TextStyle(fontSize: Dimensions.font16),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String status;
  final String time;
  final String name;
  final String foodType;
  final VoidCallback onTap;

  const OrderCard(
      {super.key,
      required this.status,
      required this.time,
      required this.name,
      required this.foodType,
      required this.onTap});

  double _getProgressValue() {
    switch (status) {
      case 'PENDING':
        return 0.33;
      case 'IN_PROGRESS':
        return 0.66;
      case 'COMPLETED':
        return 1.0;
      case 'CANCELLED':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _getImagePath(String eventType) {
    switch (eventType) {
      case "FOOD":
        return 'assets/image/burek.png';
      case "COFFEE":
        return 'assets/image/turska.png';
      case "BEVERAGE":
        return 'assets/image/pice.png';
      default:
        return 'assets/image/placeholder.jpg'; // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _getProgressValue();
    final _formatter = DateFormat('yyyy-MM-dd HH:mm');
    ;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 22.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: 200), // Provide a minimum height
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Allow the column to shrink
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Stack(
                    //fit: StackFit.expand, // Ensure stack fills its container
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            status == "CANCELLED"
                                ? Colors.redAccent
                                : AppColors.mainPurpleColor),
                        backgroundColor: Colors.transparent,
                        minHeight: Dimensions.height20,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                      ),
                      LayoutBuilder(
                        builder: (context, constrains) {
                          var leftPadding = constrains.maxWidth * value -
                              Dimensions.iconSize16 * 1.2;
                          var topPadding =
                              (constrains.maxHeight - Dimensions.iconSize16) /
                                  2;
                          return Padding(
                            padding: EdgeInsets.only(
                                left: leftPadding, top: topPadding),
                            child: status == "CANCELLED"
                                ? Container()
                                : Icon(
                                    Icons.rocket_launch_sharp,
                                    color: Colors.white,
                                    size: Dimensions.iconSize16.toDouble(),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10 / 3,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: Text(
                    status.replaceAll("_", " ").tr,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height10),
                  child: Row(
                    children: [
                      Container(
                        width: Dimensions.height30 * 3.7,
                        height: Dimensions.height30 * 3.7,
                        decoration: BoxDecoration(
                          color: AppColors.mainPurpleColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          child: Image.asset(
                            _getImagePath(foodType ?? "FOOD"),
                            width: Dimensions.height30 * 3.5,
                            height: Dimensions.height30 * 3.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.event, color: Colors.green),
                                const SizedBox(width: 5),
                                Flexible(
                                    child: Text(_formatter
                                        .format(DateTime.parse(time)))),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.label_important_sharp,
                                    color: Colors.deepOrangeAccent),
                                const SizedBox(width: 5),
                                Flexible(child: Text(formatText(name))),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height10 / 2,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                if (foodType == "COFFEE")
                                  FilterChip(
                                    label: IconAndTextWidget(
                                      icon: Icons.coffee,
                                      text: AppStrings.coffeeFilter.tr,
                                      iconColor: Colors.white,
                                      size: IconAndTextSize.small,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.orangeChipColor),
                                    ),
                                    backgroundColor: AppColors.orangeChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                  )
                                else if (foodType == "FOOD")
                                  FilterChip(
                                    label: IconAndTextWidget(
                                      icon: Icons.restaurant,
                                      text: AppStrings.foodFilter.tr,
                                      iconColor: Colors.white,
                                      size: IconAndTextSize.small,
                                    ),
                                    backgroundColor: AppColors.greenChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.greenChipColor),
                                    ),
                                  )
                                else
                                  FilterChip(
                                    label: IconAndTextWidget(
                                      icon: Icons.liquor,
                                      text: AppStrings.beverageFilter.tr,
                                      iconColor: Colors.white,
                                      size: IconAndTextSize.small,
                                    ),
                                    backgroundColor: AppColors.blueChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.blueChipColor),
                                    ),
                                  ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.width10 * 1.2),
                    padding: EdgeInsets.all(Dimensions.width15 / 2.3),
                    decoration: BoxDecoration(
                      color: AppColors.mainPurpleColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      AppStrings.orderDetails.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
