import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String localizeError(String message) {
    final clean = message.replaceFirst('Exception: ', '').trim();

    if (clean.contains('No autorizado')) return l10n.unauthorizedError;
    if (clean.contains('Error del servidor')) return l10n.serverError;
    if (clean.contains('Tiempo de espera agotado')) return l10n.timeoutError;
    if (clean == 'Error inesperado.') return l10n.unexpectedError;
    if (clean.contains('No se encontró userId')) return l10n.missingUserIdError;
    if (clean.contains('Usuario no cargado')) return l10n.userNotLoadedError;
    if (clean.contains('No hay credenciales guardadas')) {
      return l10n.noSavedCredentials;
    }
    if (clean.startsWith('No se pudo usar biometria:')) {
      return l10n.biometricFailed(clean.split(':').skip(1).join(':').trim());
    }
    if (clean.contains('Mostrando datos en cache') ||
        clean.contains('Mostrando cache local')) {
      return l10n.remoteUpdateCacheError;
    }
    if (clean.startsWith('No se pudieron cargar los proyectos:')) {
      return l10n.projectsLoadError(clean.split(':').skip(1).join(':').trim());
    }
    if (clean.startsWith('No se pudo refrescar projects:')) {
      return l10n.projectsRefreshError(
        clean.split(':').skip(1).join(':').trim(),
      );
    }
    if (clean.contains('Historial actualizado correctamente')) {
      return l10n.historyUpdated;
    }
    if (clean.contains('Ubicación desactivada')) {
      return l10n.locationServiceError;
    }

    return clean;
  }

  String localizeWorkActivity(String activity) {
    switch (activity.trim()) {
      case 'Pausa corta / descanso':
        return l10n.shortBreak;
      case 'Fin de jornada':
        return l10n.endOfDay;
      case 'Inicio de desplazamiento':
        return l10n.travelStart;
      case 'Inicio de actividad':
        return l10n.activityStart;
      default:
        return activity;
    }
  }
}
