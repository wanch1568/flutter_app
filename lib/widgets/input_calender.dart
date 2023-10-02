import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/view_models/select_date.dart';
import '/provider/riverpod_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '/widgets/my_table_calendar.dart';


class InputCalender extends ConsumerWidget{
    //DateTime now=DateTime.now();
    @override
    Widget build(BuildContext context,WidgetRef ref){
        //ref.read(selectedDate.notifier).state=DateFormat('yyyy-MM-dd').format(now);
        String formatDate=DateFormat('yyyy/MM/dd').format(ref.watch(selectedDate));
        
        return ElevatedButton(
            child:Text(formatDate),
            onPressed:(){
                showDialog(
                    context:context,
                    builder:(BuildContext context){
                        //final selectedDay = ref.watch(selectedDate);
                        ref.watch(calenderChanged);
                        
                        return Dialog(
                            child:Expanded(
                                child:SizedBox(
                                    height:MediaQuery.of(context).size.height/2,
                                    width:MediaQuery.of(context).size.width/1.2,
                                    child:MyTableCalendar(),
                                ),
                            ),
                        );
                    }
                );
            }
        );
        
    }
}