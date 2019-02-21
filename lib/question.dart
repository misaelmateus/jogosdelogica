class QuestionData {
  String text;
  List<String> alternatives;
  int correctAlternative;
  int chosed;
  QuestionData(String text, List<String> alternatives, int correctAlternative){
    this.text = text;
    this.alternatives = alternatives;
    this.correctAlternative = correctAlternative;
    this.chosed = -1;
  }

  String getText() => this.text;
  List<String> getAlternatives() => alternatives;
  String textCorrectAlternative() => alternatives[correctAlternative];
  void setChosed(int i){
    this.chosed = i;
  }
}
