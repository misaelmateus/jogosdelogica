class QuestionData{
  String text;
  List<String> alternatives;
  int correctAlternative;

  QuestionData(String text, List<String> alternatives, int correctAlternative){
    this.text = text;
    this.alternatives = alternatives;
    this.correctAlternative = correctAlternative;
  }

  String getText() => this.text;
  List<String> getAlternatives() => alternatives;
  String textCorrectAlternative() => alternatives[correctAlternative];
}
