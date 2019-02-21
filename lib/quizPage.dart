import 'package:flutter/material.dart';
import 'quiz.dart';
import 'question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  @override
  QuizData data;
  _QuizPageState createState() {
    // TODO: implement createState


    return _QuizPageState();
  }

}

class _QuizPageState extends State<QuizPage> {

  void _onButtonQuestionPressed(){

  }
  
  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  void fetchQuizData() {
    Firestore.instance.collection('quiz').limit(1).snapshots()
      .listen((data) {
        var doc = data.documents.first;
        print(doc);

        List<QuestionData> questions = [];
        for (var q in doc['question']) {
          List<String> alternatives = [];
          for (var a in q['alternative']) {
            alternatives.add(a);
          }
          QuestionData questionData = QuestionData(q['text'], alternatives, q['correctAlternative']);
          questions.add(questionData);
        }

        setState(() {
          widget.data = QuizData(doc['title'], doc['text'], questions);
        });
      });
  }

  @override
  Widget build(BuildContext context, ) {
    if (widget.data == null) {
      // retorna progress indicator
      return Scaffold(
          appBar: AppBar(
            title: Text("Resolver Questão"),
            automaticallyImplyLeading: false,
          ),
          body: Center(
              child: CircularProgressIndicator(value: null)
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Resolver Questão"),
        automaticallyImplyLeading: false,
      ),
      body:
        ListView.builder(
            itemCount: widget.data.lenght()+2,
            itemBuilder: (context, index) => Card(
              color: index == 0 ? Colors.grey[200] : Colors.white,
              elevation: index <= widget.data.lenght() ? 1.0 + (index == 0 ? 1.0 : 0.0) : 0.0,
              child:
                index == widget.data.lenght()+1
                  ? Center(
                      child:RaisedButton(
                        child: Text("Avançar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        onPressed: (() =>_onButtonQuestionPressed()),
                        color: Colors.blue,
                      )
                    )
                  : index == 0 ? StatementTile(questionData : widget.data)
                  : QuestionTile(questionData : widget.data, index: index)

          )
    ));
  }

}

class QuestionTile extends StatelessWidget {
  final QuizData questionData;
  final int index;
  QuestionTile({this.questionData, this.index});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    questionData.textQuestion(index-1),
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        decorationColor: Colors.black12
                    ),
                  ),
                ]
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Text(String.fromCharCode(index + 48)),
          ),
          children: [AnswerWidget(questionData.getQuestion(index-1))]
      );
  }

}
class StatementTile extends StatelessWidget {
  final QuizData questionData;

  StatementTile({this.questionData});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
              children:[
                Text(
                  "Enunciado",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      decorationColor: Colors.black12
                  ),
                ),
                StatementWidget(quizData: this.questionData)
              ]
            )
        ),
     );
  }


}
class StatementWidget extends StatelessWidget {
  final QuizData quizData;
  @override
  StatementWidget({this.quizData});
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        child:Text(quizData.getText(), style: TextStyle(fontSize: 15))
    );
  }

}


class AnswerWidget extends StatefulWidget {
  final QuestionData questionData;
  AnswerWidget(this.questionData);

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = new List<Widget>();
    List<String> alternatives = widget.questionData.getAlternatives();
    for(var i = 0; i < alternatives.length; i++){
      print(alternatives[i]);
      tiles.add(
            ListTile(
              onTap: () {
                setState(() {
                  widget.questionData.setChosed(i);
                });
              },
              title: Text(
                alternatives[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: i == widget.questionData.chosed ? Colors.blue : Colors.black,

                ),
              ),
            )

      );
      if(i + 1 != alternatives.length)
        tiles.add(Divider());
    }
    return Column(
        children: tiles
    );
  }
}