// lib/core/database/database_helper.dart

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton // Garante que só existe uma conexão aberta no app todo
class DatabaseHelper {
  static Database? _database;

  // Getter que retorna o banco já aberto (ou abre se não tiver)
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDB('ordem_servico.db');
    return _database!;
  }

  // Lógica de inicialização
  Future<Database> _initDB(String filePath) async {
    // Pega o caminho padrão onde o Android/iOS guarda bancos
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // Se mudar a estrutura da tabela no futuro, suba a versão
      onCreate: _createDB,
    );
  }

  // Criação da Tabela (Roda apenas na primeira vez)
  Future<void> _createDB(Database db, int version) async {
    /*
      Mapeamento dos campos:
      id -> INTEGER PK
      titulo, descricao -> TEXT
      status -> TEXT (Vamos salvar como String: 'ativo', 'finalizado'...)
      data_criacao -> TEXT (Vamos salvar no formato ISO8601)
      observacoes_realizacao -> TEXT
      caminho_foto -> TEXT
    */
    await db.execute('''
      CREATE TABLE atendimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        status TEXT NOT NULL,
        data_criacao TEXT NOT NULL,
        observacoes_realizacao TEXT,
        caminho_foto TEXT
      )
    ''');
  }
}