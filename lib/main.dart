import 'package:flutter/material.dart';
import '/routes/route_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  
  //↓windowsで起動するときだけ必要  
  /*sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;*/
  //↑スマホエミュでテストするときやアプリリリース時はいらない
  runApp(
    ProviderScope(
      child:MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref){
    return MaterialApp(
      localizationsDelegates:[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales:[
        const Locale('ja'),
      ],
      locale:const Locale('ja'),
      title:'Flutter Demo',
      theme:ThemeData(
        primarySwatch:Colors.orange,
        //colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.orange),
      ),
      initialRoute:'/',
      onGenerateRoute:RouteGenerator.generateRoute,
    );
  }
}
