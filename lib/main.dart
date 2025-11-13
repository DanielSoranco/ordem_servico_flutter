// lib/main.dart

import 'package:flutter/material.dart';
import 'package:ordem_servico/core/di/injection.dart'; // Importe o DI

Future<void> main() async {
  // Garante que os bindings do Flutter sejam inicializados
  WidgetsFlutterBinding.ensureInitialized(); 

  // --- CONFIGURAÇÃO DO DI ---
  // Aguarda a inicialização das dependências (ex: banco de dados)
  await configureDependencies();
  // -------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Atendimentos',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Início'),
        ),
        body: const Center(
          child: Text('Configuração Inicial OK'),
        ),
      ),
    );
  }
}
