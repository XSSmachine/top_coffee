import 'package:get/get.dart';
import 'package:team_coffee/pages/auth/verify_email_page.dart';
import 'package:team_coffee/pages/detail/event_details_screen.dart';
import 'package:team_coffee/pages/event/create_event_page.dart';
import 'package:team_coffee/pages/orders/order_selector_screen.dart';
import 'package:team_coffee/widgets/order/create_food_order_widget.dart';

import '../pages/account/account_page.dart';
import '../pages/auth/group_page.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/auth/sign_up_page.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/all_orders_screen.dart';
import '../pages/splash/splash_page.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";

  static const String groupPage = "/group";
  static const String signInPage = "/sign-in";
  static const String signUpPage = "/sign-up";
  static const String verifyEmailPage = "/email";

  static const String initial = "/";
  static const String leaderboardPage = "/leaderboard";
  static const String accountPage = "/account";
  static const String eventCreatePage = "/event-create";

  static const String eventDetail = "/event-detail";

  static const String orderPage = "/orders";
  static const String allOrderPage = "/all-orders";
  static const String createOrderPage = "/create-orders";

  static String getSplashPage() => splashPage;

  static String getGroupPage() => groupPage;

  static String getSignInPage() => signInPage;

  static String getSignUpPage() => signUpPage;

  static String getVerifyEmailPage(String email) =>
      '$verifyEmailPage?email=$email';

  static String getInitial() => initial;

  static String getCreateEventPage() => eventCreatePage;

  static String getEventDetail(String eventId, String page, String? orderId) =>
      '$eventDetail?eventId=$eventId&page=$page&orderId=$orderId';

  static String getAccountPage() => accountPage;

  static String getOrderPage() => orderPage;

  static String getAllOrderPage(
    String eventId,
  ) =>
      '$allOrderPage?eventId=$eventId';

  static String getCreateOrderPage(String eventId, String eventType) =>
      '$createOrderPage?eventId=$eventId&eventType=$eventType';

  static String getLeaderboardPage() => leaderboardPage;

  static List<GetPage> routes = [
    //takes in name of the routes and where to go
    GetPage(name: splashPage, page: () => const SplashScreen()),
    GetPage(name: groupPage, page: () => const GroupPage()),
    GetPage(name: signInPage, page: () => const SignInPage()),
    GetPage(name: signUpPage, page: () => SignUpPage()),
    GetPage(
        name: verifyEmailPage,
        page: () {
          var email = Get.parameters['email'];
          return VerifyEmailScreen(
            email: email!,
          );
        }),
    GetPage(name: accountPage, page: () => const AccountPage()),
    //GetPage(name: orderPage, page: ()=>OrdersScreen()),
    GetPage(
        name: createOrderPage,
        page: () {
          var eventId = Get.parameters['eventId'];
          var eventType = Get.parameters['eventType'];
          return OrderScreenSelector(
            eventType: eventType!,
            eventId: eventId!,
          );
        }),
    GetPage(
        name: allOrderPage,
        page: () {
          var eventId = Get.parameters['eventId'];
          return AllOrdersScreen(
            eventId: eventId!,
          );
        }),
    GetPage(name: "/", page: () => const HomePage()),
    GetPage(name: eventCreatePage, page: () => const CreateEventPage()),
    GetPage(
        name: eventDetail,
        page: () {
          var eventId = Get.parameters['eventId'];
          var orderId = Get.parameters['orderId'];
          var page = Get.parameters["page"];
          return EventDetailsScreen(
            eventId: eventId!,
            page: page!,
            orderId: orderId,
          );
        }),
    /*
    GetPage(name: recommendedFood, page: (){var pageId = Get.parameters['pageId'];
    var page = Get.parameters["page"];
      return RecommendedFoodDetail(pageId: int.parse(pageId!),page:page!);},transition: Transition.fadeIn),*/
    /*GetPage(name: leaderboardPage, page: (){
      return LeaderboardPage();
    },*/
  ];
}
