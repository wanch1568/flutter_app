import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/constants/icons.dart';
import '/provider/riverpod_provider.dart';
import '/services/database_service.dart';

class AddCategory extends ConsumerWidget{
    final bool isEdit;  // ここにbool型のフィールドを追加します

    AddCategory({this.isEdit=false}); 
    final icons=IconList.iconList;
    final dbService=DatabaseService.instance;

    @override
    Widget build(BuildContext context,WidgetRef ref){
        
        List<List<IconData>> tmpIcons=[];
        icons.asMap().forEach((index,value){
            if(index%4==0){
                tmpIcons.add([]);
            }
            tmpIcons[tmpIcons.length-1].add(value);
        });
        //print(tmpIcons);
        return Dialog(
            child:Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Center(
                    child:Container(
                        margin:EdgeInsets.all(10),
                        child:Column(
                            children:[
                                Text(isEdit?"カテゴリー編集":"カテゴリー新規追加",style:TextStyle(fontWeight:FontWeight.bold)),
                                SizedBox(height:5),
                                Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children:[
                                        IconButton(
                                            icon:Icon(Icons.arrow_back),
                                            onPressed:(){
                                                ref.read(selectedAddCategory.notifier).state=1000;
                                                Navigator.of(context).pop();
                                            }
                                        ),
                                        if(isEdit)
                                        ElevatedButton(
                                            style:ElevatedButton.styleFrom(
                                                primary:Colors.red,
                                            ),
                                            child:Text("カテゴリー削除"),
                                            onPressed:()async{
                                                await dbService.delete("categories",ref.read(selectedCategoryId));
                                                var newData=await queryAll("categories");
                                                print(newData);
                                                ref.read(databaseCategoryNotifierProvider.notifier).updateData(newData);
                                                Navigator.of(context).pop();
                                            }
                                        ),
                                    ],
                                ),
                                SizedBox(height:10),
                                Row(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children:[
                                        Text("アイコン",style:TextStyle(fontWeight:FontWeight.bold)),
                                    ]
                                ),
                                Expanded(
                                    child:SizedBox(
                                        
                                        child:SingleChildScrollView(
                                            child:Table(
                                                border:TableBorder.all(),
                                                children:createTableRow(tmpIcons,ref),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(height:10),
                                Row(
                                    children:[
                                        Text("項目"),
                                        SizedBox(width:10),
                                        Expanded(
                                            child:TextField(
                                                controller:TextEditingController(text:isEdit?ref.read(inputCategoryTitle):""),
                                                onChanged:(text){
                                                    ref.read(inputCategoryTitle.notifier).state=text;
                                                }
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height:10),
                                Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children:[
                                        
                                        SizedBox(width:60),
                                        ElevatedButton(
                                            child:Text("決定"),
                                            onPressed:()async{
                                                if(ref.read(selectedAddCategory)!=1000 && ref.read(inputCategoryTitle).length>0 && !isEdit){
                                                    print(ref.read(inputCategoryTitle).length);
                                                    await insertNewCategory(ref);
                                                }else if(isEdit){
                                                    await updateCategoryData(ref);
                                                }
                                                ref.read(selectedAddCategory.notifier).state=1000;
                                                ref.read(inputCategoryTitle.notifier).state="";
                                                var newData=await queryAll("categories");
                                                ref.read(databaseCategoryNotifierProvider.notifier).updateData(newData);
                                                Navigator.of(context).pop();
                                            }
                                        ),
                                    ],
                                ),
                            ]
                        ),
                    ),
                ),
            ),
        );
    }
    List<Row> createIconsRow(List<List<IconData>> data,BuildContext context){
        return data.map((item){
            return Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children:item.map((icon){
                    return Container(
                        width:MediaQuery.of(context).size.width/6,
                        decoration:BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,  // ボーダーの色
                                width:1 ,  // ボーダーの太さ
                            ),
                        ),
                        child:IconButton(
                            icon:Icon(icon),
                            onPressed:(){
                                print("hi");
                            },
                        ),
                    );
                }).toList(),
            );
        }).toList();
    }
    List<TableRow> createTableRow(List<List<IconData>> data,WidgetRef ref){
        int iconIndex=0;
        return data.map((item){
            return TableRow(
                children:item.map((anicon){
                    final currentIconIndex = iconIndex;
                    iconIndex++;
                    return Container(
                        height:50,
                        child:IconButton(
                            color:ref.watch(selectedAddCategory)==currentIconIndex?Colors.red:Colors.black,
                            icon:Icon(anicon),
                            onPressed:(){
                                ref.read(selectedAddCategory.notifier).state=currentIconIndex;
                                print(ref.read(selectedAddCategory));
                            },
                        ),
                    );
                }).toList(),
            );
        }).toList();
    }
    Future<void> insertNewCategory(WidgetRef ref)async{
        await dbService.insert(
            "categories",
            {"type":ref.read(isOutcomeProvider)?"outcome":"income","name":ref.read(inputCategoryTitle),"categoriesid":ref.read(selectedAddCategory)},
        );
    }
    Future<void> updateCategoryData(WidgetRef ref)async{
        await dbService.update(
            "categories",
            {"type":ref.read(isOutcomeProvider)?"outcome":"income","name":ref.read(inputCategoryTitle),"categoriesid":ref.read(selectedAddCategory)},
            ref.read(selectedCategoryId),
        );
    }
    Future<List<Map<String,dynamic>>> queryAll(String table) async{
        final allRows = await dbService.queryAllRows(table);
        return allRows;
    }
}