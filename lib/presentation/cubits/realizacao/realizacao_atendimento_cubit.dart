// lib/presentation/cubits/realizacao/realizacao_atendimento_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/domain/repositories/atendimento_repository.dart';
import 'package:ordem_servico/domain/usecases/salvar_atendimento_usecase.dart';
import 'realizacao_atendimento_state.dart';

@injectable
class RealizacaoAtendimentoCubit extends Cubit<RealizacaoAtendimentoState> {
  final AtendimentoRepository _repository; // Para buscar pelo ID
  final SalvarAtendimentoUseCase _salvarUseCase; // Para salvar
  final ImagePicker _imagePicker; // Injetaremos o ImagePicker

  RealizacaoAtendimentoCubit(
    this._repository,
    this._salvarUseCase,
    this._imagePicker,
  ) : super(RealizacaoAtendimentoInitial());

  /// Inicia a tela. Se [id] for nulo, cria um novo atendimento em branco.
  Future<void> carregar(int? id) async {
    emit(RealizacaoAtendimentoLoading());

    try {
      Atendimento atendimento;

      if (id != null) {
        // Edição: Busca no banco/mock
        final encontrado = await _repository.buscarPorId(id);
        if (encontrado == null) {
          emit(const RealizacaoAtendimentoFailure("Atendimento não encontrado"));
          return;
        }
        atendimento = encontrado;
      } else {
        // Criação: Novo objeto vazio
        atendimento = Atendimento(
          titulo: '',
          descricao: '',
          status: AtendimentoStatus.ativo,
          dataCriacao: DateTime.now(),
        );
      }

      emit(RealizacaoAtendimentoLoaded(atendimento: atendimento));
    } catch (e) {
      emit(RealizacaoAtendimentoFailure("Erro ao carregar: $e"));
    }
  }

  // --- Métodos de Atualização do Formulário ---

  void atualizarTitulo(String titulo) {
    if (state is RealizacaoAtendimentoLoaded) {
      final current = state as RealizacaoAtendimentoLoaded;
      emit(current.copyWith(
        atendimento: current.atendimento.copyWith(titulo: titulo),
      ));
    }
  }

  void atualizarDescricao(String descricao) {
    if (state is RealizacaoAtendimentoLoaded) {
      final current = state as RealizacaoAtendimentoLoaded;
      emit(current.copyWith(
        atendimento: current.atendimento.copyWith(descricao: descricao),
      ));
    }
  }

  void atualizarObservacoes(String obs) {
    if (state is RealizacaoAtendimentoLoaded) {
      final current = state as RealizacaoAtendimentoLoaded;
      emit(current.copyWith(
        atendimento: current.atendimento.copyWith(observacoesRealizacao: obs),
      ));
    }
  }
  
  void mudarStatus(AtendimentoStatus status) {
     if (state is RealizacaoAtendimentoLoaded) {
      final current = state as RealizacaoAtendimentoLoaded;
      emit(current.copyWith(
        atendimento: current.atendimento.copyWith(status: status),
      ));
    }
  }

  // --- Lógica da Câmera ---

  Future<void> capturarFoto() async {
    if (state is! RealizacaoAtendimentoLoaded) return;
    final current = state as RealizacaoAtendimentoLoaded;

    try {
      // Abre a câmera
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Reduz qualidade para economizar espaço
      );

      if (photo != null) {
        // Atualiza o estado com o caminho da nova foto
        emit(current.copyWith(
          atendimento: current.atendimento.copyWith(caminhoFoto: photo.path),
        ));
      }
    } catch (e) {
      // Em caso de erro na câmera, não mudamos o estado principal,
      // talvez apenas logar ou mostrar snackbar na UI (trataremos na UI)
      print("Erro na câmera: $e");
    }
  }

  // --- Salvar ---

  Future<void> salvar() async {
    if (state is! RealizacaoAtendimentoLoaded) return;
    final current = state as RealizacaoAtendimentoLoaded;

    // Validação simples
    if (current.atendimento.titulo.isEmpty) {
      // Poderíamos emitir um erro, ou tratar na UI.
      return;
    }

    emit(current.copyWith(isSaving: true));

    try {
      await _salvarUseCase(current.atendimento);
      emit(const RealizacaoAtendimentoSuccess());
    } catch (e) {
      emit(RealizacaoAtendimentoFailure("Erro ao salvar: $e"));
      // Volta para o estado Loaded para o usuário tentar de novo
      emit(current.copyWith(isSaving: false));
    }
  }
}