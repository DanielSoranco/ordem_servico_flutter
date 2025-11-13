// lib/domain/usecases/salvar_atendimento_usecase.dart
import 'package:injectable/injectable.dart';
import '../entities/atendimento.dart';
import '../repositories/atendimento_repository.dart';

@lazySingleton
class SalvarAtendimentoUseCase {
  final AtendimentoRepository _repository;

  SalvarAtendimentoUseCase(this._repository);

  Future<void> call(Atendimento atendimento) {
    return _repository.salvar(atendimento);
  }
}