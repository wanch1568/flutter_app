import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '/widgets/result_list.dart';
import '/widgets/my_table_calendar.dart';



class BtrackerCalender extends ConsumerWidget{
    @override
    Widget build(BuildContext context,WidgetRef ref){
        return Center(
            child:Column(
                children:[
                    //Expanded(
                    SizedBox(
                        height:300,
                        child:MyTableCalendar(),
                    ),
                    //),
                    ResultList(),
                ],
            ),
        );
    }
}