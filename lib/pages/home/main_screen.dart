import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/helper/rated_events_preferences.dart';
import 'package:team_coffee/models/order_body_model.dart';
import 'package:team_coffee/models/order_body_rating_model.dart';
import 'package:team_coffee/routes/route_helper.dart';
import 'package:team_coffee/widgets/big_text.dart';
import 'package:team_coffee/widgets/home/countdown_timer_widget.dart';
import 'package:team_coffee/widgets/home/order_list_widget.dart';
import 'package:team_coffee/widgets/home/time_selection_widget.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/user_controller.dart';
import '../../helper/user_preferences.dart';
import '../../models/event+order.dart';
import '../../models/event_body_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/home/event_invitation_widget.dart';
import '../../widgets/home/event_notification_widget.dart';
import '../../widgets/home/order_form_widget.dart';
import '../../widgets/home/order_rating_widget.dart';
import '../../widgets/home/start_brewing_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userRole = 'USER';
  int pendingBrewEvent= 0;
  List<Event> pendingEvents = [];
  List<Event> inProgressEvents = [];
  List<Event> completedEvents = [];

  List<String> ordersForMe= [];

  List<String> ratedEventIds = [];

  final EventController eventController = Get.find<EventController>();
  final UserController user = Get.find<UserController>();
  final OrderController order = Get.find<OrderController>();
  final UserPreferences userPrefs = Get.find<UserPreferences>();
  final RatedEventsPreferences ratedEventsPrefs = Get.find<RatedEventsPreferences>();

  @override
  void initState() {
    super.initState();
    loadUserRole();
    fetchEvents();
  }

  void loadUserRole() {
    setState(() {
      userRole = userPrefs.getUserRole();
    });
  }

  void updateUserRole(String newRole) {
    userPrefs.setUserRole(newRole).then((_) {
      setState(() {
        userRole = newRole;
      });
    });
  }

  void loadRatedEventsList() {
    setState(() {
      ratedEventIds = ratedEventsPrefs.getRatedEventIds();
    });
  }

  void updateRatedEventsList(String eventId) {
    ratedEventsPrefs.saveRatedEventId(eventId);
    setState(() {
      ratedEventIds = ratedEventsPrefs.getRatedEventIds();
    });



  }

  Future<void> fetchEvents() async {
    // Fetch pending events

    pendingEvents.assignAll(await eventController.fetchPendingEvents());

    // Fetch in-progress events
    inProgressEvents.assignAll(await eventController.fetchInProgressEvents()) ;

    // Fetch completed events
    completedEvents.assignAll(await eventController.fetchCompleteEvents());

    // Print details for all events
    print("Pending Events:");
    pendingEvents.forEach((event) {
      print(event.toString());
    });

    print("In-Progress Events:");
    inProgressEvents.forEach((event) {
      print(event.toString());
    });

    print("Completed Events:");
    completedEvents.forEach((event) {
      print(event.toString());
    });

    checkCompletedEventsForRating();

    setState(() {});



  }

  void checkCompletedEventsForRating() {
    for (Event event in completedEvents) {
      if (!ratedEventIds.contains(event.id)) {
        for (Order order in event.orders) {
          if (order.userId == user.getUserIDFromPrefs()) {
            // Show rating dialog for this order
            showDialog(
              context: context,
              builder: (BuildContext context) {
                double rating = 3.0;
                return AlertDialog(
                  title: Text('Rate your coffee'),
                  content: CoffeeRatingWidget(
                    initialRating: rating,
                    onRatingUpdate: (newRating) {
                      rating = newRating;
                    },
                    onRatingSubmit: () async {
                      //await onRatingSubmitted(order.userId, rating.round(), event.id);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
            // Break after showing dialog for the first unrated order
            break;
          }
        }
      }
    }
  }


  void onRatingSubmitted(String orderId, int rating, String eventId) async {
    await order.rateOrder(OrderBodyRating(orderId: orderId, ratingUpdate: rating));
    updateRatedEventsList(eventId);

    setState(() {
      updateUserRole('USER');
    });
  }



  void onStartBrewing() {
    setState(() {
      updateUserRole('CREATOR');
      ordersForMe=[];
    });
    // TODO: Implement coffee brewing options widget
  }

  void onFinishBrewing() {
    setState(() {
      updateUserRole('USER');
      ordersForMe=[];
    });
    eventController.finishEvent();
    //clear all event data
  }

  void onBrewingConfirmed(int duration) async {
    // Create a new event with the specified duration
    final eventCreated = await eventController.createEvent(EventBody(creatorId: user.getUserIDFromPrefs().toString(), time: duration));
    if (eventCreated == null) {
      // Show snackbar message indicating there are already in-progress or pending events

      Get.snackbar("Event in progress", 'There are already in-progress or pending events.',
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white
      );
    } else if (eventCreated) {
      // Event created successfully, navigate to the next screen or update the UI
      setState(() {
        updateUserRole('CREATOR-PENDING');
        pendingBrewEvent = duration;
        fetchEvents();
      });
    } else {
      // Event creation failed, show an error message or handle the failure

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Creating new event failed'),
    ),
    );
    }



    // TODO: Implement timer widget
  }

  bool isOrderPlacedForEvent(Event event) {
    // Simulate checking if an order has been placed for the event
    // In a real scenario, you would check against your backend or local storage
    // For demonstration, we're just setting orderPlaced to true

    bool? maybe = event.orderPlaced ;

    // Return true if an order has been placed
    return maybe ?? false;
  }

  void onAcceptInvitation(Event event) {
    // TODO: Implement CoffeeOrderWidget
  }

  void onDenyInvitation(Event event) {
    setState(() {
      pendingEvents.remove(event);
      fetchEvents();
    });
  }


  void onOrderSubmitted(Event event, String coffeeType, int milkQuantity, int sugarQuantity) async {
    // Update the user's role to CUSTOMER
    setState(() {
      updateUserRole('CUSTOMER');

    });

    // TODO: Submit the coffee order
  }

  void onOrderTimerExpired(Event event) {
    setState(() {

      updateUserRole('USER');
    });
    // TODO: Handle order timer expiration
  }

  void onEventCompleted(Event event) {
    setState(() {
      inProgressEvents.remove(event);
      completedEvents.add(event);
    });
    // TODO: Show CoffeeRatingWidget
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Brewing'),
      ),
      body:RefreshIndicator(
        onRefresh: fetchEvents,
        child: Column(
        children: [
          if (userRole == 'USER')
            BrewCoffeeWidget(
                onStartBrewing: onStartBrewing
            ),
          if (userRole == 'CREATOR')
            TimeSelectionWidget(
              createBrewEvent: (int ) {

                onBrewingConfirmed(int);
                }, onClose: () {
                setState(() {
                  userPrefs.setUserRole('USER');
                  loadUserRole();
                  //fetchEvents();
                });

            },
            ),
          if (userRole == 'CREATOR-PENDING')
            CountdownTimer(
                initialMinutes: pendingBrewEvent, 
              onTimerExpired: () async {
                try {
                  print("Timer expired, executing onTimerExpired callback");

                  // Fetch all orders for the event
                  await order.getAllOrdersForEvent(eventController.getEventIDFromPrefs()!);
                  await fetchEvents();

                  // Update the state and navigate
                  setState(() {
                    userRole = 'CREATOR-ORDERS';
                    print("State updated, navigating to order page");
                  });

                  // Navigate to the order page
                  Get.toNamed(RouteHelper.orderPage, arguments: {'coffeeOrders': order.eventOrders});
                } catch (e) {
                  print("An error occurred in onTimerExpired: $e");
                }
              },
            ),

          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  title: Text('Pending Events'),
                  backgroundColor: AppColors.signColor.withOpacity(0.2),
                  shape: Border(),
                  children: pendingEvents.isNotEmpty
                      ? pendingEvents.map((event) {
                    print("For this event _" + event.toString());
                    return event != null ? CoffeeBrewingAnnouncement(
                      initialRemainingSeconds: event.startTime,
                      creatorName: event.creatorName,
                      onAccept: () {
                        onAcceptInvitationPopUp(event);
                        fetchEvents();
                      },
                      onDeny: () => onDenyInvitation(event),
                      onTimerExpired: () {
                        fetchEvents();
                      },
                      userStatus: userRole,
                    ) : Container(child: BigText(text:"There is no pending events at this time"));
                  }).toList()
                      : [Container(
                    padding: EdgeInsets.all(Dimensions.height15),
                        width: double.maxFinite,
                      height: Dimensions.height30*2,
                      child: Center(child: BigText(text:"There is no pending events at this time")))],
                ),

                ExpansionTile(
                  title: Text('In-Progress Events'),
                  backgroundColor: AppColors.signColor.withOpacity(0.2),
                  shape: Border(),
                  children: inProgressEvents.map((event) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          CoffeeBrewingNotification(
                            padding: EdgeInsets.all(Dimensions.height30),
                            backgroundColor: AppColors.mainColor,
                            message: '${event.creatorName} is currently brewing',
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                ExpansionTile(
                  backgroundColor: AppColors.signColor.withOpacity(0.2),
                  shape: Border(),
                  title: Text('Completed Events'),
                  children: completedEvents.map((event) {
                    return ListTile(
                      title: Text('Event ${event.id}'),
                      subtitle: Text('Completed'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }

  void onAcceptInvitationPopUp(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: CoffeeOrderWidget(
              coffeeTypes: ['Espresso', 'Cappuccino', 'Latte'],
              onOrderPlaced: (coffeeType, milkQuantity, sugarQuantity) {
                // Create order for the event
                order.createOrder(OrderBody(eventId: event.id, creatorId: user.getUserIDFromPrefs().toString(), type: coffeeType, sugarQuantity: sugarQuantity, milkQuantity: milkQuantity));
                // ...
                Navigator.pop(context);
                setState(() {
                  event.setOrderPlaced(true);
                  fetchEvents();
                });
              }, coffeeIcons: [],
            ),
          ),
        );
      },
    );
  }


}
