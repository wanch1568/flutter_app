import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '/widgets/input_calender.dart';
import '/widgets/input_categories.dart';
import '/widgets/input_confirm_button.dart';
import '/provider/riverpod_provider.dart';
import '/widgets/add_category.dart';

DateTime _focusedDay=DateTime.now();


class BtrackerInput extends ConsumerWidget{
    @override
    Widget build(BuildContext context,WidgetRef ref){
        bool isEdit=ref.watch(isEditing);
        return Center(
            child:Container(
                margin:EdgeInsets.all(10)
,                child:Column(
                    children:[
                        Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children:[
                                Text("日付"),
                                
                                IconButton(
                                    icon:const Icon(Icons.arrow_left_outlined),
                                    onPressed:(){
                                        ref.read(selectedDate.notifier).state=ref.read(selectedDate).subtract(Duration(days:1));
                                        print("right");
                                    },
                                ),
                                InputCalender(),
                                
                                IconButton(
                                    icon:const Icon(Icons.arrow_right_outlined),
                                    onPressed:(){
                                        ref.read(selectedDate.notifier).state=ref.read(selectedDate).add(Duration(days:1));
                                        print("left");
                                    }
                                ),
                            ],
                        ),
                        Row(
                            children:[
                                Text("メモ"),
                                SizedBox(width:20),
                                Expanded(
                                    child:TextField(
                                        controller:TextEditingController(text:isEdit?ref.read(inputTitle):""),
                                        onChanged:(text){
                                            ref.read(inputTitle.notifier).state=text;
                                        }
                                    ),
                                ),
                            ],
                        ),
                        Row(
                            children:[
                                ref.watch(isOutcomeProvider)?Text("支出"):Text("収入"),
                                SizedBox(width:20),
                                Expanded(
                                    child:TextField(
                                        controller:TextEditingController(text:isEdit?ref.read(inputAmount).toString():""),
                                        onChanged:(text){
                                            ref.read(inputAmount.notifier).state=int.parse(text);
                                        }
                                    ),
                                ),
                                Text("円"),
                            ],
                        ),
                        SizedBox(
                            height:20,
                        ),
                        Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children:[
                                Text("カテゴリー",style:TextStyle(fontWeight:FontWeight.bold)),
                                SizedBox(width:10),
                                ElevatedButton(
                                    onPressed:(){
                                        showDialog(
                                            context:context,
                                            builder:(BuildContext context){
                                                return AddCategory();
                                            },
                                        );
                                    },
                                    child:Text("追加"),
                                ),
                            ],
                        ),
                        SizedBox(
                            height:20,
                        ),
                        InputCategories(),
                        if(!ref.watch(isEditing))
                        InputConfirmButton("決定",0),
                        if(ref.watch(isEditing))
                        Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children:[
                                ElevatedButton(
                                    child:Text("戻る"),
                                    onPressed:(){
                                        ref.read(btrackerPageIndex.notifier).state=1;
                                        ref.read(isEditing.notifier).state=false;
                                        ref.read(selectedCategoryId.notifier).state=0;
                                        ref.read(selectedDate.notifier).state=DateTime.now();
                                        ref.read(selectedTransactionId.notifier).state=1000;
                                    }
                                ),
                                InputConfirmButton("決定",1),
                                InputConfirmButton("削除",2),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }
}