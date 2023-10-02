import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/services/database_service.dart';
import '/provider/riverpod_provider.dart';
import '/constants/icons.dart';
import '/widgets/add_category.dart';


final dbService=DatabaseService.instance;
final dataProvider = FutureProvider<List<Map<String,dynamic>>>((ref) => queryAll("categories"));
class CreateCategories extends ConsumerWidget{
    @override
    Widget build(BuildContext context,WidgetRef ref){
        var categoryData=ref.watch(databaseCategoryNotifierProvider);
        //print("categoryData="+categoryData.toString());
        var asyncData=ref.watch(dataProvider);
        bool isOutcome=ref.watch(isOutcomeProvider);
        List<List<Map<String,dynamic>>> rowElements=[];
        List<List<Map<String,dynamic>>> rowElements2=[];
        //final rows = ["Text1","Text2","Text3","Text4","Text5","Text6","Text7","Text8","Text9","Text10",];
        //final rows1=queryAll("categories");
        
        
        
        
        //[Row(children:[Text(),Text()]),Row(children:[Text(),Text()],)]
        
        //print(categoryData);
        categoryData=isOutcome?categoryData.where((item) => item["type"] == "outcome").toList():categoryData.where((item) => item["type"] == "income").toList();
        final stringData=categoryData.map((item)=>item["name"]).toList();
        
        stringData.asMap().forEach((index,value){
            if(index%4==0){
                rowElements.add([]);
            }
            rowElements[rowElements.length-1].add({index.toString():value});
        });
        categoryData.asMap().forEach((index,value){
            if(index%4==0){
                rowElements2.add([]);
            }
            rowElements2[rowElements2.length-1].add(value);
        });
        //print("row1=:"+rowElements.toString());
        //print("row2="+rowElements2.toString());
        return SizedBox(
            height:300,
            width:double.infinity,
            child:SingleChildScrollView(
                child:Column(
                    
                    children:createContainer(rowElements2,context,ref),
                ),
            ),
        );
        
    }
    List<Container> createContainer(List<List<Map<String,dynamic>>> rowElements,BuildContext context,WidgetRef ref){
        List<Container> rowChildren=rowElements.map((elementsList)=>Container(
            margin:EdgeInsets.only(bottom:10),
            child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children:elementsList.map((element){
                    //var entry = element.entries.single;
                    return GestureDetector(
                        onTap:() {
                            if(ref.read(selectedCategoryId.notifier).state==element["id"]){
                                ref.read(selectedAddCategory.notifier).state=element["categoriesid"];
                                ref.read(inputCategoryTitle.notifier).state=element["name"];
                                showDialog<void>(
                                    context: context,
                                        builder: (_) {
                                            
                                            return AddCategory(isEdit:true);
                                    });
                            }else{
                                ref.read(selectedCategoryId.notifier).state=element["id"];
                            }
                            //print(ref.read(selectedCategoryId));
                        },
                        child:Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0), 
                                border: Border.all(
                                    color:ref.watch(selectedCategoryId)==element["id"]?Colors.blue:Colors.black,
                                    width:ref.watch(selectedCategoryId)==element["id"] ?2:0, // 枠線の太さを指定します。
                                ),
                            ),
                            width: MediaQuery.of(context).size.width/5,
                            height:50,
                            child:Column(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children:[
                                    Icon(IconList.iconList[element["categoriesid"]]),
                                    Text(element["name"].length<6?element["name"]:element["name"].substring(0,5)+"...",style:TextStyle(fontSize:12)),
                                ]
                            ),
                            
                        ),
                    );
                }).toList()
            )
        ),).toList();
        //print(rowChildren);
        return rowChildren;
    }
}
Future<List<Map<String,dynamic>>> queryAll(String table) async{
    final allRows = await dbService.queryAllRows(table);
    return allRows;
}