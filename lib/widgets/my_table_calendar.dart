import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/view_models/select_date.dart';
import '/provider/riverpod_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyTableCalendar extends ConsumerWidget{
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    int num=0;
    @override 
    Widget build(BuildContext context,WidgetRef ref){
        _focusedDay=ref.watch(selectedDate);
        _selectedDay=ref.watch(selectedDate);
        //ref.watch(calenderChanged);
        num+=1;
        print(num);
        print("changed!");
        return TableCalendar(
            locale: 'ja_JP',
            headerStyle: HeaderStyle(
                formatButtonVisible : false,
            ),
            shouldFillViewport:true,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
                //print(day.toString()+isSameDay(_selectedDay, day).toString());
                return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
                print(selectedDay);
                ref.read(selectedDate.notifier).state=selectedDay;
                print(focusedDay);
            },
            onPageChanged: (d) {
                ref.read(currentMonth.notifier).state=(d.year.toString()+"/"+(d.month).toString().padLeft(2, '0'));
                print(d.year.toString()+"/"+(d.month).toString().padLeft(2, '0'));
            },
            
        );
    }
}