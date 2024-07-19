import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../pages/account/account_page.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/auth/sign_up_page.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/splash/splash_page.dart';



class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String signInPage = "/sign-in";
  static const String signUpPage = "/sign-up";
  static const String initial = "/";
  static const String leaderboardPage="/leaderboard";
  static const String recommendedFood="/recommended-food";
  static const String accountPage = "/account";
  static const String orderPage = "/orders";

  static String getSplashPage()=>'$splashPage';
  static String getSignInPage()=>'$signInPage';
  static String getSignUpPage()=>'$signUpPage';
  static String getInitial()=>'$initial';
  //static String getPopularFood(int pageId, String page)=>'$popularFood?pageId=$pageId&page=$page';
  //static String getRecommendedFood(int pageId, String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  static String getAccountPage()=>'$accountPage';
  static String getOrderPage()=>'$orderPage';
  static String getLeaderboardPage()=>'$leaderboardPage';

  static List<GetPage> routes= [
    //takes in name of the routes and where to go

    GetPage(name: splashPage, page: ()=>SplashScreen()),
    GetPage(name: signInPage, page: ()=>SignInPage()),
    GetPage(name: signUpPage, page: ()=>SignUpPage()),
    GetPage(name: accountPage, page: ()=>AccountPage()),
    GetPage(name: orderPage, page: ()=>OrdersScreen()),
    GetPage(name: "/", page: ()=> HomePage()),
    /*GetPage(name: popularFood, page: (){
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters["page"];
      return PopularFoodDetail(pageId: int.parse(pageId!),page:page!);}),
    GetPage(name: recommendedFood, page: (){var pageId = Get.parameters['pageId'];
    var page = Get.parameters["page"];
      return RecommendedFoodDetail(pageId: int.parse(pageId!),page:page!);},transition: Transition.fadeIn),*/
    /*GetPage(name: leaderboardPage, page: (){
      return LeaderboardPage();
    },*/

  ];
}