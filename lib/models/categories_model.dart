import '/models/table_model.dart';

// models/categories_model.dart
class CategoriesModel extends TableModel {
  CategoriesModel() : super('categories', ['id INTEGER PRIMARY KEY','type TEXT NOT NULL', 'name TEXT NOT NULL','categoriesid INTEGER']);
}
