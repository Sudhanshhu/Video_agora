import '../../../../core/common/models/api_response.dart';
import '../entities/user.dart';

abstract class HomeRepository {
  Future<ApiResponse<List<ApiUser>>> fetchUser();
}
