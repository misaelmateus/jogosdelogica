import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quizPage.dart';
import 'loginPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String text = "Não resolveu nenhum questão";
  FirebaseUser user;


  void _awaitSolveQuestion() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage()));

    setState(() {
      text = result ?? text;
    });
  }

  void _awaitLogin() async {
    print("Cheguei no login");
    this.user = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                onPressed: () {
                  _awaitSolveQuestion();
                }),
            Text(text)
          ],
        ),
      ),
    );
  }
}