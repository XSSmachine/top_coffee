class AppConstants {
  static const String APP_NAME = "TopCoffee";
  static const int APP_VERSION = 1;
//--------------------------------------------------------------
  //192.168.178.42
  //192.168.77.105

  //static const String BASE_URL = "http://192.168.77.105:8080";
  static const String BASE_URL = "https://lobster-app-6i7x3.ondigitalocean.app";
  //static const String BASE_SOCKET_URL = "ws://localhost:8080/ws";
  static const String BASE_SOCKET_URL =
      "wss://lobster-app-6i7x3.ondigitalocean.app/ws";
  //static const String HTTP_BASE_URL = "http://localhost:8080";
  static const String UPLOAD_URL = "/uploads/";
//--------------------------------------------------------------
  //auth endpoints
  //POST
  static const String REGISTRATION_URI = "/api/auth/register";
  //POST
  static const String LOGIN_URI = "/api/auth/login";

  static const String CHANGE_PASS_URI = "/api/auth/changePassword";

  static const String RESET_PASS_URI = "/api/auth/changePassword";

  static const String REQUEST_PASS_URI = "/api/auth/reset-password-request";

//--------------------------------------------------------------
  //group methods
  //POST + GET /groupID
  static const String GROUP_URI = "/api/groups";
//--------------------------------------------------------------
  //user profile methods
  //POST + GET /userID
  static const String USER_PROFILE = "/api/profiles";
  static const String LEADERBOARD = "/api/groups/leaderboard";
  static const String LEADERBOARD_SCORES = "/api/profiles/scores";
  static const String MONTHLY_STATS =
      "/api/profiles/monthly-summary"; //events or orders
  static const String EVENTS_STATS = "/api/profiles/events/stats";
  static const String ORDERS_STATS = "/api/profiles/orders/stats";
  //GET /photoID
  static const String USER_PHOTO = "/api/profiles/profile-photo/download";
//--------------------------------------------------------------
  //create event
  //POST
  static const String EVENT_CREATE_URI =
      "/api/events/create"; // POST -> body: creatorId + pendingTime
  //finish event status
  //GET
  static const String GET_EVENT_URI = "/api/events"; //user id
  //get all events in progress
  //static const String EVENTS_URI = "/api/events"; //?status=COMPLETED but default IN_PROGRESS
  //get event for user which is currently pending
  //static const String EVENT_PENDING = "/api/events/pending/";
//--------------------------------------------------------------
  //create order id
  static const String ORDER_CREATE_URI = "/api/orders/create";

  static const String ALL_ORDERS_URI = "/api/orders";
  //static const String ALL_EVENT_ORDERS_URI = "/api/users/orders";//+/userId
  //profilePhotos/669e2573962df236da08c9b9_profileIcon.jpegstatic const String ORDER_RATING_URI = "/api/orders/edit";

  //--------------------------------------------------------------
  static const String ORDER_STATS = "/api/profiles/orders/stats";
  static const String EVENT_STATS = "/api/profiles/events/stats";
//--------------------------------------------------------------
  //get all users or get all orders for user id
  static const String USERS_URI =
      "/api/users"; //  .../userID/brew-events/orders
  static const String FETCH_ME_URI = "/api/auth/fetchMe";

  static const String ALL_GROUPS_URI = "/api/groups/me";

  static const String KICK_GROUP_URI = "/api/groups/kick";
  static const String JOIN_GROUP_URI = "/api/groups/joinViaInvitation/";
  static const String PROMOTE_GROUP_URI = "/api/groups/promote";
  //--------------------------------------------------------------

  static const String NOTIFICATIONS_LIST = "/api/notifications/recipient";

  //static const String GEOCODE_URI = 'https://maps.googleapis.com/maps/api/geocode/json';

  //--------------------------------------------------------------

  static const String TOKEN = "token";
  static const String ACTIVE_GROUP = "groupID";
}
