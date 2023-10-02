import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import '/services/database_service.dart';

class BtrackerOther extends ConsumerWidget {
    // DatabaseService クラスのインスタンス取得
    final dbService = DatabaseService.instance;

    // homepage layout
    @override
    Widget build(BuildContext context,WidgetRef ref) {
        return Center(
            child:TextField(),
        );
    }
}

