// lib/domain/usecases/excluir_atendimento_usecase.dart
import 'package:injectable/injectable.dart';
import '../repositories/atendimento_repository.dart';

@lazySingleton
class ExcluirAtendimentoUseCase {
  final AtendimentoRepository _repository;

  ExcluirAtendimentoUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.excluir(id);
  }
}