import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/view_models/create_categories.dart';

class InputCategories extends ConsumerWidget{
    @override
    Widget build(BuildContext context,WidgetRef ref){
        return Container(
            child:Column(
                children:[
                    CreateCategories(),
                ]
            ),
        );
    }
}