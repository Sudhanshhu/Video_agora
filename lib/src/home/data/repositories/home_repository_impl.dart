import 'package:ecommerce/core/common/models/api_response.dart';
import 'package:ecommerce/core/utils/api_service.dart';
import 'package:ecommerce/core/utils/helpers.dart';
import 'package:ecommerce/core/utils/pref.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<ApiResponse<List<ApiUser>>> fetchUser() async {
    try {
      if (await Helpers.isInternetPresent()) {
        final res = await ApiService().get("users");
        final users =
            (res as List).map((user) => ApiUser.fromMap(user)).toList();
        await SharedPrefs.setUser(users);
        return ApiResponse.success(users);
      } else {
        final userMap = SharedPrefs.getUser();
        if (userMap == null) {
          throw Exception("No internet and no cached user data available");
        }
        return ApiResponse.success(userMap);
      }
    } catch (e) {
      rethrow;
    }
  }
}
