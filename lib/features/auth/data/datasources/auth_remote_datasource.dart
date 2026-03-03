import 'package:dio/dio.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> sendOtpByEmail(String email);
  Future<Map<String, dynamic>> verifyOtpCode({
    required String email,
    required String code,
  });
  Future<Map<String, dynamic>> updatePassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dioLogin);

  final Dio _dioLogin;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final res = await _dioLogin.post(
      '/api/v1/users/auth/login',
      data: {'email': email, 'password': password},
    );

    return LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> sendOtpByEmail(String email) async {
    final res = await _dioLogin.post(
      '/api/v1/users/auth/send-otp',
      data: {'email': email},
    );
    return res.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> verifyOtpCode({
    required String email,
    required String code,
  }) async {
    final res = await _dioLogin.post(
      '/api/v1/users/auth/verify-otp',
      data: {'email': email, 'code': code},
    );
    return res.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updatePassword({
    required String email,
    required String password,
  }) async {
    final res = await _dioLogin.put(
      '/api/v1/users/auth/update-password',
      data: {'email': email, 'password': password},
    );
    return res.data as Map<String, dynamic>;
  }
}
