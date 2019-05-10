import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'question.dart';
import 'quiz.dart';
import 'resultPage.dart';

class QuizPage extends StatefulWidget {
  final FirebaseUser user;

  QuizPage(this.user);

  @override
  _QuizPageState createState() {
    return _QuizPageState(this.user);
  }
}

class _QuizPageState extends State<QuizPage> {
  QuizData data;
  int lock = 0;
  FirebaseUser user;

  _QuizPageState(this.user);

  void _onButtonQuestionSolved() async {
    int numSolved = 0, numQuestions = this.data.questions.length;
    for (var i = 0; i < numQuestions; i++) {
      if (this.data.questions[i].chosed ==
          this.data.questions[i].correctAlternative) numSolved++;
    }

    if (this.lock == 0) {
      // Update database of quizzes the user done

      final userDoc =
      Firestore.instance.collection('user').document(this.user.uid);
      Firestore.instance.runTransaction((Transaction ts) async {
        var userSnapshot = await ts.get(userDoc);
        if (userSnapshot.exists) {
          final quizAttempt = userSnapshot.data['quizAttempt'] ?? {};
          final countQuiz = quizAttempt[this.data.uid] ?? 0;

          await ts.update(
              userDoc,
              (() =>
              numSolved == numQuestions
                  ? {
                'quizAttempt': {
                  this.data.uid: countQuiz + 1,
                }
              }
                  : {
                'quizAttempt': {
                  this.data.uid: countQuiz + 1,
                },
                'quizDone': {
                  this.data.uid: true,
                },
              })());
        }
      });
    }

    lock = 1;

    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultPage(numSolved: numSolved, numQuestions: numQuestions)));

    setState(() {
      if (result == ResultPage.NEW_QUIZ_MESSAGE) {
        this.data = null;
        this.lock = 0;
        fetchQuizData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  void fetchQuizData() {
    fetchRandomQuiz().then((doc) {
      List<QuestionData> questions = [];
      for (var q in doc['question']) {
        List<String> alternatives = [];
        for (var a in q['alternative']) {
          alternatives.add(a);
        }
        QuestionData questionData =
        QuestionData(q['text'], alternatives, q['correctAlternative']);
        questions.add(questionData);
      }

      setState(() {
        this.data =
            QuizData(doc.documentID, doc['title'], doc['text'], questions);
      });
    });
  }

  Future<DocumentSnapshot> fetchRandomQuiz() async {
    var query = await Firestore.instance
        .collection('quiz')
        .orderBy('order', descending: true)
        .limit(1)
        .getDocuments();

    if (query.documents.isEmpty) {
      return null;
    }

    var maxOrder = query.documents.first['order'];

    var random = Random();
    var rnd = random.nextInt(maxOrder);

    query = await Firestore.instance
        .collection('quiz')
        .where('order', isGreaterThan: rnd)
        .orderBy('order')
        .limit(1)
        .getDocuments();

    if (query.documents.isNotEmpty) {
      return query.documents.first;
    }

    query = await Firestore.instance
        .collection('quiz')
        .where('order', isLessThanOrEqualTo: rnd)
        .orderBy('order', descending: true)
        .limit(1)
        .getDocuments();

    if (query.documents.isNotEmpty) {
      return query.documents.first;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (this.data == null) {
      // retorna progress indicator
      return Scaffold(
          appBar: AppBar(
            title: Text("Resolver Questão"),
            automaticallyImplyLeading: false,
          ),
          body: Center(child: CircularProgressIndicator(value: null)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Resolver Questão"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: this.data.lenght() + 1,
                  itemBuilder: (context, index) => Card(
                      color: index == 0 ? Colors.grey[200] : Colors.white,
                      elevation: index <= this.data.lenght()
                          ? 1.0 + (index == 0 ? 1.0 : 0.0)
                          : 0.0,
                      child: index == 0
                          ? StatementTile(questionData: this.data)
                          : QuestionTile(
                          questionData: this.data,
                          index: index,
                          lock: this.lock)))),
          Container(
            child: FlatButton(
              child: Text("Avançar",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: (() => _onButtonQuestionSolved()),
              color: Colors.lightBlueAccent,
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: Border(),
            ),
            width: double.infinity,
            color: Colors.lightBlueAccent,
          )
        ],
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}

class QuestionTile extends StatelessWidget {
  final QuizData questionData;
  final int index;
  final int lock;

  QuestionTile({this.questionData, this.index, this.lock = 0});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  questionData.textQuestion(index - 1),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      decorationColor: Colors.black12),
                ),
              ]),
        ),
        leading: CircleAvatar(
          backgroundColor: this.lock == 1
              ? (this.questionData.correctAlternative(index - 1) ==
              this.questionData.chosed(index - 1)
              ? Colors.greenAccent
              : Colors.redAccent[200])
              : Colors.grey[100],
          child: Text(String.fromCharCode(index + 48)),
        ),
        children: [
          AnswerWidget(
              questionData: questionData.getQuestion(index - 1),
              lock: this.lock)
        ]);
  }
}

class StatementTile extends StatelessWidget {
  final QuizData questionData;

  StatementTile({this.questionData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(children: [
            Text(
              "Enunciado",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  decorationColor: Colors.black12),
            ),
            StatementWidget(quizData: this.questionData)
          ])),
    );
  }
}

class StatementWidget extends StatelessWidget {
  final QuizData quizData;

  @override
  StatementWidget({this.quizData});

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Text(quizData.getText(), style: TextStyle(fontSize: 15)));
  }
}

class AnswerWidget extends StatefulWidget {
  final QuestionData questionData;
  final int lock;

  AnswerWidget({this.questionData, this.lock});

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = new List<Widget>();
    List<String> alternatives = widget.questionData.getAlternatives();
    for (var i = 0; i < alternatives.length; i++) {
      print(alternatives[i]);
      Color alternativeColor;
      if (widget.lock == 0) {
        if (widget.questionData.chosed == i)
          alternativeColor = Colors.blue;
        else
          alternativeColor = Colors.black;
      } else {
        if (widget.questionData.correctAlternative == i)
          alternativeColor = Colors.green;
        else if (widget.questionData.chosed == i)
          alternativeColor = Colors.red;
        else
          alternativeColor = Colors.black;
      }
      tiles.add(ListTile(
        onTap: () {
          setState(() {
            widget.questionData.setChosed(i);
          });
        },
        enabled: widget.lock == 0,
        title: Text(
          alternatives[i],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: alternativeColor,
          ),
        ),
      ));
      if (i + 1 != alternatives.length) tiles.add(Divider());
    }
    return Column(children: tiles);
  }
}
