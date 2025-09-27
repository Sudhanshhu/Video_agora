import 'package:ecommerce/core/utils/pref.dart';

abstract class OnBoardingRepo {
  const OnBoardingRepo();

  Future<void> cacheFirstTimer();

  Future<bool> checkIfUserIsFirstTimer();
}

class OnBoardingRepoImpl implements OnBoardingRepo {
  OnBoardingRepoImpl();

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await SharedPrefs.setBool(PrefsKeys.firstTimer, false);
      return;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      final result = SharedPrefs.getBool(PrefsKeys.firstTimer);
      return result ?? true;
    } catch (e) {
      return Future.error(e);
    }
  }
}
