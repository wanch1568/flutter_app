import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/services/database_service.dart';
import '/provider/riverpod_provider.dart';
import '/constants/icons.dart';
import "package:intl/intl.dart";



class ResultList extends ConsumerWidget{
    final _controller =ScrollController();
    @override
    Widget build(BuildContext context,WidgetRef ref){
        
        var transactionsData=ref.watch(databaseNotifierProvider);
        var categoriesData=ref.watch(databaseCategoryNotifierProvider);
        //var initData=ref.watch(initialDataProvider);
        //print(categoriesData);
        print("transactionsData="+transactionsData.toString());
        print("categoriesData="+categoriesData.toString());
        
        if (transactionsData == null || transactionsData.isEmpty) {
            //return CircularProgressIndicator(); // データ取得中はローディング表示
            return SizedBox(height:100);
        } else {
            return Expanded(
                child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                        controller:_controller,
                        child: Column(
                            children: getResult(context, ref, transactionsData,categoriesData),
                        ),
                    ),
                ),
            );
        }
    }
    List<Container> getResult(BuildContext context,WidgetRef ref,List<Map<String,dynamic>> data,List<Map<String,dynamic>> categoriesData){
        var sortedData=List.from(data);
        var modifiedData=[];
        var tmpDate="";
        num sum=0;
        sortedData.sort((a, b) {
            DateTime dateA = DateTime.parse(a['date'].replaceAll('/', '-'));
            DateTime dateB = DateTime.parse(b['date'].replaceAll('/', '-'));
            return dateB.compareTo(dateA);
        });
        var filteredData = sortedData
            .where((element) => element["date"].startsWith(ref.watch(currentMonth)))
            .toList();
        print(filteredData);
        filteredData.forEach((item){
            if(tmpDate!=item["date"]){
                modifiedData.add({"type":"label","date":item["date"]});
                tmpDate=item["date"];
            }
            if(item["type"]=="income"){
                sum+=item["amount"];
            }else{
                sum-=item["amount"];
            }
            modifiedData.add(item);
        });
        print(sum.toInt());
        modifiedData.insert(0,{"type":"sum","total":sum.toInt()});
        // 結果の表示
       

        //print("sorteddata:"+sortedData.toString());
        return modifiedData.map(
            (item){
                if(item["type"]=="label"){
                    return Container(
                        
                        /*decoration:BoxDecoration(
                            border: Border(
                                bottom:BorderSide(color: Colors.black, width:1),
                            ),
                        ),*/
                        height:30,
                        color:Colors.grey,
                        child:Row(
                            children:[
                                Text(item["date"]),
                            ],
                        ),
                    );
                }else if(item["type"]=="sum"){
                    return Container(
                        height:30,
                        decoration:BoxDecoration(
                            border:Border.all(
                                color:Colors.black,
                                width:1,
                            ),
                        ),
                        child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children:[
                                Text("収支"),
                                Text(
                                    item["total"].toString()+"円",
                                    style:TextStyle(color:item["total"]>0?Colors.blue:item["total"]<0?Colors.red:Colors.black,fontWeight:FontWeight.bold),
                                ),
                            ]
                        ),
                    );
                }else{
                    var category=categoriesData.firstWhere(
                        (i) => i['id'] == item["categoryId"], 
                        orElse: () => {"id":"0","type":ref.read(isOutcomeProvider)?"outcome":"income","name":"カテゴリー未設定","categoriesid":0},
                    );
                    //print("category="+category.toString());
                    return Container(
                        decoration:BoxDecoration(
                            border: Border(
                                bottom:BorderSide(color: Colors.black, width:1),
                            ),
                        ),
                        height:50,
                        child:GestureDetector(
                            child:Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children:[
                                    Row(
                                        children:[
                                            Icon(IconList.iconList[category["categoriesid"]]),
                                            Text(category["name"],style:TextStyle(fontSize:16,fontWeight:FontWeight.bold)),
                                            Text(":"+item["title"].toString(),style:TextStyle(fontSize:14)),
                                        ]
                                    ),
                                    Text((item["type"]=="outcome"?"-":"+")+"${item["amount"].toInt().toString()}円",style:TextStyle(fontSize:20,color:item["type"]=="outcome"?Colors.red:Colors.blue)),
                                ],
                            ),
                            onTap:(){
                                ref.read(isOutcomeProvider.notifier).state=item["type"]=="outcome"?true:false;
                                ref.read(selectedDate.notifier).state=DateFormat("y/M/d").parseStrict(item["date"]);
                                ref.read(inputTitle.notifier).state=item["title"];
                                ref.read(inputAmount.notifier).state=item["amount"].toInt();
                                ref.read(selectedCategoryId.notifier).state=item["categoryId"];
                                ref.read(selectedTransactionId.notifier).state=item["id"];
                                ref.read(btrackerPageIndex.notifier).state=0;
                                ref.read(isEditing.notifier).state=true;
                            }
                        ),
                    );
                }
            }
        ).toList();
    }
}