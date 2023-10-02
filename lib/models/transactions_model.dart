import '/models/table_model.dart';

// models/transactions_model.dart
class TransactionsModel extends TableModel {
  TransactionsModel()
      : super('transactions', [
          'id INTEGER PRIMARY KEY',
          'date TEXT NOT NULL',
          'title TEXT',
          'amount REAL NOT NULL',
          'type TEXT NOT NULL',
          'categoryId INTEGER'
        ]);
}
