import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Carga variables de entorno
  await dotenv.load(fileName: '.env');

  // ✅ Inicializar intl para formatos de fecha en español Colombia
  await initializeDateFormatting('es_CO', null);

  runApp(const ProviderScope(child: AppRoot()));
}
