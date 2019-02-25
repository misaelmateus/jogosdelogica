import 'question.dart';

class QuizData {
  String title, text;
  List<QuestionData> questions;
  QuizData(String title, String text, List<QuestionData> questions){
    this.title = title;
    this.text = text;
    this.questions = questions;
  }

  int lenght() => questions.length;
  int chosed(int index) => questions[index].chosed;
  String textQuestion(int index) => questions[index].text;
  String getText() => this.text;
  int correctAlternative(int index) => questions[index].correctAlternative;
  QuestionData getQuestion(int index) => questions[index];

}
