import 'package:flutter/material.dart';

import '/views/screens/btracker_main.dart';



class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ルートの設定情報を取得する
    print(settings.name);
    final args = settings.arguments;
    print("generating");
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
          pageBuilder: (context,anim1,anim2) => BtrackerMain(),
          transitionDuration:Duration(seconds:0),
        );
      case '/btracker_main':
        return PageRouteBuilder(
          pageBuilder:(context,anim1,anim2)=>BtrackerMain(),
          transitionDuration:Duration(seconds:0),
        );
      /*case '/hikisu':
        // 引数が必要なルートの例
        if (args is String) {
          //return _errorRoute();
          return PageRouteBuilder(
            pageBuilder: (context,anim1,anim2) => HikisuScreen(
              data: args,
            ),
            transitionDuration:Duration(seconds:0),
          );
        }
        // 引数がエラーの場合の処理
        return _errorRoute();*/
      case '/screen3':
      //  return MaterialPageRoute(builder: (_) => Screen3());
        return _errorRoute();
      default:
        // 名前のないルートに対する処理
        return _errorRoute();
    }
  }
 

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
