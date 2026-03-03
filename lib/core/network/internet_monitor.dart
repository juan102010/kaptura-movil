import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'internet_status.dart';

/// Monitorea el estado real de internet:
/// - connectivity_plus: detecta tipo de conexión (wifi/mobile/none)
/// - internet_connection_checker: valida salida real a internet
class InternetMonitor {
  InternetMonitor({
    Connectivity? connectivity,
    InternetConnectionChecker? checker,
  }) : _connectivity = connectivity ?? Connectivity(),
       _checker = checker ?? InternetConnectionChecker();

  final Connectivity _connectivity;
  final InternetConnectionChecker _checker;

  final _controller = StreamController<InternetStatus>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  InternetStatus _last = InternetStatus.unknown;
  bool _started = false;

  Stream<InternetStatus> get stream => _controller.stream;

  /// Último estado conocido (útil si quieres consultar instantáneo)
  InternetStatus get lastStatus => _last;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    // 1) Emitir "unknown" de inmediato para que UI no muestre offline falso
    _emit(InternetStatus.unknown, force: true);

    // 2) Emitir estado inicial real
    await _emitCurrent(force: true);

    // 3) Escuchar cambios de conectividad
    await _sub?.cancel();
    _sub = _connectivity.onConnectivityChanged.listen((_) async {
      await _emitCurrent();
    });
  }

  void _emit(InternetStatus next, {bool force = false}) {
    if (force || next != _last) {
      _last = next;
      _controller.add(next);
    }
  }

  Future<void> _emitCurrent({bool force = false}) async {
    // Si no hay conectividad, es offline directo
    final results = await _connectivity.checkConnectivity();
    final hasAnyNetwork = results.any((r) => r != ConnectivityResult.none);

    if (!hasAnyNetwork) {
      _emit(InternetStatus.offline, force: force);
      return;
    }

    // Hay red, pero validamos internet real
    final hasInternet = await _checker.hasConnection;
    _emit(
      hasInternet ? InternetStatus.online : InternetStatus.offline,
      force: force,
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }
}
