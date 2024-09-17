import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/no_data_page.dart';
import '../../../controllers/event_controller.dart';
import '../../../models/event_model.dart';
import '../../../models/filter_model.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/string_resources.dart';
import '../../../widgets/create_event_widget.dart';
import 'event_item/event_item.dart';
import 'event_list/event_pending_list.dart';
import 'filter_modal_widget.dart';

class SearchAllEventScreen extends StatefulWidget {
  final EventController eventController;
  final List<String> eventStatuses;

  SearchAllEventScreen({
    Key? key,
    required this.eventController,
    required this.eventStatuses,
  }) : super(key: key);

  @override
  State<SearchAllEventScreen> createState() => _SearchAllEventScreenState();
}

class _SearchAllEventScreenState extends State<SearchAllEventScreen> {
  String _searchTerm = '';
  EventFilters _filters =
      EventFilters(eventType: '', status: [], timeFilter: '');
  late TextEditingController _searchController;
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _resetAndFetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {
      _searchTerm = value;
    });
    _resetAndFetch();
  }

  void _onApplyFilters(EventFilters filters) {
    widget.eventController.selectedEventType.value = filters.eventType;
    widget.eventController.selectedEventStatus.value = filters.status;
    widget.eventController.selectedTimeFilter.value =
        filters.timeFilter ?? "THIS_WEEK";
    setState(() {
      _filters = filters;
    });
    _resetAndFetch();
  }

  Future<void> _fetchEvents() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      for (String status in widget.eventStatuses) {
        await widget.eventController.getAllFilteredEvents(
          page: currentPage,
          size: pageSize + 1,
          search: _searchTerm,
          status: status,
          type: _filters.eventType,
        );
      }
      setState(() {
        currentPage++;
        isLoading = false;
        hasMore = widget.eventController.inProgressEventList.length >
            pageSize * widget.eventStatuses.length * currentPage;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching events: $e');
    }
  }

  Future<void> refresh() async {
    await _resetAndFetch();
  }

  Future<void> _resetAndFetch() async {
    setState(() {
      currentPage = 0;
      hasMore = true;
    });
    widget.eventController.clearAllEvents();
    await _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${AppStrings.searchAppBarTitle.tr} ${AppStrings.searchEventsTitle.tr}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '${AppStrings.searchTitle.tr}...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.mainBlueDarkColor,
                        size: Dimensions.iconSize24,
                      ),
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder: (context) =>
                          FilterModal(onApplyFilters: _onApplyFilters),
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.filter_list,
                        color: AppColors.mainBlueDarkColor, size: 20),
                  ),
                  label: Text(
                    AppStrings.filtersTitle.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainBlueDarkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10, vertical: 4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    for (String status in widget.eventStatuses)
                      EventList(
                        eventController: widget.eventController,
                        eventStatus: status,
                        searchTerm: _searchTerm,
                        filters: _filters,
                        eventList: status == "PENDING"
                            ? widget.eventController.pendingEventList
                            : status == "IN_PROGRESS"
                                ? widget.eventController.inProgressEventList
                                : widget.eventController.completedEventList,
                        onLoadMore: _fetchEvents,
                        isLoading: isLoading,
                        hasMore: hasMore,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventList extends StatefulWidget {
  final EventController eventController;
  final String eventStatus;
  final String searchTerm;
  final EventFilters filters;
  final List<EventModel> eventList;
  final VoidCallback onLoadMore;
  final bool isLoading;
  final bool hasMore;

  const EventList({
    Key? key,
    required this.eventController,
    required this.eventStatus,
    required this.searchTerm,
    required this.filters,
    required this.eventList,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (eventController) {
        final events = widget.eventList;
        return Theme(
          data: Theme.of(context)
              .copyWith(dividerColor: AppColors.mainBlueDarkColor),
          child: ExpansionTile(
            title: Text(
              '${widget.eventStatus.tr} (${events.length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.contentColorWhite,
            collapsedBackgroundColor: Colors.white,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 20),
                itemCount: events.length + 1,
                itemBuilder: (context, index) {
                  if (index < events.length) {
                    final event = events[index];
                    return EventListItem(
                      event: event,
                      eventStatus: widget.eventStatus,
                      onTap: (String eventId) {
                        Get.toNamed(RouteHelper.getEventDetail(
                          eventId,
                          widget.eventStatus,
                          null,
                        ));
                      },
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: widget.isLoading
                            ? CircularProgressIndicator()
                            : widget.hasMore
                                ? Text('Load More')
                                : Text('No More Events'),
                      ),
                    );
                  }
                },
              ),
            ],
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
          ),
        );
      },
    );
  }
}
