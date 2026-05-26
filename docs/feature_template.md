# Plantilla Oficial de Feature

Esta plantilla define la forma estandar para crear y mantener una feature dentro del proyecto.

## Estructura

```text
lib/features/<feature_name>/
  data/
    datasources/
      <feature_name>_remote_datasource.dart
      <feature_name>_local_datasource.dart
    models/
      <feature_entity>_model.dart
    repositories/
      <feature_name>_repository_impl.dart
  domain/
    entities/
      <feature_entity>_entity.dart
    repositories/
      <feature_name>_repository.dart
    usecases/
      get_<feature_name>_usecase.dart
  presentation/
    controllers/
      <feature_name>_controller.dart
      <feature_name>_state.dart
    providers/
      <feature_name>_providers.dart
    pages/
      <feature_name>_page.dart
      <feature_entity>_detail_page.dart
    widgets/
      <feature_name>_list_widget.dart
      <feature_name>_page_sections.dart
```

## Regla por capa

- `data/datasources`: habla con API, cache local o storage.
- `data/models`: transforma respuesta cruda a modelo tipado.
- `data/repositories`: conecta datasource con contrato de dominio.
- `domain/entities`: representa el dato que usa la app.
- `domain/repositories`: contrato abstracto.
- `domain/usecases`: reglas de negocio y casos de uso.
- `presentation/controllers`: `StateNotifier` y estado de pantalla.
- `presentation/providers`: instancia repositorios, use cases y controller.
- `presentation/pages`: pantallas completas.
- `presentation/widgets`: widgets solo de esa feature.

## Convenciones

- El nombre de carpeta debe ir en `snake_case`.
- Los archivos deben ir en `snake_case`.
- Las entidades deben terminar en `Entity`.
- Los modelos deben terminar en `Model`.
- Los repositorios concretos deben terminar en `RepositoryImpl`.
- Los controladores deben terminar en `Controller`.
- Los estados deben terminar en `State`.
- Los providers de la feature deben concentrarse en un solo archivo `presentation/providers/<feature_name>_providers.dart`.

## Regla de tipado

- No pasar `Map<String, dynamic>` desde `presentation` hacia arriba.
- Si la API es inestable, el `Model` puede conservar `rawData`.
- Si una pantalla necesita campos dinámicos, leerlos desde una entidad tipada con helpers o getters.
- Los payloads a backend pueden seguir siendo `Map<String, dynamic>` solo en borde de datasource o use case.

## Regla de UI

- Si un widget se repite entre features, moverlo a `lib/core/ui/widgets/`.
- Si una página supera unas 250-300 líneas, partir encabezado, cards o estados vacíos/error a `widgets/`.
- Mantener una sola estrategia de navegación: `GoRouter`.

## Mínimo viable de una feature nueva

Si la feature apenas lista datos, el mínimo recomendado es este:

```text
lib/features/<feature_name>/
  data/
    datasources/
      <feature_name>_remote_datasource.dart
    models/
      <feature_entity>_model.dart
    repositories/
      <feature_name>_repository_impl.dart
  domain/
    entities/
      <feature_entity>_entity.dart
    repositories/
      <feature_name>_repository.dart
    usecases/
      get_<feature_name>_usecase.dart
  presentation/
    controllers/
      <feature_name>_controller.dart
      <feature_name>_state.dart
    providers/
      <feature_name>_providers.dart
    pages/
      <feature_name>_page.dart
```

## Esqueleto recomendado

### Entidad

```dart
class SampleEntity {
  const SampleEntity({
    required this.id,
    required this.name,
    required this.rawData,
  });

  final String id;
  final String name;
  final Map<String, dynamic> rawData;

  bool matchesId(String otherId) => id == otherId.trim();
}
```

### Modelo

```dart
class SampleModel extends SampleEntity {
  const SampleModel({
    required super.id,
    required super.name,
    required super.rawData,
  });

  factory SampleModel.fromMap(Map<String, dynamic> map) {
    return SampleModel(
      id: (map['_id'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
      rawData: Map<String, dynamic>.from(map),
    );
  }
}
```

### Estado

```dart
class SampleState {
  const SampleState({
    required this.items,
    required this.isLoading,
    required this.errorMessage,
  });

  final List<SampleEntity> items;
  final bool isLoading;
  final String? errorMessage;

  factory SampleState.initial() {
    return const SampleState(
      items: <SampleEntity>[],
      isLoading: false,
      errorMessage: null,
    );
  }

  SampleState copyWith({
    List<SampleEntity>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SampleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
```

### Controller

```dart
class SampleController extends StateNotifier<SampleState> {
  SampleController({
    required GetSamplesUsecase getSamplesUsecase,
  }) : _getSamplesUsecase = getSamplesUsecase,
       super(SampleState.initial());

  final GetSamplesUsecase _getSamplesUsecase;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final items = await _getSamplesUsecase();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
```

### Providers

```dart
final sampleRemoteDataSourceProvider = Provider<SampleRemoteDataSource>((ref) {
  final dioClients = ref.watch(dioClientsProvider);
  return SampleRemoteDataSourceImpl(apiDio: dioClients.api);
});

final sampleRepositoryProvider = Provider<SampleRepository>((ref) {
  return SampleRepositoryImpl(
    ref.read(sampleRemoteDataSourceProvider),
  );
});

final getSamplesUsecaseProvider = Provider<GetSamplesUsecase>((ref) {
  return GetSamplesUsecase(ref.read(sampleRepositoryProvider));
});

final sampleControllerProvider =
    StateNotifierProvider<SampleController, SampleState>((ref) {
      return SampleController(
        getSamplesUsecase: ref.read(getSamplesUsecaseProvider),
      );
    });
```

## Checklist antes de cerrar una feature

- Tiene `entity` y `model` tipados.
- No expone `Map<String, dynamic>` a `page` o `widget`.
- Los providers viven fuera del controller.
- La navegación usa `GoRouter`.
- La UI repetida ya fue evaluada para `core/ui/widgets`.
- `flutter analyze` queda limpio.
- Si aplica, hay test mínimo del flujo principal.
