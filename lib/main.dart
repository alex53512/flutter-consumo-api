import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AlquilerAutosApp());
}

class AlquilerAutosApp extends StatelessWidget {
  const AlquilerAutosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alquiler Autos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
