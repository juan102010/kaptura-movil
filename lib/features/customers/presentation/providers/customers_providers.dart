import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/local_db/app_database.dart';
import '../../../../core/local_db/app_database_provider.dart';

import '../../../../app/di/providers.dart'; // ejemplo

import '../../data/datasources/customers_local_datasource.dart';
import '../../data/datasources/customers_remote_datasource.dart';
import '../../data/repositories/customers_repository_impl.dart';
import '../../domain/repositories/customers_repository.dart';
import '../../domain/usecases/get_customers_usecase.dart';

final customersRemoteDataSourceProvider = Provider<CustomersRemoteDataSource>((
  ref,
) {
  final apiDio = ref.watch(
    dioClientsProvider,
  ); // 👈 cambia si tu nombre es otro
  return CustomersRemoteDataSourceImpl(apiDio: apiDio.api);
});

final customersLocalDataSourceProvider = Provider<CustomersLocalDataSource>((
  ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return CustomersLocalDataSourceImpl(db);
});

final customersRepositoryProvider = Provider<CustomersRepository>((ref) {
  final remote = ref.watch(customersRemoteDataSourceProvider);
  final local = ref.watch(customersLocalDataSourceProvider);
  return CustomersRepositoryImpl(remote, local);
});
final getCustomersUsecaseProvider = Provider<GetCustomersUsecase>((ref) {
  final repo = ref.watch(customersRepositoryProvider);
  return GetCustomersUsecase(repo);
});
