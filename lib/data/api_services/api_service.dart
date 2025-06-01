import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final _baseUrl = "http://63.177.194.209:3001";
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await _dio.get(
        '$_baseUrl$endPoint',
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ GET request error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📄 Response: ${e.response?.data}");
      throw e;
    }
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      print("🚀 POST to $_baseUrl$endPoint");
      print("📦 Data: $data");
      var response = await _dio.post(
        '$_baseUrl$endPoint',
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ POST request error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📦 Sent Data: $data");
      print("📄 Response: ${e.response?.data}");
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
      print("❌ PATCH request error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📄 Response: ${e.response?.data}");
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
            contentType: MediaType('image', 'jpeg'),
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
      print("❌ POST multipart error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📄 Response: ${e.response?.data}");
      throw e;
    }
  }

  Future<Map<String, dynamic>> patchMultipart({
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
            contentType: MediaType('image', 'jpeg'),
          ),
      });

      final response = await _dio.patch(
        '$_baseUrl$endPoint',
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ PATCH multipart error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📄 Response: ${e.response?.data}");
      throw e;
    }
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl$endPoint',
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ DELETE request error: ${e.message}");
      print("📍 URL: $_baseUrl$endPoint");
      print("📄 Response: ${e.response?.data}");
      throw e;
    }
  }
}
