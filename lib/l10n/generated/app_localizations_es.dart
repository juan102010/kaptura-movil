// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kaptura';

  @override
  String get workOrders => 'Órdenes de trabajo';

  @override
  String get home => 'Inicio';

  @override
  String get inventory => 'Inventario';

  @override
  String get settings => 'Ajustes';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get signInToContinue => 'Inicia sesión para continuar.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'tu@correo.com';

  @override
  String get enterEmail => 'Ingresa tu correo';

  @override
  String get invalidEmail => 'Correo inválido';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get passwordTooShort => 'La contraseña es muy corta';

  @override
  String get rememberMe => 'Recordarme';

  @override
  String get login => 'Ingresar';

  @override
  String get biometricLogin => 'Ingresar con huella';

  @override
  String get biometricReason => 'Confirma tu identidad para iniciar sesión';

  @override
  String get noSavedCredentials => 'No hay credenciales guardadas.';

  @override
  String biometricFailed(String error) {
    return 'No se pudo usar la autenticación biométrica: $error';
  }

  @override
  String get validatingAccess => 'Validando acceso...';

  @override
  String get error => 'Error';

  @override
  String get unauthorizedError => 'No autorizado. Inicia sesión nuevamente.';

  @override
  String get serverError => 'Error del servidor. Intenta más tarde.';

  @override
  String get timeoutError =>
      'Se agotó el tiempo de espera. Revisa tu conexión.';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado.';

  @override
  String get missingUserIdError =>
      'No se encontró el ID del usuario en la sesión.';

  @override
  String get userNotLoadedError => 'El usuario todavía no se ha cargado.';

  @override
  String get remoteUpdateCacheError =>
      'No se pudieron actualizar los datos remotos. Mostrando datos en caché.';

  @override
  String projectsLoadError(String error) {
    return 'No se pudieron cargar los proyectos: $error';
  }

  @override
  String projectsRefreshError(String error) {
    return 'No se pudieron actualizar los proyectos: $error';
  }

  @override
  String get historyUpdated => 'Historial actualizado correctamente.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get accept => 'Aceptar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get ok => 'Aceptar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saving => 'Guardando...';

  @override
  String get noData => 'Sin datos';

  @override
  String get unnamed => '(Sin nombre)';

  @override
  String get idLabel => 'ID';

  @override
  String get type => 'Tipo';

  @override
  String get name => 'Nombre';

  @override
  String get status => 'Estado';

  @override
  String get date => 'Fecha';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get ongoing => 'En curso';

  @override
  String get general => 'General';

  @override
  String get time => 'Tiempo';

  @override
  String get technician => 'Técnico';

  @override
  String get location => 'Ubicación';

  @override
  String get parts => 'Partes';

  @override
  String get evidence => 'Evidencias';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get cache => 'Caché';

  @override
  String get customers => 'Clientes';

  @override
  String get customerDetail => 'Detalle del cliente';

  @override
  String customerNotFound(String id) {
    return 'No se encontró el cliente con ID: $id';
  }

  @override
  String get showingCache =>
      'Mostrando caché (sin conexión o cargando datos remotos)';

  @override
  String get customerType => 'Tipo de cliente';

  @override
  String get phone => 'Teléfono';

  @override
  String get mobile => 'Celular';

  @override
  String get city => 'Ciudad';

  @override
  String get state => 'Departamento/estado';

  @override
  String get country => 'País';

  @override
  String get street => 'Dirección';

  @override
  String get cameraMessage => 'Mensaje de cámara';

  @override
  String get firstCameraImageUrl => 'URL de la primera imagen de cámara';

  @override
  String get offlineDetailNotice =>
      'Este detalle sigue disponible sin conexión porque proviene del caché local.';

  @override
  String get projects => 'Proyectos';

  @override
  String get projectDetail => 'Detalle del proyecto';

  @override
  String projectNotFound(String id) {
    return 'No se encontró el proyecto con ID: $id';
  }

  @override
  String get showingLocalCache => 'Mostrando datos desde el caché local.';

  @override
  String get noProjects => 'No hay proyectos disponibles.';

  @override
  String get projectName => 'Nombre del proyecto';

  @override
  String get createdAt => 'Fecha de creación';

  @override
  String get customerCode => 'Código de cliente';

  @override
  String get mainInformation => 'Información principal';

  @override
  String get nestedFields => 'Campos anidados';

  @override
  String get firstWorkOrderId => 'ID de la primera orden de trabajo';

  @override
  String get firstWorkOrderName => 'Nombre de la primera orden de trabajo';

  @override
  String get rawPreview => 'Vista de datos sin procesar';

  @override
  String get users => 'Usuarios';

  @override
  String get userDetail => 'Detalle del usuario';

  @override
  String userNotFound(String id) {
    return 'No se encontró el usuario con ID: $id';
  }

  @override
  String get noUsers => 'No se encontraron usuarios';

  @override
  String get identification => 'Identificación';

  @override
  String get role => 'Rol';

  @override
  String get scheme => 'Esquema';

  @override
  String get companyId => 'ID de la empresa';

  @override
  String get activeCluster => 'Clúster activo';

  @override
  String get allowedClusterKeys => 'Claves de clúster permitidas';

  @override
  String get entryExitHistory => 'Historial de entradas y salidas';

  @override
  String get fullJson => 'JSON completo';

  @override
  String get selectOrScanInventory =>
      'Selecciona un artículo o escanea un código QR';

  @override
  String get inventoryInstructions =>
      'El código QR debe contener el _id del inventario. También puedes escoger el artículo directamente desde la lista.';

  @override
  String get inventoryItem => 'Artículo de inventario';

  @override
  String get openCamera => 'Abrir cámara';

  @override
  String get inventoryLoadError => 'No se pudo cargar el inventario';

  @override
  String get noItems => 'Sin artículos';

  @override
  String get noInventoryAvailable =>
      'No hay inventarios disponibles por ahora.';

  @override
  String get quickView => 'Vista rápida';

  @override
  String inventoryItemNotFound(String source) {
    return 'El artículo leído desde $source no existe en el inventario.';
  }

  @override
  String inventorySummary(int active, int total) {
    return '$active activos de $total registrados';
  }

  @override
  String inventoryQuantities(int defaultQty, int stockMin) {
    return 'Predeterminada: $defaultQty | Existencia mínima: $stockMin';
  }

  @override
  String get inventoryDetail => 'Detalle del inventario';

  @override
  String get requestedItemNotFound => 'No se encontró el artículo solicitado.';

  @override
  String get selectedItem => 'Artículo seleccionado';

  @override
  String get stockAdjustment => 'Ajuste de existencias';

  @override
  String get stockAdjustmentHelp =>
      'Usa los controles para ajustar las cantidades o toca el número para escribir un valor.';

  @override
  String get defaultQuantity => 'Cantidad predeterminada';

  @override
  String get defaultQuantityHelp => 'Cantidad aplicada por defecto';

  @override
  String get minimumStock => 'Existencia mínima';

  @override
  String get minimumStockHelp => 'Nivel mínimo recomendado';

  @override
  String get invalidNumericValues => 'Ingresa valores numéricos válidos.';

  @override
  String get inventoryUpdated => 'Inventario actualizado correctamente.';

  @override
  String get scanQr => 'Escanear código QR';

  @override
  String get scanQrHelp =>
      'Apunta al código QR del artículo. El valor leído debe ser el _id del inventario.';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription =>
      'Elige el idioma que se usará en toda la aplicación.';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get session => 'Sesión';

  @override
  String get sessionDescription => 'Administra tu sesión y accesos.';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutDescription =>
      'Esto borrará tu sesión local y te llevará a la pantalla de inicio de sesión.';

  @override
  String get confirmation => 'Confirmación';

  @override
  String get confirmLogout => '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get loggingOut => 'Cerrando sesión...';

  @override
  String get assignedToYou => 'Asignadas a ti';

  @override
  String get reviewWorkOrders =>
      'Revisa y abre los detalles de cada orden de trabajo.';

  @override
  String get selectDate => 'Selecciona una fecha';

  @override
  String get noWorkOrders => 'Sin órdenes de trabajo';

  @override
  String get noWorkOrdersForDate =>
      'No hay órdenes de trabajo para la fecha seleccionada.';

  @override
  String get tapForDetails => 'Toca para ver detalles';

  @override
  String get workOrderNotFound =>
      'No se encontró la orden de trabajo en memoria/caché.';

  @override
  String get historyRecords => 'Historial (registros)';

  @override
  String get timeHistory => 'Historial de tiempo';

  @override
  String get noTimeRecords => 'No hay registros de tiempo.';

  @override
  String get record => 'Registro';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get customer => 'Cliente';

  @override
  String get project => 'Proyecto';

  @override
  String get assignedTo => 'Asignado a';

  @override
  String get classLabel => 'Clase';

  @override
  String get customerName => 'Nombre del cliente';

  @override
  String get firstName => 'Primer nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get mainEmail => 'Correo principal';

  @override
  String get mainPhone => 'Teléfono principal';

  @override
  String get address => 'Dirección';

  @override
  String get generalInformation => 'Información general';

  @override
  String get showCredentialsNotes => 'Mostrar credenciales o notas';

  @override
  String get timeAndScheduling => 'Tiempo y programación';

  @override
  String get technicalDetails => 'Detalles técnicos';

  @override
  String get technicalNotes => 'Notas técnicas';

  @override
  String get tasks => 'Tareas';

  @override
  String get toDo => 'Por hacer';

  @override
  String get clockStatus => 'Estado del registro horario';

  @override
  String get workplace => 'Lugar de trabajo';

  @override
  String get partsSpareParts => 'Partes / Repuestos';

  @override
  String get partsToDeliver => 'Partes a entregar';

  @override
  String get requestParts => 'Solicitar partes';

  @override
  String get usedParts => 'Partes usadas (hecho)';

  @override
  String get requiredParts => 'Pendiente / Partes necesarias';

  @override
  String get attachedImagesCount => 'Imágenes adjuntas (cantidad)';

  @override
  String get attachImages => 'Adjuntar imágenes';

  @override
  String get uploaderPending =>
      'Pendiente: cargador / cámara (se implementará después).';

  @override
  String get clientNotes => 'Notas del cliente';

  @override
  String get credentialsByCategory => 'Credenciales o notas por categoría';

  @override
  String get noCredentialsNotes => 'No hay credenciales o notas registradas.';

  @override
  String get notesCredentials => 'Notas / credenciales';

  @override
  String get notesHint => 'Escribe notas o credenciales...';

  @override
  String imagesCount(int count) {
    return 'Imágenes ($count)';
  }

  @override
  String get noCategoryContent =>
      'No hay contenido registrado en esta categoría.';

  @override
  String get imageLoadError => 'No se pudo cargar la imagen';

  @override
  String get noCustomerInformation => 'No hay información del cliente.';

  @override
  String get timer => 'Temporizador';

  @override
  String get activityInProgress => 'Actividad en curso';

  @override
  String elapsedTime(String time) {
    return 'Tiempo transcurrido: $time';
  }

  @override
  String get pauseActivity => 'Pausar actividad';

  @override
  String get shortBreak => 'Pausa corta / descanso';

  @override
  String get finish => 'Terminar';

  @override
  String get endOfDay => 'Fin de jornada';

  @override
  String get noRunningActivity => 'No hay actividad en curso actualmente.';

  @override
  String get startTravel => 'Iniciar desplazamiento';

  @override
  String get travelStart => 'Inicio de desplazamiento';

  @override
  String get startWork => 'Iniciar trabajo';

  @override
  String get activityStart => 'Inicio de actividad';

  @override
  String get activityStarted => 'Actividad iniciada correctamente.';

  @override
  String get activityFinished => 'Actividad terminada correctamente.';

  @override
  String get activityPaused => 'Actividad pausada correctamente.';

  @override
  String helloUser(String name) {
    return 'Hola, $name';
  }

  @override
  String get offlineModeActive =>
      'El modo sin conexión está activo. Algunos datos pueden venir del caché.';

  @override
  String get manageDay =>
      'Gestiona tu jornada y revisa tus órdenes de trabajo.';

  @override
  String get noInternetOffline => 'Sin internet. Trabajando sin conexión.';

  @override
  String get noInternetConnection => 'Sin conexión a internet';

  @override
  String get noTodayWorkOrders =>
      'No tienes órdenes de trabajo programadas para hoy.';

  @override
  String get locationDisabled => 'Ubicación desactivada';

  @override
  String get locationServiceError =>
      'La ubicación está desactivada. Actívala para continuar.';

  @override
  String get locationDisabledMessage =>
      'Para registrar la entrada o salida necesitas activar la ubicación. ¿Deseas abrir los ajustes de ubicación?';

  @override
  String get notNow => 'Ahora no';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get permissionRequired => 'Permiso requerido';

  @override
  String get locationPermissionMessage =>
      'El permiso de ubicación fue denegado permanentemente. Habilítalo en Ajustes para registrar la entrada o salida.';

  @override
  String get clockOutConfirmation => '¿Deseas registrar la salida?';

  @override
  String get clockIn => 'Registrar entrada';

  @override
  String get clockOut => 'Registrar salida';

  @override
  String get yesClockOut => 'Sí, registrar salida';

  @override
  String get attention => 'Atención';

  @override
  String get lastClockIn => 'Último registro: entrada';

  @override
  String get lastClockOut => 'Último registro: salida';

  @override
  String get lastRecord => 'Último registro';

  @override
  String get user => 'Usuario';

  @override
  String get noInternet => 'Sin internet';

  @override
  String get activeWorkday => 'Jornada activa';

  @override
  String get noActiveWorkday => 'Sin jornada activa';

  @override
  String get offline => 'Sin conexión';

  @override
  String get noTime => 'Sin hora';

  @override
  String get clockInRecorded => 'Entrada registrada';

  @override
  String get clockOutRecorded => 'Salida registrada';

  @override
  String get connectForClock =>
      'Conéctate a internet para registrar la entrada o salida.';

  @override
  String get rememberClockOut => 'Recuerda registrar tu salida al finalizar.';

  @override
  String get clockInToStart => 'Registra tu entrada para iniciar la jornada.';

  @override
  String get todayWorkOrders => 'Órdenes de trabajo de hoy';

  @override
  String get reasonRequiredValidation => 'La razón es obligatoria.';

  @override
  String get reasonRequired => 'Razón requerida';

  @override
  String get additionalClockInReasonHint =>
      'Escribe la razón de la entrada adicional';
}
