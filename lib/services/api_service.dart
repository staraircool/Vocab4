import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  
  // Predefined word list for the app
  static const List<String> wordList = [
    'unfortunate',
    'resilient',
    'curious',
    'magnificent',
    'serendipity',
    'eloquent',
    'perseverance',
    'ephemeral',
    'ubiquitous',
    'mellifluous',
    'quintessential',
    'perspicacious',
    'benevolent',
    'audacious',
    'gregarious',
    'meticulous',
    'vivacious',
    'tenacious',
    'sagacious',
    'effervescent',
    'luminous',
    'harmonious',
    'exuberant',
    'tranquil',
    'innovative',
    'compassionate',
    'diligent',
    'authentic',
    'versatile',
    'profound'
  ];

  static Future<WordModel?> fetchWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$word'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return WordModel.fromJson(data[0]);
        }
      } else {
        print('Error fetching word: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching word definition: $e');
    }
    return null;
  }

  static Future<List<WordModel>> fetchMultipleWords(List<String> words) async {
    List<WordModel> wordModels = [];
    
    for (String word in words) {
      final wordModel = await fetchWordDefinition(word);
      if (wordModel != null) {
        wordModels.add(wordModel);
      }
      // Add a small delay to avoid overwhelming the API
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    return wordModels;
  }

  static String getRandomWord() {
    wordList.shuffle();
    return wordList.first;
  }

  static List<String> getWordBatch(int count) {
    List<String> shuffledWords = List.from(wordList);
    shuffledWords.shuffle();
    return shuffledWords.take(count).toList();
  }
}

