import 'package:get/get.dart';
import '../screens/home/home_view.dart';
import '../screens/home/detail_view.dart';
import '../screens/saved/saved_view.dart';
import '../screens/preferences/preferences_view.dart';


class AppPages {
  static final pages = [
    GetPage(name: '/', page: () => const HomeView()),
    GetPage(name: '/detail', page: () => const DetailView()),
    GetPage(name: '/saved', page: () => const SavedView()),
    GetPage(name: '/preferences', page: () => const PreferencesView()),
  ];
}