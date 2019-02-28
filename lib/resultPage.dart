import 'package:flutter/material.dart';
import 'quiz.dart';
import 'question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatelessWidget {
  final int numSolved;
  final int numQuestions;

  ResultPage({this.numSolved, this.numQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text(
                "Você acertou " +
                    this.numSolved.toString() +
                    " de " +
                    this.numQuestions.toString() +
                    " questões",
                style: TextStyle(fontSize: 18)),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Ver solução"),
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                ),
                RaisedButton(
                  child: Text("Chat da Questão"),
                  onPressed: () => (1),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            RaisedButton(
              child: Text("Próxima Questão"),
              onPressed: () {
                    Navigator.pop(context, 1);
                  },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )));
  }
}
