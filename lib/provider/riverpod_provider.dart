import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/services/database_service.dart';
import 'package:intl/intl.dart';

final selectedDate=StateProvider((ref)=>DateTime.now());
final selectedCategoryId=StateProvider((ref)=>0);
final selectedAddCategory=StateProvider((ref)=>1000);
final isEditing=StateProvider((ref)=>false);
final isOutcomeProvider=StateProvider((ref)=>true);
final selectedTransactionId=StateProvider((ref)=>1000);
final inputTitle=StateProvider((ref)=>"");
final inputCategoryTitle=StateProvider((ref)=>"");
final inputAmount=StateProvider((ref)=>0);
final btrackerPageIndex=StateProvider((ref)=>0);
final apptitle=StateProvider((ref)=>"入力");
final isInit=StateProvider((ref)=>false);
final calenderChanged=StateProvider((ref)=>false);
final categories=StateProvider<Map<int,String>>((ref)=>{});
final currentMonth=StateProvider<String>((ref)=>DateFormat('yyyy/MM').format(DateTime.now()));
final initialDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
    final data = await queryAll("transactions");
    ref.read(databaseNotifierProvider.notifier).updateData(data);
    return data;
});
final initialCategoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
    final data = await queryAll("categories");
    ref.read(databaseCategoryNotifierProvider.notifier).updateData(data);
    return data;
});
final databaseNotifierProvider = StateNotifierProvider<DatabaseStateNotifier, List<Map<String, dynamic>>>((ref) => DatabaseStateNotifier());
final databaseCategoryNotifierProvider = StateNotifierProvider<DatabaseStateNotifier, List<Map<String, dynamic>>>((ref) => DatabaseStateNotifier());
final isUpdateDatabase=StateProvider((ref)=>false);
final dbService=DatabaseService.instance;
Future<List<Map<String,dynamic>>> queryAll(String table) async{
    final allRows = await dbService.queryAllRows(table);
    return allRows;
}

class DatabaseStateNotifier extends StateNotifier<List<Map<String, dynamic>>> {
    DatabaseStateNotifier() : super([]);
  
    void updateData(List<Map<String, dynamic>> newData) {
        state = newData;
    }
}
//initialDataProvider→dataを取得→ref.read(databaseNotifierProvider.notifier).updateData(data)
//でdetabaseNotifierProviderにdataを渡す
//