import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list/pages/login_page.dart';
import 'package:to_do_list/pages/tasks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'your-supabase-url-here', // Reemplaza con tu URL de Supabase
      anonKey:
          'your-anon-key-here', // Reemplaza con tu clave anónima de Supabase
      debug: true, // Habilitar debug para ver más información
    );
  } catch (e) {
    return;
  }
  // esto es un comentario
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: Supabase.instance.client.auth.currentUser != null
          ? const TasksPage()
          : const LoginPage(),
    );
  }
}
