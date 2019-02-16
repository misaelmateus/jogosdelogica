import 'package:flutter/material.dart';
import 'quiz.dart';
import 'question.dart';

class quizPage extends StatefulWidget {
  @override
  QuizData data;
  _quizPageState createState() {
    // TODO: implement createState


    return _quizPageState();
  }

}

class _quizPageState extends State<quizPage> {
  QuizData questionData;

  void _onButtonQuestionPressed(){

  }

  @override
  Widget build(BuildContext context, ) {
    if(widget.data == null) {
      List<QuestionData> list = new List<QuestionData>();
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));
      list.add(new QuestionData(
          'Quantas viagens são necessárias para o pirata levar todas as arcas para a ilha secreta?',
          ['1', '2', '3', '4', '5'], 2));

      widget.data = new QuizData("Titulo",
          "Um pirata quer transportar, do seu navio para a sua ilha secreta, quatro arcas repletas de tesouros roubados: uma arca com Diamantes, uma arca com Esmeraldas, uma arca com Moedas de Ouro e uma arca com Moedas de Prata. Cada uma das arcas pesa 80 quilos, e o valor das arcas são diferentes entre si, sendo que a arca com Diamantes é a mais valiosa, seguida da arca com Esmeraldas, seguida da arca com Moedas de Ouro, seguida da arca com Moedas de Prata, que é a menos valiosa. O pirata tem apenas um barquinho para levar as arcas do navio para a ilha, e existem duas restrições:\n• o barquinho pode carregar, além do pirata, no máximo 200 quilos.\n• as arcas estão lacradas e não podem ser abertas; assim, o pirata deve levar a arca inteira no barquinho ou não levar a arca.\nNas questões abaixo, considere que uma viagem compreende o trajeto navio-ilha-navio.",
          list);
    }
    questionData = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text("Resolver Questão"),
        automaticallyImplyLeading: false,
      ),
      body:
            ListView.builder(
            itemCount: questionData.lenght()+2,
            itemBuilder: (context, index) => Card(
              color: index == 0 ? Colors.cyan : Colors.white,
              elevation: index <= questionData.lenght() ? 1.0 : 0.0,
              child:
                index == questionData.lenght()+1
                  ? Center(
                      child:RaisedButton(
                        child: Text("Avançar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        onPressed: (() =>_onButtonQuestionPressed()),
                        color: Colors.blue,
                      )
                    )

                  : ExpansionTile(
                    title: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            index == 0 ? "Enunciado" : questionData.textQuestion(index-1),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal
                            ),
                          ),
                          ]
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: index == 0 ? Text("Q") : Text(String.fromCharCode(index + 48)),
                    ),
                    children: (index == 0 ?
                        [StatementWidget(quizData: this.questionData)] :
                        [AnswerWidget(questionData.getQuestion(index-1))] )
                  ),
              ),
          )
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