import 'dart:async';

import '../network/internet_monitor.dart';
import '../network/internet_status.dart';
import 'pending_update_store.dart';
import 'update_data_by_id_service.dart';

class PendingUpdateSyncService {
  PendingUpdateSyncService({
    required InternetMonitor internetMonitor,
    required PendingUpdateStore pendingStore,
    required UpdateDataByIdService updateService,
  }) : _internetMonitor = internetMonitor,
       _pendingStore = pendingStore,
       _updateService = updateService;

  final InternetMonitor _internetMonitor;
  final PendingUpdateStore _pendingStore;
  final UpdateDataByIdService _updateService;

  StreamSubscription<InternetStatus>? _subscription;
  Timer? _retryTimer;
  bool _syncing = false;

  void start() {
    if (_subscription != null) return;
    _subscription = _internetMonitor.stream.listen((status) {
      if (status == InternetStatus.online) {
        unawaited(syncPending());
      }
    });
    _retryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_internetMonitor.lastStatus == InternetStatus.online) {
        unawaited(syncPending());
      }
    });
    if (_internetMonitor.lastStatus == InternetStatus.online) {
      unawaited(syncPending());
    }
  }

  Future<void> syncPending() async {
    if (_syncing || _internetMonitor.lastStatus != InternetStatus.online) {
      return;
    }
    _syncing = true;
    try {
      final pending = await _pendingStore.getPending();
      for (final operation in pending) {
        if (_internetMonitor.lastStatus != InternetStatus.online) {
          break;
        }
        try {
          await _updateService.sendNow(
            tableName: operation.tableName,
            id: operation.recordId,
            data: operation.data,
            schemeOverride: operation.schemeOverride,
          );
          await _pendingStore.remove(operation.localId);
        } catch (error) {
          await _pendingStore.registerFailure(operation.localId, error);
          break;
        }
      }
    } finally {
      _syncing = false;
    }
  }

  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _subscription?.cancel();
  }
}
