import 'package:shared_preferences/shared_preferences.dart';

class RatedEventsPreferences {
  final SharedPreferences preferences;
  List<String> ratedEventIds = [];

  RatedEventsPreferences({
    required this.preferences

  });

  static const _keyRatedEventIds = 'ratedEventsIds';


  Future saveRatedEventId(String eventId) async {
    ratedEventIds = getRatedEventIds();
    ratedEventIds.add(eventId);
    await preferences.setStringList(_keyRatedEventIds, ratedEventIds);
  }

  List<String> getRatedEventIds() {
    return preferences.getStringList(_keyRatedEventIds) ?? [];

  }
}
