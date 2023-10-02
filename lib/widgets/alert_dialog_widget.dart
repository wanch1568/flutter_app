import 'package:flutter/material.dart';
import '/services/database_service.dart';
import '/provider/riverpod_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertDialogWidget extends ConsumerWidget {
    //const AlertDialogWidget({Key? key}) : super(key: key);
    String title;
    int type;
    AlertDialogWidget(this.title,this.type);

    @override
    Widget build(BuildContext context,WidgetRef ref) {
        return AlertDialog(
        title: Text(title),
        content: Text(''),
        actionsAlignment:MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
            GestureDetector(
                child: Text('いいえ'),
                onTap: () {
                    Navigator.pop(context);
                },
            ),
            GestureDetector(
                child: Text('はい'),
                onTap: ()async {
                    switch(type){
                        case 0:
                            await dbService.insert(
                                "transactions",
                                {"date":DateFormat('yyyy/MM/dd').format(ref.read(selectedDate)),"title":ref.read(inputTitle),"amount":ref.read(inputAmount),"type":ref.watch(isOutcomeProvider)?"outcome":"income","categoryId":ref.read(selectedCategoryId)},
                            );
                            ref.read(selectedDate.notifier).state=DateTime.now();
                            ref.read(selectedCategoryId.notifier).state=0;
                            ref.read(inputTitle.notifier).state="";
                            ref.read(inputAmount.notifier).state=0;
                            var newData=await queryAll("transactions");
                            print(newData);
                            ref.read(databaseNotifierProvider.notifier).updateData(newData);
                            Navigator.pop(context);
                            break;
                        case 1:
                            await dbService.update(
                                "transactions",
                                {"date":DateFormat('yyyy/MM/dd').format(ref.read(selectedDate)),"title":ref.read(inputTitle),"amount":ref.read(inputAmount),"type":ref.watch(isOutcomeProvider)?"outcome":"income","categoryId":ref.read(selectedCategoryId)},
                                ref.read(selectedTransactionId),
                            );
                            Navigator.pop(context);
                            ref.read(selectedDate.notifier).state=DateTime.now();
                            ref.read(selectedCategoryId.notifier).state=0;
                            ref.read(inputTitle.notifier).state="";
                            ref.read(inputAmount.notifier).state=0;
                            ref.read(btrackerPageIndex.notifier).state=1;
                            ref.read(isEditing.notifier).state=false;
                            ref.read(selectedTransactionId.notifier).state=1000;
                            ref.read(isOutcomeProvider.notifier).state=true;
                            var newData=await queryAll("transactions");
                            print(newData);
                            ref.read(databaseNotifierProvider.notifier).updateData(newData);
                            
                            break;
                        case 2:
                            await dbService.delete(
                                "transactions",
                                ref.read(selectedTransactionId),
                            );
                            Navigator.pop(context);
                            ref.read(selectedDate.notifier).state=DateTime.now();
                            ref.read(selectedCategoryId.notifier).state=0;
                            ref.read(inputTitle.notifier).state="";
                            ref.read(inputAmount.notifier).state=0;
                            ref.read(btrackerPageIndex.notifier).state=1;
                            ref.read(isEditing.notifier).state=false;
                            ref.read(selectedTransactionId.notifier).state=1000;
                            ref.read(isOutcomeProvider.notifier).state=true;
                            var newData=await queryAll("transactions");
                            print(newData);
                            ref.read(databaseNotifierProvider.notifier).updateData(newData);
                            break;
                    }
                },
            )
        ],
        );
    }
    Future<List<Map<String,dynamic>>> queryAll(String table) async{
        final allRows = await dbService.queryAllRows("transactions");
        return allRows;
    }
}
