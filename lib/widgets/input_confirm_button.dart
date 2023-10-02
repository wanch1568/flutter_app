import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/view_models/create_categories.dart';
import '/provider/riverpod_provider.dart';
import '/widgets/alert_dialog_widget.dart';


class InputConfirmButton extends ConsumerWidget{
    String label;
    int type;
    InputConfirmButton(this.label,this.type);
    @override
    Widget build(BuildContext context,WidgetRef ref){
        return ElevatedButton(
            child:Text(label),
            onPressed:(){
                print("送信");
                showDialog<void>(
                    context: context,
                    builder: (_) {
                    return AlertDialogWidget("よろしいですか？",type);
                });

                /*await dbService.insert(
                    "transactions",
                    {"date":DateFormat('yyyy/MM/dd').format(ref.read(selectedDate)),"title":ref.read(inputTitle),"amount":ref.read(inputAmount),"type":ref.watch(isOutcome)?"outcome":"income","categoryId":ref.read(selectedCategoryId)},
                );
                var newData=await queryAll("transactions");
                print(newData);
                ref.read(databaseNotifierProvider.notifier).updateData(newData);*/
            },
        );
    }
    
}