// lib/presentation/cubits/listagem/listagem_atendimento_cubit.dart
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/domain/usecases/buscar_todos_atendimentos_usecase.dart';
import 'package:ordem_servico/domain/usecases/excluir_atendimento_usecase.dart';
import 'package:ordem_servico/domain/usecases/salvar_atendimento_usecase.dart';
import 'listagem_atendimento_state.dart';

@injectable // Registra o Cubit no GetIt
class ListagemAtendimentoCubit extends Cubit<ListagemAtendimentoState> {
  final BuscarTodosAtendimentosUseCase _buscarTodos;
  final ExcluirAtendimentoUseCase _excluir;
  final SalvarAtendimentoUseCase _salvar; // (usado para mudar status)

  ListagemAtendimentoCubit(
    this._buscarTodos,
    this._excluir,
    this._salvar,
  ) : super(ListagemAtendimentoInitial());

  /// Método principal para carregar os dados
  Future<void> carregarAtendimentos() async {
    try {
      emit(ListagemAtendimentoLoading());
      final lista = await _buscarTodos();
      
      emit(ListagemAtendimentoSuccess(
        listaCompleta: lista,
        listaFiltrada: lista, // No início, a lista filtrada é a lista completa
        filtroAtual: null,
      ));
    } catch (e) {
      emit(ListagemAtendimentoFailure("Erro ao buscar atendimentos: $e"));
    }
  }

  /// Filtra a lista baseada no estado atual
  void aplicarFiltro(AtendimentoStatus? filtro) {
    // Só podemos filtrar se o estado atual for de Sucesso
    if (state is! ListagemAtendimentoSuccess) return;

    final currentState = state as ListagemAtendimentoSuccess;
    final listaCompleta = currentState.listaCompleta;

    if (filtro == null) {
      // Limpar filtro
      emit(currentState.copyWith(
        listaFiltrada: listaCompleta,
        removerFiltro: true, // Usa a flag para limpar o filtroAtual
      ));
    } else {
      // Aplicar filtro
      final listaFiltrada = listaCompleta.where((at) => at.status == filtro).toList();
      emit(currentState.copyWith(
        listaFiltrada: listaFiltrada,
        filtroAtual: filtro,
      ));
    }
  }

  /// Exclui um item (Ação da UI)
  Future<void> excluirAtendimento(int id) async {
    // Só podemos excluir se o estado atual for de Sucesso
    if (state is! ListagemAtendimentoSuccess) return;
    
    final currentState = state as ListagemAtendimentoSuccess;

    try {
      await _excluir(id);
      // Atualiza a lista local (imutabilidade)
      final novaListaCompleta = List<Atendimento>.from(currentState.listaCompleta)
        ..removeWhere((at) => at.id == id);
        
      final novaListaFiltrada = List<Atendimento>.from(currentState.listaFiltrada)
        ..removeWhere((at) => at.id == id);

      emit(currentState.copyWith(
        listaCompleta: novaListaCompleta,
        listaFiltrada: novaListaFiltrada,
      ));

    } catch (e) {
      // (Opcional) Emitir um estado de erro temporário
      emit(ListagemAtendimentoFailure("Erro ao excluir item: $e"));
      // Recarrega o estado de sucesso anterior
      emit(currentState);
    }
  }
}