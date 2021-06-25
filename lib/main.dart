import 'package:flutter/material.dart';
import 'package:gps/firebase/auntenticacion.dart';
import 'package:gps/homes/inicio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Inicio a = Inicio();
  late String m = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(m);
    return MaterialApp(
      home: FutureBuilder(
        future: Autenticacion.initializeFirebase(context: context),
        builder: (context, snap) {
          if (snap.hasData)
            return Inicio();
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
