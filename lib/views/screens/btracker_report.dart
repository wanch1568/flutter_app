import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import '/services/database_service.dart';
import '/provider/riverpod_provider.dart';

class BtrackerReport extends ConsumerWidget {

    // DatabaseService クラスのインスタンス取得
    final dbService = DatabaseService.instance;

    // homepage layout
    @override
    Widget build(BuildContext context,WidgetRef ref) {
        var trData=ref.watch(databaseNotifierProvider);
        var ctData=ref.watch(databaseCategoryNotifierProvider);
        print(ctData[0]);
        return SizedBox(
            height:MediaQuery.of(context).size.height,
            child:SingleChildScrollView(
                child:Column(
                    children:[
                        Text(trData.toString()),
                        Container(
                            height:20,
                            color:Colors.red,
                        ),
                        Text(ctData.toString()),
                    ],
                ),
            ),
        );
    }
}

