// lib/domain/entities/atendimento.dart

import 'atendimento_status.dart';

class Atendimento {
  final int? id; // Pode ser nulo se ainda não foi salvo no banco
  final String titulo;
  final String descricao;
  final AtendimentoStatus status;
  final DateTime dataCriacao;
  final String? observacoesRealizacao; // Para a tela de "Realização"
  final String? caminhoFoto;          // Caminho da imagem capturada

  Atendimento({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.dataCriacao,
    this.observacoesRealizacao,
    this.caminhoFoto,
  });

  // É útil ter um método copyWith para facilitar
  // as atualizações no Cubit (imutabilidade)
  Atendimento copyWith({
    int? id,
    String? titulo,
    String? descricao,
    AtendimentoStatus? status,
    DateTime? dataCriacao,
    String? observacoesRealizacao,
    String? caminhoFoto,
  }) {
    return Atendimento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      observacoesRealizacao: observacoesRealizacao ?? this.observacoesRealizacao,
      caminhoFoto: caminhoFoto ?? this.caminhoFoto,
    );
  }
}