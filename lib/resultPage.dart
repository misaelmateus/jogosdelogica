import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int numSolved;
  final int numQuestions;

  static const int SEE_RESULT_MESSAGE = 9998, NEW_QUIZ_MESSAGE = 9999;

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
                    Navigator.pop(context, SEE_RESULT_MESSAGE);
                  },
                ),
                RaisedButton(
                  child: Text("Chat da Questão"),
                  onPressed: () => null,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            RaisedButton(
              child: Text("Próxima Questão"),
              onPressed: () {
                    Navigator.pop(context, NEW_QUIZ_MESSAGE);
                  },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )));
  }
}
