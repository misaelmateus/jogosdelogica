import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jogosdelogica/main.dart';

import 'quizPage.dart';

class HomePage extends StatefulWidget {
  final String title;
  final FirebaseUser user;

  HomePage(this.user, {Key key, this.title = MyApp.AppTitle}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(this.user);
}

class _HomePageState extends State<HomePage> {
  String text = "Não resolveu nenhum questão";
  final FirebaseUser user;

  _HomePageState(this.user);

  void _awaitSolveQuestion() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage()));

    setState(() {
      text = result ?? text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: const Text('Resolver Questão'),
                onPressed: () => _awaitSolveQuestion()),
            Text(text)
          ],
        ),
      ),
    );
  }
}
