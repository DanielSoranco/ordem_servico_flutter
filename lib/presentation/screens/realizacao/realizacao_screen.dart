// lib/presentation/screens/realizacao/realizacao_screen.dart

import 'dart:io'; // Necessário para exibir a foto do ficheiro
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordem_servico/core/di/injection.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/presentation/cubits/realizacao/realizacao_atendimento_cubit.dart';
import 'package:ordem_servico/presentation/cubits/realizacao/realizacao_atendimento_state.dart';

class RealizacaoScreen extends StatelessWidget {
  final int? idAtendimento;

  const RealizacaoScreen({super.key, this.idAtendimento});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RealizacaoAtendimentoCubit>()..carregar(idAtendimento),
      child: Scaffold(
        appBar: AppBar(
          title: Text(idAtendimento == null ? 'Novo Atendimento' : 'Editar Atendimento'),
        ),
        body: BlocConsumer<RealizacaoAtendimentoCubit, RealizacaoAtendimentoState>(
          listener: (context, state) {
            if (state is RealizacaoAtendimentoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Atendimento guardado com sucesso!')),
              );
              Navigator.pop(context); // Volta para a listagem
            } else if (state is RealizacaoAtendimentoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.erro), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is RealizacaoAtendimentoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RealizacaoAtendimentoLoaded) {
              return _FormularioAtendimento(
                state: state,
                cubit: context.read<RealizacaoAtendimentoCubit>(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _FormularioAtendimento extends StatefulWidget {
  final RealizacaoAtendimentoLoaded state;
  final RealizacaoAtendimentoCubit cubit;

  const _FormularioAtendimento({required this.state, required this.cubit});

  @override
  State<_FormularioAtendimento> createState() => _FormularioAtendimentoState();
}

class _FormularioAtendimentoState extends State<_FormularioAtendimento> {
  // Controladores para manter o texto estável durante a edição
  late TextEditingController _tituloCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _obsCtrl;

  @override
  void initState() {
    super.initState();
    final att = widget.state.atendimento;
    _tituloCtrl = TextEditingController(text: att.titulo);
    _descCtrl = TextEditingController(text: att.descricao);
    _obsCtrl = TextEditingController(text: att.observacoesRealizacao);
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final atendimento = widget.state.atendimento;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Área da Foto ---
          GestureDetector(
            onTap: widget.cubit.capturarFoto,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: atendimento.caminhoFoto != null && atendimento.caminhoFoto!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(atendimento.caminhoFoto!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                            child: Text("Erro ao carregar imagem", textAlign: TextAlign.center)),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("Toque para adicionar foto", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Campos de Texto ---
          TextFormField(
            controller: _tituloCtrl,
            decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
            onChanged: widget.cubit.atualizarTitulo,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
            maxLines: 3,
            onChanged: widget.cubit.atualizarDescricao,
          ),
          const SizedBox(height: 16),

          // --- Dropdown de Status ---
          DropdownButtonFormField<AtendimentoStatus>(
            value: atendimento.status,
            decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
            items: AtendimentoStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.nome), // Usa a extensão .nome que criámos
              );
            }).toList(),
            onChanged: (novoStatus) {
              if (novoStatus != null) widget.cubit.mudarStatus(novoStatus);
            },
          ),
          const SizedBox(height: 16),

          // --- Observações (Realização) ---
          TextFormField(
            controller: _obsCtrl,
            decoration: const InputDecoration(
              labelText: 'Relatório / Observações',
              border: OutlineInputBorder(),
              hintText: 'Descreva o que foi feito no serviço...',
            ),
            maxLines: 5,
            onChanged: widget.cubit.atualizarObservacoes,
          ),
          const SizedBox(height: 24),

          // --- Botão Guardar ---
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.state.isSaving ? null : widget.cubit.salvar,
              icon: widget.state.isSaving
                  ? const SizedBox(
                      width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(widget.state.isSaving ? "A guardar..." : "Guardar Atendimento"),
            ),
          ),
        ],
      ),
    );
  }
}