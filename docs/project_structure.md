# Estructura Estandar del Proyecto

Esta es la estructura objetivo para la migracion gradual del proyecto.

## Regla general

- `app/`: bootstrap de aplicacion, router, theme y dependencias globales.
- `core/`: piezas compartidas entre features.
- `features/<feature>/`: cada feature encapsula sus capas.

## App

- `lib/app/app.dart`: raiz de la app.
- `lib/app/di/`: providers globales y servicios compartidos.
- `lib/app/router/`: definicion de rutas y shell navigation.
- `lib/app/theme/`: theme global.

## Core

- `lib/core/constants/`: claves y constantes compartidas.
- `lib/core/errors/`: fallos y mapeadores de error.
- `lib/core/events/`: eventos globales.
- `lib/core/local_db/`: Drift, tablas y provider de base de datos.
- `lib/core/network/`: clientes Dio, interceptores y conectividad.
- `lib/core/services/`: servicios de plataforma y helpers de integracion.
- `lib/core/storage/`: almacenamiento seguro y session storage.
- `lib/core/ui/`: widgets y utilidades visuales compartidas.

## Features

Cada feature debe mantener esta forma:

- `data/`
- `domain/`
- `presentation/`

### Data

- `datasources/`: acceso remoto/local.
- `models/`: modelos de transporte.
- `repositories/`: implementaciones concretas.

### Domain

- `entities/`: entidades del dominio.
- `repositories/`: contratos.
- `usecases/`: reglas de negocio.

### Presentation

- `controllers/`: estado y controladores de Riverpod.
- `providers/`: wiring de providers y dependencias de presentacion.
- `pages/`: pantallas.
- `widgets/`: widgets propios de la feature.

## Reglas de migracion

- No declarar providers dentro de archivos de controller si pueden vivir en `presentation/providers/`.
- Preferir widgets compartidos en `core/ui/widgets/` para bloques repetidos.
- Evitar archivos placeholder vacios.
- Reducir progresivamente el uso de `Map<String, dynamic>` a favor de modelos tipados.
- Mantener una sola estrategia de navegacion por feature, priorizando `GoRouter`.

## Plantilla oficial

- Usar [feature_template.md](/C:/proyect/kaptura-front/kaptura-movil/flutter_kaptura/docs/feature_template.md) como base para cualquier feature nueva o reescritura de una existente.
