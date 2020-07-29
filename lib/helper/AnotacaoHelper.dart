import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final tabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){
  }

  get db async {
    if(_db != null){
      return _db;
    }else{
      _db = inicializarDB();
      return _db;
    }
  }

  _onCreate (db, int version) async {
    String sql = "CREATE TABLE $tabela ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "db_minhas_anotacoes.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);

    return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {

    var bancoDados = await db;
    int resultado = await bancoDados.insert(tabela, anotacao.toMap());
    return resultado;

  }

  recuperarAnotacoes() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $tabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;

  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {

    var bancoDados =  await db;
    return await bancoDados.update(
      tabela,
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
    );

  }

}