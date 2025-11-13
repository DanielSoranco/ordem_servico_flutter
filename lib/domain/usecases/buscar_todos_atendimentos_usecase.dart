// lib/domain/usecases/buscar_todos_atendimentos_usecase.dart
import 'package:injectable/injectable.dart';
import '../entities/atendimento.dart';
import '../repositories/atendimento_repository.dart';

@lazySingleton
class BuscarTodosAtendimentosUseCase {
  final AtendimentoRepository _repository;

  BuscarTodosAtendimentosUseCase(this._repository);

  // O 'call' permite que a classe seja chamada como uma função
  Future<List<Atendimento>> call() {
    return _repository.buscarTodos();
  }
}