import 'package:get_it/get_it.dart';
import 'package:wearable_app/services/notification_service.dart';
import 'package:wearable_app/services/watch_connectivity_service.dart';


final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<WatchConnectivityService>(WatchConnectivityService());

}
