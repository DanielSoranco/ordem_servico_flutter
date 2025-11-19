// lib/main.dart

import 'package:flutter/material.dart';
import 'package:ordem_servico/core/di/injection.dart'; // Nossa configuração de DI
import 'package:ordem_servico/presentation/screens/listagem/listagem_screen.dart'; // Nossa tela principal

Future<void> main() async {
  // 1. Garante que a engine do Flutter esteja pronta antes de rodar código assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa a Injeção de Dependência (GetIt/Injectable)
  // Isso registra o Repositório Mock e o Cubit antes do app abrir
  await configureDependencies();

  // 3. Roda o aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Atendimentos',
      debugShowCheckedModeBanner: false, // Remove a faixa "Debug" do canto
      
      // Configuração de Tema (Material 3)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Cor principal do app
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Estilo padrão para os Cards da listagem
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        
        // Estilo padrão da AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // Cor do texto/ícones
        ),
      ),

      // Define a tela de Listagem como a inicial
      home: const ListagemScreen(),
    );
  }
}
