// lib/presentation/screens/listagem/listagem_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordem_servico/core/di/injection.dart'; // Acesso ao getIt
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/presentation/cubits/listagem/listagem_atendimento_cubit.dart';
import 'package:ordem_servico/presentation/cubits/listagem/listagem_atendimento_state.dart';
import 'package:ordem_servico/presentation/screens/realizacao/realizacao_screen.dart'; // Import da tela de formulário

class ListagemScreen extends StatelessWidget {
  const ListagemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Injeta o Cubit e carrega a lista inicial
      create: (_) => getIt<ListagemAtendimentoCubit>()..carregarAtendimentos(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestão de Atendimentos'),
          centerTitle: true,
        ),
        // --- Botão Flutuante (Novo Atendimento) ---
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                // Navega para a tela de Realização (sem ID = Novo)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RealizacaoScreen()),
                ).then((_) {
                  // Ao voltar, recarrega a lista para mostrar o novo item
                  if (context.mounted) {
                    context.read<ListagemAtendimentoCubit>().carregarAtendimentos();
                  }
                });
              },
              child: const Icon(Icons.add),
            );
          }
        ),
        
        body: Column(
          children: [
            // --- Filtros (Barra Superior) ---
            const _FiltrosSection(),

            // --- Lista de Cards ---
            Expanded(
              child: BlocBuilder<ListagemAtendimentoCubit, ListagemAtendimentoState>(
                builder: (context, state) {
                  // 1. Estado de Carregamento
                  if (state is ListagemAtendimentoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } 
                  
                  // 2. Estado de Erro
                  else if (state is ListagemAtendimentoFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.erro, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<ListagemAtendimentoCubit>().carregarAtendimentos(),
                            child: const Text("Tentar Novamente"),
                          )
                        ],
                      ),
                    );
                  } 
                  
                  // 3. Estado de Sucesso (Lista)
                  else if (state is ListagemAtendimentoSuccess) {
                    final lista = state.listaFiltrada;

                    if (lista.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              "Nenhum atendimento encontrado.",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<ListagemAtendimentoCubit>().carregarAtendimentos(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80), // Espaço para o FAB
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          final atendimento = lista[index];
                          return _AtendimentoCard(atendimento: atendimento);
                        },
                      ),
                    );
                  }
                  
                  // 4. Estado Inicial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET: Barra de Filtros
// ==========================================
class _FiltrosSection extends StatelessWidget {
  const _FiltrosSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<ListagemAtendimentoCubit, ListagemAtendimentoState>(
        builder: (context, state) {
          AtendimentoStatus? filtroAtual;
          if (state is ListagemAtendimentoSuccess) {
            filtroAtual = state.filtroAtual;
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  isSelected: filtroAtual == null,
                  onTap: () => context.read<ListagemAtendimentoCubit>().aplicarFiltro(null),
                ),
                ...AtendimentoStatus.values.map((status) {
                  return _FilterChip(
                    label: status.nome,
                    isSelected: filtroAtual == status,
                    onTap: () => context.read<ListagemAtendimentoCubit>().aplicarFiltro(status),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: theme.primaryColor,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        // Remove a borda padrão do Material 3 para ficar mais limpo
        side: BorderSide.none, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// ==========================================
// WIDGET: Card do Atendimento
// ==========================================
class _AtendimentoCard extends StatelessWidget {
  final Atendimento atendimento;

  const _AtendimentoCard({required this.atendimento});

  @override
  Widget build(BuildContext context) {
    // Define cores baseadas no status
    Color statusColor;
    IconData statusIcon;

    switch (atendimento.status) {
      case AtendimentoStatus.ativo:
        statusColor = Colors.blue;
        statusIcon = Icons.play_circle_outline;
        break;
      case AtendimentoStatus.emAndamento:
        statusColor = Colors.orange;
        statusIcon = Icons.timelapse;
        break;
      case AtendimentoStatus.finalizado:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
    }

    return Card(
      clipBehavior: Clip.antiAlias, // Para o InkWell funcionar com bordas arredondadas
      child: InkWell(
        // Navegação ao clicar no Card (Edição)
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RealizacaoScreen(idAtendimento: atendimento.id),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<ListagemAtendimentoCubit>().carregarAtendimentos();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone do Status
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: statusColor),
                  ),
                  const SizedBox(width: 12),
                  
                  // Textos Principais
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          atendimento.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          atendimento.descricao,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),

                  // Menu de Ações (3 pontinhos)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'excluir') {
                        _confirmarExclusao(context);
                      } else if (value == 'editar') {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RealizacaoScreen(idAtendimento: atendimento.id),
                          ),
                        ).then((_) {
                           if (context.mounted) context.read<ListagemAtendimentoCubit>().carregarAtendimentos();
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Row(
                            children: [Icon(Icons.edit, size: 20, color: Colors.grey), SizedBox(width: 8), Text('Editar')]
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'excluir',
                          child: Row(
                            children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text('Excluir')]
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Rodapé do Card (Data e Status)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status: ${atendimento.status.nome}",
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (atendimento.caminhoFoto != null && atendimento.caminhoFoto!.isNotEmpty)
                    const Icon(Icons.camera_alt, size: 16, color: Colors.grey),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Atendimento"),
        content: const Text("Tem a certeza que deseja remover este item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Fecha o dialog
              // Chama o Cubit para excluir
              context.read<ListagemAtendimentoCubit>().excluirAtendimento(atendimento.id!);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}