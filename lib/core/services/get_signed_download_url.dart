import 'package:dio/dio.dart';

class SignedDownloadUrlService {
  SignedDownloadUrlService(this._dio);

  final Dio _dio;

  Future<String?> getSignedDownloadUrl(Map<String, dynamic> params) async {
    try {
      final rawKey = params['key'];
      final bucketKey = params['bucketKey'];
      final rawId = params['id'];
      final rawMongoId = params['_id'];

      final disposition = (params['disposition'] ?? 'attachment').toString();
      final filename = params['filename']?.toString();
      final contentType = params['contentType']?.toString();
      final expiresIn = params['expiresIn']?.toString();

      final id = rawId?.toString().trim().isNotEmpty == true
          ? rawId.toString().trim()
          : rawMongoId?.toString().trim().isNotEmpty == true
          ? rawMongoId.toString().trim()
          : null;

      final key = rawKey?.toString().trim().isNotEmpty == true
          ? rawKey.toString().trim()
          : bucketKey?.toString().trim().isNotEmpty == true
          ? bucketKey.toString().trim()
          : null;

      if ((key == null || key.isEmpty) && (id == null || id.isEmpty)) {
        throw Exception('Debes proporcionar key o id.');
      }

      if (id != null && id.isNotEmpty) {
        final response = await _dio.get(
          '/api/s3/download/${Uri.encodeComponent(id)}',
          queryParameters: {
            'disposition': disposition,
            if (filename != null && filename.isNotEmpty) 'filename': filename,
            if (contentType != null && contentType.isNotEmpty)
              'contentType': contentType,
            if (expiresIn != null && expiresIn.isNotEmpty)
              'expiresIn': expiresIn,
          },
        );

        return response.data?['data']?['url']?.toString();
      }

      final response = await _dio.get(
        '/api/s3/download',
        queryParameters: {
          'key': key,
          'disposition': disposition,
          if (filename != null && filename.isNotEmpty) 'filename': filename,
          if (contentType != null && contentType.isNotEmpty)
            'contentType': contentType,
          if (expiresIn != null && expiresIn.isNotEmpty) 'expiresIn': expiresIn,
        },
      );

      return response.data?['data']?['url']?.toString();
    } catch (e) {
      rethrow;
    }
  }
}
