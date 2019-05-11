import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseUser user;
  int qtdQuizSolved = 0;

  _HomePageState(this.user);

  void _awaitSolveQuestion() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage(this.user)));
  }

  void _fetchQtdQuizSolved() async {
    Firestore.instance
        .collection('user')
        .document(this.user.uid)
        .collection('quiz')
        .where('done', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      setState(() {
        this.qtdQuizSolved = snapshot.documents.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchQtdQuizSolved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(this.user.photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(this.user.displayName, textScaleFactor: 1.8),
                      Text(this.user.email, textScaleFactor: 1.0),
                    ],
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    child: Text('${this.qtdQuizSolved}', textScaleFactor: 6.0),
                    padding: EdgeInsets.all(8.0)),
                Flexible(
                  child: Padding(
                    child: Text('Questões Resolvidas.', textScaleFactor: 2.0),
                    padding: EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
            Center(
              child: RaisedButton(
                child: const Text('Resolver!', textScaleFactor: 1.2),
                onPressed: () => _awaitSolveQuestion(),
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
      /*
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.network(this.user.photoUrl),
            Text("Olá ${this.user.displayName}."),
            RaisedButton(
                child: const Text('Resolver uma questão!'),
                onPressed: () => _awaitSolveQuestion()),
            Text(text)
          ],
        ),
      ),*/
    );
  }
}
