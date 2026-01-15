import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/counsellor.dart';
import 'api_url.dart';

class CounsellorService {
  final Dio _dio;

  CounsellorService({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
    return dio;
  }

  Future<Counsellor?> createCounsellor({
    required Counsellor counsellor,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    try {
      FormData formData = FormData();
      // Add simple fields
      formData.fields
        ..add(MapEntry('full_name', counsellor.name))
        ..add(MapEntry('phone_no', counsellor.phoneNumber))
        ..add(MapEntry('email', counsellor.email))
        ..add(MapEntry('address', counsellor.address ?? ''))
        ..add(MapEntry('qualification', counsellor.qualification ?? ''))
        ..add(MapEntry('experience', counsellor.experienceYears.toString()))
        ..add(MapEntry('password', counsellor.password))
        ..add(
          MapEntry(
            'alternative_phone_no',
            counsellor.alternatePhoneNumber ?? '',
          ),
        )
        ..add(
          MapEntry(
            'per_courses_commission',
            counsellor.perCoursesCommission != null
                ? jsonEncode(counsellor.perCoursesCommission)
                : '',
          ),
        );
      // banking and payment fields
      formData.fields
        ..add(MapEntry('bank_account_no', counsellor.bankAccountNo ?? ''))
        ..add(MapEntry('bank_account_name', counsellor.bankAccountName ?? ''))
        ..add(MapEntry('branch_name', counsellor.branchName ?? ''))
        ..add(MapEntry('ifsc_code', counsellor.ifscCode ?? ''))
        ..add(MapEntry('upi_id', counsellor.upiId ?? ''));

      if (profilePhotoBytes != null && profilePhotoFilename != null) {
        formData.files.add(
          MapEntry(
            'profile_photo',
            MultipartFile.fromBytes(
              profilePhotoBytes,
              filename: profilePhotoFilename,
            ),
          ),
        );
      }

      final resp = await _dio.post(ApiUrl.createCounsellor, data: formData);
      return Counsellor.fromJson(resp.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    }
  }

  Future<List<Counsellor>> getAllCounsellors() async {
    final resp = await _dio.get(ApiUrl.getAllCounsellors);
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => Counsellor.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Counsellor> getCounsellorById(String id) async {
    final resp = await _dio.get(ApiUrl.getCounsellorById(id));
    return Counsellor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Counsellor> updateCounsellor({
    required String id,
    Map<String, dynamic>? fields,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    FormData formData = FormData();
    if (fields != null) {
      fields.forEach((k, v) {
        if (v != null) {
          if (k == 'per_courses_commission' && v is Map) {
            formData.fields.add(MapEntry(k, jsonEncode(v)));
          } else {
            formData.fields.add(MapEntry(k, v.toString()));
          }
        }
      });
    }
    if (profilePhotoBytes != null && profilePhotoFilename != null) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          MultipartFile.fromBytes(
            profilePhotoBytes,
            filename: profilePhotoFilename,
          ),
        ),
      );
    }
    final resp = await _dio.put(ApiUrl.updateCounsellor(id), data: formData);
    return Counsellor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteCounsellor(String id) async {
    await _dio.delete(ApiUrl.deleteCounsellor(id));
  }

  Future<int> bulkDeleteCounsellors(List<String> ids) async {
    final resp = await _dio.delete(
      ApiUrl.bulkDeleteCounsellors,
      queryParameters: {'ids': ids},
    );
    if (resp.data is Map && resp.data['detail'] != null) {
      // Flutter doesn't need count, but backend returns message
    }
    return resp.statusCode == 200 ? 1 : 0;
  }
}
