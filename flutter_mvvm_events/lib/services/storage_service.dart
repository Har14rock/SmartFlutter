import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveEventsOffline(String eventsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_events', eventsJson);
  }

  static Future<String?> loadEventsOffline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('offline_events');
  }
}
