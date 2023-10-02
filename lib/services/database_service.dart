import 'dart:async';

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '/models/table_model.dart'; // 追加
import '/models/transactions_model.dart';
import '/models/categories_model.dart';

class DatabaseService {

    static final _databaseName = "MyDatabase.db"; // DB名
    static final _databaseVersion = 1; // スキーマのバージョン指定
    static List<Map<String,dynamic>> categories=[
        {"name":"食費","type":"outcome","categoriesid":0},
        {"name":"日用品","type":"outcome","categoriesid":1},
        {"name":"美容","type":"outcome","categoriesid":2},
        {"name":"交際費","type":"outcome","categoriesid":3},
        {"name":"医療費","type":"outcome","categoriesid":4},
        {"name":"教育費","type":"outcome","categoriesid":5},
        {"name":"交通費","type":"outcome","categoriesid":6},
        {"name":"通信費","type":"outcome","categoriesid":7},
        {"name":"住居費","type":"outcome","categoriesid":8},
        {"name":"光熱費","type":"outcome","categoriesid":9},
        {"name":"趣味","type":"outcome","categoriesid":10},
        {"name":"ペット","type":"outcome","categoriesid":11},
        {"name":"給料","type":"income","categoriesid":12},
        {"name":"お小遣い","type":"income","categoriesid":13},
        {"name":"副業","type":"income","categoriesid":14},
        {"name":"貯金","type":"income","categoriesid":3},
    ];
    
    // DatabaseService クラスを定義
    DatabaseService._privateConstructor();
    // DatabaseService._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
    // DatabaseService クラスのインスタンスは、常に同じものであるという保証
    static final DatabaseService instance = DatabaseService._privateConstructor();

    // Databaseクラス型のstatic変数_databaseを宣言
    // クラスはインスタンス化しない
    static Database? _database;

    // databaseメソッド定義
    // 非同期処理
    Future<Database?> get database async {
        // _databaseがNULLか判定
        // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
        // NULLでない場合、そのまま_database変数を返す
        // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
        // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
        if (_database != null) return _database;
        _database = await _initDatabase();
        return _database;
    }

    // データベース接続
    _initDatabase() async {
        // アプリケーションのドキュメントディレクトリのパスを取得
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        // 取得パスを基に、データベースのパスを生成
        print(documentsDirectory);
        String path = join(documentsDirectory.path, _databaseName);
        // データベース接続
        return await openDatabase(
            path,
            version: _databaseVersion,
            // テーブル作成メソッドの呼び出し
            onCreate: _onCreate
        );
    }

    // テーブル作成
    // 引数:dbの名前
    // 引数:スキーマーのversion
    // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
    /*
    Future _onCreate(Database db, int version) async {
        
        await db.execute('''
            CREATE TABLE $table (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnAge INTEGER NOT NULL
            )
        ''');
    }
    */
    Future _onCreate(Database db, int version) async {
        List<TableModel> tableModels = [TransactionsModel(), CategoriesModel()];

        for (TableModel tableModel in tableModels) {
            String sql = '''
                CREATE TABLE ${tableModel.tableName} (
                ${tableModel.columns.join(', ')}
                )
            ''';
        await db.execute(sql);
        }
        categories.forEach((category)async{
            await initCategory(category);
        });
        
    }
    Future<int> initCategory(Map<String,dynamic> data) async{
        Database? db = await instance.database;
        return await db!.insert("categories",data);
    }
    // 登録処理
    Future<int> insert(String table,Map<String, dynamic> row) async {
        Database? db = await instance.database;
        return await db!.insert(table, row);
    }

    // 照会処理
    Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
        Database? db = await instance.database;
        return await db!.query(table);
    }

    // レコード数を確認
    Future<int?> queryRowCount(String table) async {
        Database? db = await instance.database;
        return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
    }

    //　更新処理
    
    Future<int> update(String table,Map<String, dynamic> row,int id) async {
        Database? db = await instance.database;
        //int id =1;
        return await db!.update(table, row, where: 'id = ?', whereArgs: [id]);
    }

    //　削除処理
    Future<int> delete(String table,int id) async {
        Database? db = await instance.database;
        return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
    }
    
}