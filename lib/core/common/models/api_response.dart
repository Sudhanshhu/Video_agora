class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
  });

  // Factory constructor for parsing JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    if (json['data'] is List) {
      // Handle List<T>
      return ApiResponse<T>(
        success: json['status'] == 'success',
        data: json['data'] != null && fromJsonT != null
            ? (json['data'] as List).map((item) => fromJsonT(item)).toList()
                as T
            : null,
        message: json['message'] ?? '',
      );
    } else {
      // Handle single T
      return ApiResponse<T>(
        success: json['status'] == 'success',
        data: json['data'] != null && fromJsonT != null
            ? fromJsonT(json['data'])
            : null,
        message: json['message'] ?? '',
      );
    }
  }

  // Convert back to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'data': data != null ? toJsonT(data as T) : null,
      'message': message,
    };
  }

  factory ApiResponse.success(T? data, {String message = ''}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: false,
      message: message,
    );
  }
}
