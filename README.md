# To-Do List App con Flutter y Supabase

Una aplicación completa de lista de tareas con autenticación, gestión de imágenes y tareas compartidas.

## Configuración del Proyecto

### 1. Requisitos Previos
- Flutter SDK instalado
- Cuenta en Supabase
- Android Studio o VS Code

### 2. Configurar Supabase
1. Ve a [supabase.com](https://supabase.com) y crea un nuevo proyecto
2. Ve a Settings > API para obtener:
   - Project URL
   - Anon key
3. Actualiza `lib/main.dart` con tus credenciales:
```dart
await Supabase.initialize(
  url: 'TU_PROJECT_URL',
  anonKey: 'TU_ANON_KEY',
);
```

### 3. Configurar Base de Datos
1. Ve al editor SQL en tu dashboard de Supabase
2. Ejecuta el contenido completo del archivo `database_setup.sql`
3. Esto creará:
   - Tabla `tasks`
   - Políticas de seguridad RLS
   - Bucket de almacenamiento para imágenes
   - Índices y triggers

### 4. Instalar Dependencias
```bash
cd to_do_list
flutter pub get
```

### 5. Configurar Permisos

#### Android (`android/app/src/main/AndroidManifest.xml`)
Agregar antes de `</application>`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

#### iOS (`ios/Runner/Info.plist`)
Agregar antes de `</dict>`:
```xml
<key>NSCameraUsageDescription</key>
<string>Esta app necesita acceso a la cámara para tomar fotos de las tareas</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Esta app necesita acceso a la galería para seleccionar fotos</string>
```

### 6. Agregar Capturas de Pantalla (Opcional)
Para completar la documentación del proyecto, puedes agregar capturas de pantalla en la carpeta `screenshots/`:

1. **Capturas de la aplicación**: Usa un emulador o dispositivo real para capturar las pantallas
2. **Capturas de Supabase**: Toma screenshots del dashboard mostrando:
   - Tabla de datos
   - Storage con imágenes
   - Políticas RLS
   - Logs de actividad
3. **Formatos recomendados**: PNG o JPG, resolución clara (recomendado: 1080x1920 para móvil)

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada, configuración Supabase
├── login_page.dart          # Autenticación (login/registro)
├── tasks_page.dart          # Lista principal de tareas
├── models/
│   └── task.dart           # Modelo de datos Task
├── pages/
│   └── add_task_page.dart  # Formulario para crear tareas
└── services/
    └── task_service.dart   # Servicio para operaciones CRUD
```

## Funcionalidades Detalladas

### Autenticación
- Registro e inicio de sesión con email/contraseña
- Validación de campos
- Manejo de errores de autenticación
- Navegación automática basada en estado de sesión

### Gestión de Tareas
- **Vista principal**: Lista de todas las tareas
- **Filtros**: Todas, Pendientes, Completadas
- **Acciones por tarea**:
  - Marcar como completada (checkbox)
  - Eliminar (solo propietario)
  - Ver información completa

### Creación de Tareas
- **Título**: Campo de texto obligatorio
- **Imagen**: 
  - Seleccionar desde galería
  - Tomar foto con cámara
  - Vista previa antes de guardar
- **Fecha/Hora**:
  - Por defecto: momento actual
  - Opción de seleccionar fecha personalizada
- **Compartir**: Toggle para hacer la tarea visible públicamente

### Seguridad
- Row Level Security (RLS) habilitado
- Usuarios solo pueden:
  - Ver sus propias tareas y las compartidas
  - Crear, actualizar y eliminar sus propias tareas
- Almacenamiento de imágenes con políticas de acceso

## Uso de la Aplicación

1. **Registro/Login**: Crear cuenta o iniciar sesión
2. **Ver tareas**: Lista automática de tareas propias y compartidas
3. **Crear tarea**: 
   - Tap en botón flotante (+)
   - Llenar título (obligatorio)
   - Opcional: agregar imagen, cambiar fecha, marcar como compartida
4. **Gestionar tareas**:
   - Tap en checkbox para completar/descompletar
   - Menú (⋮) para eliminar (solo propias tareas)
5. **Filtrar**: Usar botón de filtro en la barra superior

## Tecnologías Utilizadas

- **Flutter**: Framework UI multiplataforma
- **Supabase**: Backend-as-a-Service (autenticación, base de datos, storage)
- **image_picker**: Selección de imágenes de galería/cámara
- **permission_handler**: Gestión de permisos del dispositivo
- **intl**: Formateo de fechas y internacionalización

## Capturas de Pantalla

### Inicio de Sesión
*Evidencia del sistema de autenticación con registro e inicio de sesión*

![Pantalla de Login](screenshots/login_screen.png)


### Lista de Tareas
*Vista principal de la aplicación mostrando las tareas del usuario*

![Lista de Tareas - Vista General](screenshots/tasks_list.png)
*Lista completa de tareas con filtros y opciones de gestión*

### Formulario para Agregar Nuevas Tareas
*Proceso completo de creación de una nueva tarea*

![Formulario de Nueva Tarea](screenshots/add_task_form.png)
*Formulario con título, imagen, fecha y opciones de compartir*

### Transacciones con Supabase
*Evidencia de las operaciones realizadas con la base de datos*

![Dashboard Supabase - Tabla Tasks](screenshots/supabase_table.png)
*Vista de la tabla 'tasks' en el dashboard de Supabase*

# Flutter_ToDoList
# Flutter_ToDoList
