import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final controller = AuthController(
      loginUseCase: ref.read(loginUseCaseProvider),
      secureStorage: ref.read(secureStorageServiceProvider),
      biometricService: ref.read(biometricServiceProvider),
    );

    Future.microtask(controller.bootstrap);
    ref.onDispose(controller.disposeController);

    return controller;
  },
);
