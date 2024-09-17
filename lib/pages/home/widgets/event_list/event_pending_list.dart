/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/no_data_page.dart';
import '../../../../controllers/event_controller.dart';
import '../../../../models/event_model.dart';
import '../../../../models/filter_model.dart';
import '../../../../routes/route_helper.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/string_resources.dart';
import '../../../../widgets/create_event_widget.dart';
import '../event_item/event_item.dart';

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
        type: typeOptions[currentTypeIndex].label,
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
              color: AppColors.mainPurpleColor,
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
                        indicatorColor: AppColors.mainPurpleColor,
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
            child: RefreshIndicator(
              onRefresh: refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification) {
                    _loadMore();
                  }
                  return true;
                },
                child: GetBuilder<OrderController>(
                  builder: (orderController) {
                    final orders = orderController.allOrders;
                    return orders.isEmpty
                        ? Center(
                            child: NoDataPage(
                            text: "${AppStrings.noOrders.tr}...",
                            size: Dimensions.height45 * 2.5,
                          ))
                        : ListView.builder(
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
            ),
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
*/
