// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Importa o arquivo que será gerado pelo build_runner
import 'injection.config.dart';

// Instância global do GetIt (Service Locator)
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // Nome da função gerada
  preferRelativeImports: true,    // Importações relativas
  asExtension: false,             // Gera como uma função (não extensão)
)
Future<void> configureDependencies() async {
  // O build_runner vai gerar a implementação desta função
  await $initGetIt(getIt);
}