import '../flutter_swiper.dart';

class MySwiperController extends IndexController {
  MySwiperController();
  // Autoplay is started
  static const int START_AUTOPLAY = 2;

  // Autoplay is stopped.
  static const int STOP_AUTOPLAY = 3;

  // Indicate that the user is swiping
  static const int SWIPE = 4;

  // Indicate that the `Swiper` has changed it's index and is building it's ui ,so that the
  // `SwiperPluginConfig` is available.
  static const int BUILD = 5;

  // available when `event` == SwiperController.BUILD
  SwiperPluginConfig? config;

  // available when `event` == SwiperController.SWIPE
  // this value is PageViewController.pos
  double? pos;

  bool? autoplay;

  void startAutoplay() {
    event = MySwiperController.START_AUTOPLAY;
    autoplay = true;
    notifyListeners();
  }

  void stopAutoplay() {
    event = MySwiperController.STOP_AUTOPLAY;
    autoplay = false;
    notifyListeners();
  }
}
