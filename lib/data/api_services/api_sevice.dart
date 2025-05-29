import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // ✅ استيراد مهم

class ApiService {
  final _baseUrl = "http://63.177.194.209:3001";
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    try {
      var response = await _dio.get('$_baseUrl$endPoint');
      return response.data;
    } on DioException catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await _dio.post(
        '$_baseUrl$endPoint',
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> patch({
    required String endPoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await _dio.patch(
        '$_baseUrl$endPoint',
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> postMultipart({
    required String endPoint,
    required Map<String, dynamic> data,
    File? file,
    String fileField = 'image',
    Map<String, String>? headers,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...data,
        if (file != null)
          fileField: await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'), // ✅ مهم جداً
          ),
      });

      final response = await _dio.post(
        '$_baseUrl$endPoint',
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw e;
    }
  }
}
