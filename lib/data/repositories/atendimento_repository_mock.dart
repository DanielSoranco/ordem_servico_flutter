// lib/data/repositories/atendimento_repository_mock.dart

import 'package:injectable/injectable.dart';
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/domain/repositories/atendimento_repository.dart';

// 1. Registra esta classe como a implementação do "contrato"
@LazySingleton(as: AtendimentoRepository)
class AtendimentoRepositoryMock implements AtendimentoRepository {
  
  // 2. Nossa "base de dados" mockada
  final List<Atendimento> _mockDb = [
    Atendimento(
      id: 1,
      titulo: 'Instalação de Ponto de Rede',
      descricao: 'Cliente solicitou instalação de novo ponto de rede na sala 3.',
      status: AtendimentoStatus.ativo,
      dataCriacao: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Atendimento(
      id: 2,
      titulo: 'Manutenção Impressora',
      descricao: 'Impressora fiscal parou de imprimir. Urgente.',
      status: AtendimentoStatus.emAndamento,
      dataCriacao: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Atendimento(
      id: 3,
      titulo: 'Formatação de Notebook',
      descricao: 'Notebook do financeiro está lento, backup realizado.',
      status: AtendimentoStatus.finalizado,
      dataCriacao: DateTime.now().subtract(const Duration(days: 5)),
      observacoesRealizacao: 'Sistema reinstalado, drivers atualizados.',
      caminhoFoto: 'path/fake/foto.jpg', // Caminho fictício
    ),
  ];

  // 3. Implementação dos métodos do contrato
  
  @override
  Future<List<Atendimento>> buscarTodos() async {
    // Simula uma pequena demora de rede/banco
    await Future.delayed(const Duration(milliseconds: 300));
    // Retorna uma cópia da lista que não tenha status "excluido" (se tivéssemos)
    // Por enquanto, retornamos todos.
    return List.from(_mockDb);
  }

  @override
  Future<Atendimento?> buscarPorId(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _mockDb.firstWhere((at) => at.id == id);
    } catch (e) {
      return null; // Não encontrado
    }
  }

  @override
  Future<void> excluir(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Exclusão lógica (mudando status) ou física (removendo)
    // No nosso mock, vamos fazer a remoção física:
    _mockDb.removeWhere((at) => at.id == id);
  }

  @override
  Future<void> salvar(Atendimento atendimento) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (atendimento.id == null || atendimento.id == 0) {
      // --- CRIAR (Novo Atendimento) ---
      // Simula um auto-incremento
      // CORRETO:
final int maxId = _mockDb.fold(0, (max, e) => e.id! > max ? e.id! : max);
final int novoId = maxId + 1;
      
      _mockDb.add(atendimento.copyWith(
        id: novoId, // Atribui o novo ID
      ));
    } else {
      // --- ATUALIZAR (Atendimento Existente) ---
      final index = _mockDb.indexWhere((at) => at.id == atendimento.id);
      if (index != -1) {
        _mockDb[index] = atendimento; // Substitui o atendimento antigo
      }
    }
  }
}