// lib/domain/repositories/atendimento_repository.dart

import '../entities/atendimento.dart';

// Esta é a classe abstrata (contrato) que a Camada de Dados
// (Data Layer) deverá implementar.
abstract class AtendimentoRepository {
  
  /// Busca todos os atendimentos cadastrados.
  /// A filtragem por status será feita na lógica de negócio (UseCase/Cubit)
  /// sobre a lista retornada.
  Future<List<Atendimento>> buscarTodos();

  /// Busca um atendimento específico pelo seu ID.
  /// Usado para carregar a tela de "Realização" ou "Alteração".
  Future<Atendimento?> buscarPorId(int id);

  /// Salva um atendimento.
  /// Se o atendimento tiver um ID nulo, deve ser uma inserção (Incluir).
  /// Se o atendimento tiver um ID, deve ser uma atualização (Alterar).
  /// Isso inclui finalizar, ativar ou desativar (mudando o status).
  Future<void> salvar(Atendimento atendimento);

  /// Realiza a exclusão (lógica ou física) de um atendimento.
  /// Baseado no escopo ("Exclusão Lógica"), a implementação
  /// provavelmente definirá um status "desativado" ou "excluido".
  Future<void> excluir(int id);
}