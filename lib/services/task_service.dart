import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/models/task.dart';

class TaskService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Obtener todas las tareas del usuario y las compartidas
  Future<List<Task>> getTasks() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final response = await _supabase
          .from('tasks')
          .select()
          .or('user_id.eq.$userId,is_shared.eq.true')
          .order('created_at', ascending: false);

      return response.map<Task>((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  // Obtener el email de un usuario por su ID
  Future<String?> getUserEmail(String userId) async {
    try {
      // Usar la función de Supabase para obtener información del usuario
      final response = await _supabase.rpc(
        'get_user_email',
        params: {'user_id_param': userId},
      );

      return response as String?;
    } catch (e) {
      // Si falla la función RPC, intentar obtener del perfil público
      try {
        final response = await _supabase
            .from('auth.users')
            .select('email')
            .eq('id', userId)
            .single();
        return response['email'] as String?;
      } catch (e2) {
        return null;
      }
    }
  }

  // Crear una nueva tarea
  Future<Task> createTask({
    required String title,
    File? imageFile,
    DateTime? customDate,
    bool isShared = false,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      String? imageUrl;

      // Subir imagen si existe
      if (imageFile != null) {
        final fileName =
            'task_${DateTime.now().millisecondsSinceEpoch}_$userId';

        await _supabase.storage.from('task-images').upload(fileName, imageFile);

        imageUrl = _supabase.storage.from('task-images').getPublicUrl(fileName);
      }

      final taskData = {
        'title': title,
        'user_id': userId,
        'is_completed': false,
        'image_url': imageUrl,
        'created_at': (customDate ?? DateTime.now()).toIso8601String(),
        'is_shared': isShared,
      };

      final response = await _supabase
          .from('tasks')
          .insert(taskData)
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear tarea: $e');
    }
  }

  // Actualizar el estado de una tarea
  Future<Task> updateTaskStatus(String taskId, bool isCompleted) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final response = await _supabase
          .from('tasks')
          .update({
            'is_completed': isCompleted,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', taskId)
          .eq('user_id', userId) // Solo el propietario puede actualizar
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  // Eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      // Primero obtener la tarea para verificar si tiene imagen
      final task = await _supabase
          .from('tasks')
          .select('image_url')
          .eq('id', taskId)
          .eq('user_id', userId)
          .single();

      // Eliminar imagen del storage si existe
      if (task['image_url'] != null) {
        final imageUrl = task['image_url'] as String;
        final fileName = imageUrl.split('/').last;

        try {
          await _supabase.storage.from('task-images').remove([fileName]);
        } catch (e) {
          // Continuar con la eliminación de la tarea aunque falle la imagen
        }
      }

      // Eliminar la tarea
      await _supabase
          .from('tasks')
          .delete()
          .eq('id', taskId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  // Obtener stream de tareas en tiempo real
  Stream<List<Task>> getTasksStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    return _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          // Filtrar localmente las tareas del usuario y las compartidas
          final filteredData = data.where((json) {
            return json['user_id'] == userId || json['is_shared'] == true;
          }).toList();

          return filteredData.map<Task>((json) => Task.fromJson(json)).toList();
        });
  }
}
