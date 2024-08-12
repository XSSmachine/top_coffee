class AppConstants {
  static const String APP_NAME = "TopCoffee";
  static const int APP_VERSION = 1;
//--------------------------------------------------------------
  //192.168.178.42
  //192.168.77.105
  static const String BASE_URL = "http://192.168.77.105:8080";
  static const String BASE_SOCKET_URL = "ws://192.168.77.105:8080/ws";
  static const String HTTP_BASE_URL = "http://localhost:8080";
  static const String UPLOAD_URL = "/uploads/";
//--------------------------------------------------------------
  //auth endpoints
  //POST
  static const String REGISTRATION_URI = "/api/auth/register";
  //POST
  static const String LOGIN_URI = "/api/auth/login";
//--------------------------------------------------------------
  //group methods
  //POST + GET /groupID
  static const String GROUP_URI = "/api/groups";
//--------------------------------------------------------------
  //user profile methods
  //POST + GET /userID
  static const String USER_PROFILE = "/api/profiles";
  static const String LEADERBOARD = "/api/profiles/group";
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

  //create order id
  static const String ORDER_CREATE_URI = "/api/orders/create";

  static const String ALL_ORDERS_URI = "/api/orders";
  //static const String ALL_EVENT_ORDERS_URI = "/api/users/orders";//+/userId
  //profilePhotos/669e2573962df236da08c9b9_profileIcon.jpegstatic const String ORDER_RATING_URI = "/api/orders/edit";

  //get all users or get all orders for user id
  static const String USERS_URI =
      "/api/users"; //  .../userID/brew-events/orders
  static const String FETCH_ME_URI = "/api/auth/fetchMe";

  //static const String GEOCODE_URI = 'https://maps.googleapis.com/maps/api/geocode/json';

  static const String TOKEN = "token";
}
