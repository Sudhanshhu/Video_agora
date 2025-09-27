import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/models/api_response.dart';

abstract class OnBoardingLocalDataSource {
  const OnBoardingLocalDataSource();

  Future<ApiResponse<void>> cacheFirstTimer();

  Future<ApiResponse<bool>> checkIfUserIsFirstTimer();
}

const kFirstTimerKey = 'first_timer';

class OnBoardingLocalDataSrcImpl extends OnBoardingLocalDataSource {
  const OnBoardingLocalDataSrcImpl();

  @override
  Future<ApiResponse<void>> cacheFirstTimer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kFirstTimerKey, false);
      return ApiResponse.success(null);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkIfUserIsFirstTimer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return ApiResponse.success(prefs.getBool(kFirstTimerKey) ?? true);
    } catch (e) {
      return ApiResponse.success(true);
    }
  }
}
