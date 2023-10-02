import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/provider/riverpod_provider.dart';

class EditFooter extends ConsumerWidget{
    
    List<EditNavBarItem> labels;
    EditFooter(this.labels);
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
                ref.read(btrackerPageIndex.notifier).state=1;
                ref.read(isEditing.notifier).state=false;
            },
            currentIndex:ref.watch(btrackerPageIndex),
        );
    }
}

class EditNavBarItem{
    final String label;
    final IconData icon;

    EditNavBarItem(this.label,this.icon);
}