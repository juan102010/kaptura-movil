import 'dart:async';
import 'package:dio/dio.dart';
import '../../events/app_event.dart';

class AppEventBus {
  final _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  void emit(AppEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}

class SessionExpiredInterceptor extends Interceptor {
  SessionExpiredInterceptor(this._eventBus);

  final AppEventBus _eventBus;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _eventBus.emit(AppEvent.sessionExpired);
    }
    handler.next(err);
  }
}
