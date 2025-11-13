// lib/domain/entities/atendimento_status.dart

enum AtendimentoStatus {
  ativo,
  emAndamento,
  finalizado,
}

// Extensão opcional para facilitar a exibição na UI
extension AtendimentoStatusX on AtendimentoStatus {
  String get nome {
    switch (this) {
      case AtendimentoStatus.ativo:
        return 'Ativo';
      case AtendimentoStatus.emAndamento:
        return 'Em Andamento';
      case AtendimentoStatus.finalizado:
        return 'Finalizado';
    }
  }
}