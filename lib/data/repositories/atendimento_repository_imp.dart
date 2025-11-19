// lib/data/repositories/atendimento_repository_imp.dart

import 'package:injectable/injectable.dart';
import 'package:ordem_servico/core/database/database_helper.dart';
import 'package:ordem_servico/domain/entities/atendimento.dart';
import 'package:ordem_servico/domain/entities/atendimento_status.dart';
import 'package:ordem_servico/domain/repositories/atendimento_repository.dart';

@LazySingleton(as: AtendimentoRepository)
class AtendimentoRepositoryImp implements AtendimentoRepository {
  final DatabaseHelper _dbHelper;

  AtendimentoRepositoryImp(this._dbHelper);

  @override
  Future<void> salvar(Atendimento atendimento) async {
    final db = await _dbHelper.database;

    // Converte o Objeto para um Mapa que o SQLite entende
    final map = {
      'titulo': atendimento.titulo,
      'descricao': atendimento.descricao,
      'status': atendimento.status.name, // Salva 'ativo' (String)
      'data_criacao': atendimento.dataCriacao.toIso8601String(),
      'observacoes_realizacao': atendimento.observacoesRealizacao,
      'caminho_foto': atendimento.caminhoFoto,
    };

    if (atendimento.id == null) {
      // Inserir novo
      await db.insert('atendimentos', map);
    } else {
      // Atualizar existente
      await db.update(
        'atendimentos',
        map,
        where: 'id = ?',
        whereArgs: [atendimento.id],
      );
    }
  }

  @override
  Future<void> excluir(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'atendimentos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Atendimento>> buscarTodos() async {
    final db = await _dbHelper.database;
    // Busca ordenado pelos mais recentes primeiro
    final List<Map<String, dynamic>> maps = await db.query('atendimentos', orderBy: 'data_criacao DESC');

    return List.generate(maps.length, (i) {
      return _mapToEntity(maps[i]);
    });
  }

  @override
  Future<Atendimento?> buscarPorId(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'atendimentos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToEntity(maps.first);
    }
    return null;
  }

  // Função auxiliar para converter do Banco -> Entidade
  Atendimento _mapToEntity(Map<String, dynamic> map) {
    // Converte a String 'ativo' de volta para o Enum AtendimentoStatus.ativo
    final statusString = map['status'] as String;
    final statusEnum = AtendimentoStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => AtendimentoStatus.ativo,
    );

    return Atendimento(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      status: statusEnum,
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
      observacoesRealizacao: map['observacoes_realizacao'] as String?,
      caminhoFoto: map['caminho_foto'] as String?,
    );
  }
}