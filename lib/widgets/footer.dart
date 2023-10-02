import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/provider/riverpod_provider.dart';
import 'package:intl/intl.dart';

class Footer extends ConsumerWidget{
    
    List<NavBarItem> labels;
    Footer(this.labels);
    @override
    Widget build(BuildContext context,WidgetRef ref){
        return BottomNavigationBar(
            type:BottomNavigationBarType.fixed,
            items:labels.map((item){
                return BottomNavigationBarItem(
                    label:item.label,
                    icon:Icon(item.icon),
                );
            }).toList(),
            onTap: (index) {
                ref.read(selectedDate.notifier).state=DateTime.now();
                ref.read(btrackerPageIndex.notifier).state=index;
                ref.read(apptitle.notifier).state=labels[index].label;
                ref.read(currentMonth.notifier).state=DateFormat('yyyy/MM').format(DateTime.now());
            },
            currentIndex:ref.watch(btrackerPageIndex),
        );
    }
}

class NavBarItem{
    final String label;
    final IconData icon;

    NavBarItem(this.label,this.icon);
}