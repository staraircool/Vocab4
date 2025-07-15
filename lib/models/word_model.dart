class WordModel {
  final String word;
  final String phonetic;
  final String definition;
  final String? example;
  final List<String> synonyms;
  bool isLearned;

  WordModel({
    required this.word,
    required this.phonetic,
    required this.definition,
    this.example,
    required this.synonyms,
    this.isLearned = false,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    String phonetic = '';
    String definition = '';
    String? example;
    List<String> synonyms = [];

    // Extract phonetic
    if (json['phonetics'] != null && json['phonetics'].isNotEmpty) {
      for (var phoneticData in json['phonetics']) {
        if (phoneticData['text'] != null && phoneticData['text'].isNotEmpty) {
          phonetic = phoneticData['text'];
          break;
        }
      }
    }

    // Extract definition, example, and synonyms
    if (json['meanings'] != null && json['meanings'].isNotEmpty) {
      var meaning = json['meanings'][0];
      if (meaning['definitions'] != null && meaning['definitions'].isNotEmpty) {
        var definitionData = meaning['definitions'][0];
        definition = definitionData['definition'] ?? '';
        example = definitionData['example'];
      }
      
      // Extract synonyms
      if (meaning['synonyms'] != null) {
        synonyms = List<String>.from(meaning['synonyms']);
      }
    }

    return WordModel(
      word: json['word'] ?? '',
      phonetic: phonetic,
      definition: definition,
      example: example,
      synonyms: synonyms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic': phonetic,
      'definition': definition,
      'example': example,
      'synonyms': synonyms,
      'isLearned': isLearned,
    };
  }

  factory WordModel.fromStoredJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'],
      synonyms: List<String>.from(json['synonyms'] ?? []),
      isLearned: json['isLearned'] ?? false,
    );
  }
}

