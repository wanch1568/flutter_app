import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/provider/riverpod_provider.dart';
import 'btracker_input.dart';
import 'btracker_calender.dart';
import 'btracker_other.dart';
import 'btracker_report.dart';
import '/widgets/footer.dart';
import '/services/database_service.dart';
import '/widgets/edit_footer.dart';



class BtrackerMain extends ConsumerWidget{
    final dbService=DatabaseService.instance;
    final _pageWidgets = [
        BtrackerInput(),
        BtrackerCalender(),
        BtrackerReport(),
        BtrackerOther(),
    ];
    @override
    Widget build(BuildContext context,WidgetRef ref){
        return FutureBuilder(
            future:queryAll("categories"),
            builder: (context, snapshot) {
                // Futureがまだ完了していない場合は、ローディングインジケータを表示
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        appBar:AppBar(title:Text("")),
                    );
                }

                // エラーハンドリング
                if (snapshot.hasError) {
                    return Text('エラーが発生しました: ${snapshot.error}');
                }
                int  _currentIndex=ref.watch(btrackerPageIndex);
                bool isEdit=ref.watch(isEditing);
                var asyncData2 = ref.read(initialCategoryProvider);
                var asyncData3 = ref.read(initialDataProvider);
                return Scaffold(
                    appBar:AppBar(
                        centerTitle:true,
                        title:_currentIndex==0 && !isEdit?Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children:[
                                ElevatedButton(
                                    onPressed:(){
                                        print("hi");
                                        ref.read(isOutcomeProvider.notifier).state=true;
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: ref.watch(isOutcomeProvider)?Colors.blue:Colors.white, // ボタンの背景色
                                        onPrimary: ref.watch(isOutcomeProvider)?Colors.white:Colors.black, // ボタン内のテキストやアイコンの色
                                    ),
                                    child:Text("支出")
                                ),
                                SizedBox(width:10),
                                ElevatedButton(
                                    onPressed:(){
                                        ref.read(isOutcomeProvider.notifier).state=false;
                                        
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: !ref.watch(isOutcomeProvider)?Colors.blue:Colors.white, // ボタンの背景色
                                        onPrimary: !ref.watch(isOutcomeProvider)?Colors.white:Colors.black, // ボタン内のテキストやアイコンの色
                                    ),
                                    child:Text("収入")
                                ),
                            ],
                        ):_currentIndex==0?Text("編集"):Text(ref.watch(apptitle)),
                    ),
                    body:_pageWidgets[_currentIndex],
                    //Footer(List<NavBarItem(String,Icons)>)
                    
                    bottomNavigationBar:!isEdit? Footer([
                        NavBarItem("入力",Icons.edit),
                        NavBarItem("カレンダー",Icons.calendar_month),
                        NavBarItem("レポート",Icons.analytics),
                        NavBarItem("その他",Icons.settings),
                    ]):null,
                    
                        
                );
            }
        );
    }
    Future<List<Map<String,dynamic>>> queryAll(String table) async{
        final allRows = await dbService.queryAllRows(table);
        return allRows;
    }
}