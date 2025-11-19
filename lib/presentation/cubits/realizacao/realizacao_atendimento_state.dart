// lib/presentation/cubits/realizacao/realizacao_atendimento_state.dart

import 'package:ordem_servico/domain/entities/atendimento.dart';

abstract class RealizacaoAtendimentoState {
  const RealizacaoAtendimentoState();
}

class RealizacaoAtendimentoInitial extends RealizacaoAtendimentoState {}

class RealizacaoAtendimentoLoading extends RealizacaoAtendimentoState {}

class RealizacaoAtendimentoSuccess extends RealizacaoAtendimentoState {
  // Retornamos apenas uma mensagem ou indicação de que salvou
  const RealizacaoAtendimentoSuccess();
}

class RealizacaoAtendimentoFailure extends RealizacaoAtendimentoState {
  final String erro;
  const RealizacaoAtendimentoFailure(this.erro);
}

// Estado principal: O formulário está sendo exibido/editado
class RealizacaoAtendimentoLoaded extends RealizacaoAtendimentoState {
  final Atendimento atendimento;
  
  // Variável auxiliar para saber se está salvando (para mostrar spinner no botão)
  final bool isSaving;

  const RealizacaoAtendimentoLoaded({
    required this.atendimento,
    this.isSaving = false,
  });

  RealizacaoAtendimentoLoaded copyWith({
    Atendimento? atendimento,
    bool? isSaving,
  }) {
    return RealizacaoAtendimentoLoaded(
      atendimento: atendimento ?? this.atendimento,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}