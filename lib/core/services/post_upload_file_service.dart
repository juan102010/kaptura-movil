import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../storage/secure_storage_service.dart';

class PostUploadFileService {
  PostUploadFileService({
    required Dio apiDio,
    required SecureStorageService secureStorage,
  }) : _apiDio = apiDio,
       _secureStorage = secureStorage;

  final Dio _apiDio;
  final SecureStorageService _secureStorage;

  Future<Map<String, dynamic>> upload(
    XFile file, {
    String? schema,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final resolvedSchema = schema?.trim().isNotEmpty == true
        ? schema!.trim()
        : (await _secureStorage.readSession())?.scheme ?? '';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
      'schema': resolvedSchema,
    });
    final response = await _apiDio.post<dynamic>(
      '/api/s3/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: onSendProgress,
    );

    if (response.data is! Map) {
      throw Exception('Respuesta invalida al subir la imagen.');
    }
    final body = Map<String, dynamic>.from(response.data as Map);
    if (body['status'] != true || body['data'] is! Map) {
      throw Exception(
        (body['message'] ?? 'Error al subir la imagen.').toString(),
      );
    }
    return Map<String, dynamic>.from(body['data'] as Map);
  }
}
