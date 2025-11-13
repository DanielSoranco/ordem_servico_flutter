// lib/presentation/cubits/listagem/listagem_atendimento_state.dart
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';

abstract class ListagemAtendimentoState {
  const ListagemAtendimentoState();
}

class ListagemAtendimentoInitial extends ListagemAtendimentoState {}

class ListagemAtendimentoLoading extends ListagemAtendimentoState {}

class ListagemAtendimentoFailure extends ListagemAtendimentoState {
  final String erro;
  const ListagemAtendimentoFailure(this.erro);
}

// Estado de sucesso, contém todos os dados que a UI precisa
class ListagemAtendimentoSuccess extends ListagemAtendimentoState {
  // Guarda a lista original completa para poder re-filtrar
  final List<Atendimento> listaCompleta;
  
  // Guarda a lista que será exibida na UI
  final List<Atendimento> listaFiltrada;
  
  // Guarda qual filtro está ativo no momento
  final AtendimentoStatus? filtroAtual;

  const ListagemAtendimentoSuccess({
    required this.listaCompleta,
    required this.listaFiltrada,
    this.filtroAtual,
  });

  // Método copyWith para facilitar a atualização do estado
  ListagemAtendimentoSuccess copyWith({
    List<Atendimento>? listaCompleta,
    List<Atendimento>? listaFiltrada,
    AtendimentoStatus? filtroAtual,
    bool removerFiltro = false, // Flag para limpar o filtro
  }) {
    return ListagemAtendimentoSuccess(
      listaCompleta: listaCompleta ?? this.listaCompleta,
      listaFiltrada: listaFiltrada ?? this.listaFiltrada,
      // Se 'removerFiltro' for true, define o filtroAtual como nulo
      filtroAtual: removerFiltro ? null : (filtroAtual ?? this.filtroAtual),
    );
  }
}