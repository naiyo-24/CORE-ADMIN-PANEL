import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/admin.dart';
import 'api_url.dart';

class AuthServices {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(PrettyDioLogger());

  static Future<Admin> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiUrl.adminLogin,
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200 && response.data != null) {
      final adminJson = response.data['admin'];
      return Admin.fromJson(adminJson);
    } else {
      throw Exception(response.data['detail'] ?? 'Login failed');
    }
  }
}
