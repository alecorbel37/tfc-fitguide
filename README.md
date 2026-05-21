# FitGuide

Aplicación móvil de nutrición y fitness desarrollada como Trabajo de Final de Ciclo (TFC) del Grado Superior de Desarrollo de Aplicaciones Multiplataforma (DAM) en el IES Serra Perenxisa, Valencia.

## ¿Qué es FitGuide?

FitGuide es una aplicación diseñada para facilitar el control de la nutrición y el entrenamiento físico de forma sencilla. Permite llevar un registro diario de las comidas, realizar un seguimiento de rutinas de entrenamiento adaptadas a diferentes objetivos y consultar dudas en tiempo real con un nutricionista o entrenador personal a través del chat integrado. Todo unificado en una sola herramienta, con una interfaz limpia y soporte para modo oscuro.

## Características principales

* Registro de comidas buscando cualquier alimento en una base de datos de más de 3 millones de productos.
* Visualización en tiempo real de las calorías consumidas y las calorías restantes para cumplir el objetivo diario.
* Rutinas de entrenamiento adaptadas a objetivos específicos: perder peso, ganar masa muscular o mejorar la salud.
* Chat en tiempo real con asesores de nutrición y entrenamiento personal.
* Cálculo automático del IMC (Índice de Masa Corporal) a partir de los datos del usuario.
* Registro de días consecutivos activos (rachas) para fomentar el hábito diario.
* Soporte nativo para modo oscuro.
* Acceso multiplataforma desde dispositivos Android y navegadores web.

## Tecnologías utilizadas

* **Flutter y Dart:** Desarrollo de la aplicación multiplataforma.
* **Firebase Authentication:** Gestión del registro e inicio de sesión de usuarios (email/contraseña y Google).
* **Cloud Firestore:** Base de datos NoSQL para el almacenamiento de datos y mensajería en tiempo real.
* **Firebase Hosting:** Despliegue de la versión de la aplicación para entorno web.
* **API de Open Food Facts:** Búsqueda e información nutricional de alimentos.
* **Provider:** Gestión del estado de la aplicación.
* **Poppins:** Tipografía principal del sistema.

## Requisitos del sistema

Para compilar y ejecutar el proyecto en un entorno de desarrollo local, se requiere:

* Flutter SDK 3.x o superior.
* Dart 3.x o superior.
* Android Studio (con emulador configurado) o un dispositivo físico Android.
* Una cuenta de Firebase con un proyecto configurado.

## Instalación y configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com/alecorbel37/tfc-fitguide.git
cd tfc-fitguide
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar Firebase
Los archivos `google-services.json` y `firebase_options.dart` no están incluidos en el repositorio por seguridad. Para ejecutar el proyecto, es necesario:
1. Crear un proyecto en Firebase Console.
2. Activar Authentication con los proveedores de correo/contraseña y Google.
3. Configurar la base de datos de Cloud Firestore.
4. Descargar el archivo `google-services.json` y ubicarlo en la carpeta `android/app/`.

### 4. Ejecutar la aplicación

**En Android:**
```bash
flutter run
```

**En Chrome (Web):**
```bash
flutter run -d chrome --no-dds
```

## Despliegue y descargas

* **Versión Web:** La versión desplegada está disponible en [fitguide-tfc.web.app](https://fitguide-tfc.web.app).
* **Versión Android:** El archivo ejecutable APK se puede descargar desde la sección de releases de este repositorio.

## Estructura del proyecto

La arquitectura de directorios dentro de la carpeta `lib/` está organizada de la siguiente manera:

```text
lib/
├── main.dart
├── constants/
│   ├── app_colors.dart
│   └── app_theme.dart
└── src/
    ├── models/
    ├── services/
    ├── screens/
    │   ├── auth/
    │   ├── home/
    │   ├── nutrition/
    │   ├── training/
    │   ├── chat/
    │   └── profile/
    ├── widgets/
    ├── providers/
    └── routes/
```

## Funcionalidades futuras

* Registro de entrenamientos completados con estimación de calorías quemadas.
* Escáner de códigos de barras para añadir alimentos rápidamente.
* Gráficos interactivos de evolución histórica del peso.
* Posibilidad de modificar el objetivo físico directamente desde la configuración de perfil.
* Cálculo integrado del gasto calórico basal (Tasa Metabólica Basal).
* Modelo freemium completo con pasarela de pagos integrada y anuncios.
* Panel web/móvil exclusivo para los expertos (nutricionistas y entrenadores) para responder a los usuarios.

## Autor

Alexandra Cortés Beltrán — 2º DAM, IES Serra Perenxisa, Valencia, 2026.
