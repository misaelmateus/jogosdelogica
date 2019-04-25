import 'question.dart';

class QuizData {
  String uid, title, text;
  List<QuestionData> questions;

  QuizData(this.uid, this.title, this.text, this.questions);

  int lenght() => questions.length;
  int chosed(int index) => questions[index].chosed;
  String textQuestion(int index) => questions[index].text;
  String getText() => this.text;
  int correctAlternative(int index) => questions[index].correctAlternative;
  QuestionData getQuestion(int index) => questions[index];

}
