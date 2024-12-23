class AIEnlighQuestion {
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  int? correctOptionIndex;
  bool option1Checked = false;
  bool option2Checked = false;
  bool option3Checked = false;
  bool option4Checked = false;

  AIEnlighQuestion.fromJson(Map<String, dynamic> json)
    : question = json['question'] as String,
      option1 = json['option1'] as String,
      option2 = json['option2'] as String,
      option3 = json['option3'] as String,
      option4 = json['option4'] as String,
      correctOptionIndex = json['correctOptionIndex'] as int;

  void resetChecked() {
    option1Checked = false;
    option2Checked = false;
    option3Checked = false;
    option4Checked = false;
  }

  bool isTrue() {
    switch (correctOptionIndex) {
      case 0:
        return option1Checked;
      case 1:
        return option2Checked;
      case 2:
        return option3Checked;
      case 3:
        return option4Checked;
      default:
        return false;
    }
  }
}

class GeminiContentPart {
  String? text;

  GeminiContentPart.fromJson(Map<String, dynamic> json)
    : text = json['text'] as String;
}

class GeminiContent {
  List<GeminiContentPart>? parts;

  GeminiContent();

  factory GeminiContent.fromJson(Map<String, dynamic> json) {
    var geminiContent = GeminiContent();

    List<dynamic> detailDynamics = json['parts'];
    var details =
        detailDynamics.map((e) => GeminiContentPart.fromJson(e)).toList();
    geminiContent.parts = details;

    return geminiContent;
  }
}

class GeminiCandidate {
  GeminiContent? content;

  GeminiCandidate.fromJson(Map<String, dynamic> json)
    : content = GeminiContent.fromJson(json['content']);
}

class GeminiResponse {
  List<GeminiCandidate>? candidates;

  GeminiResponse();

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    var geminiResponse = GeminiResponse();

    List<dynamic> detailDynamics = json['candidates'];
    var details =
        detailDynamics.map((e) => GeminiCandidate.fromJson(e)).toList();
    geminiResponse.candidates = details;

    return geminiResponse;
  }
}
