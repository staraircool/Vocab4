import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_model.dart';

class LocalStorageService {
  static const String _learnedWordsKey = 'learned_words';
  static const String _learnedCountKey = 'learned_count';

  static Future<void> saveLearnedWord(WordModel word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> learnedWords = prefs.getStringList(_learnedWordsKey) ?? [];
      
      // Check if word is already saved
      bool alreadyExists = false;
      for (String wordJson in learnedWords) {
        Map<String, dynamic> wordMap = json.decode(wordJson);
        if (wordMap['word'] == word.word) {
          alreadyExists = true;
          break;
        }
      }
      
      if (!alreadyExists) {
        word.isLearned = true;
        learnedWords.add(json.encode(word.toJson()));
        await prefs.setStringList(_learnedWordsKey, learnedWords);
        await _updateLearnedCount();
      }
    } catch (e) {
      print('Error saving learned word: $e');
    }
  }

  static Future<void> removeLearnedWord(String word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> learnedWords = prefs.getStringList(_learnedWordsKey) ?? [];
      
      learnedWords.removeWhere((wordJson) {
        Map<String, dynamic> wordMap = json.decode(wordJson);
        return wordMap['word'] == word;
      });
      
      await prefs.setStringList(_learnedWordsKey, learnedWords);
      await _updateLearnedCount();
    } catch (e) {
      print('Error removing learned word: $e');
    }
  }

  static Future<List<WordModel>> getLearnedWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> learnedWords = prefs.getStringList(_learnedWordsKey) ?? [];
      
      return learnedWords.map((wordJson) {
        Map<String, dynamic> wordMap = json.decode(wordJson);
        return WordModel.fromStoredJson(wordMap);
      }).toList();
    } catch (e) {
      print('Error getting learned words: $e');
      return [];
    }
  }

  static Future<bool> isWordLearned(String word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> learnedWords = prefs.getStringList(_learnedWordsKey) ?? [];
      
      for (String wordJson in learnedWords) {
        Map<String, dynamic> wordMap = json.decode(wordJson);
        if (wordMap['word'] == word) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking if word is learned: $e');
      return false;
    }
  }

  static Future<int> getLearnedWordsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_learnedCountKey) ?? 0;
    } catch (e) {
      print('Error getting learned words count: $e');
      return 0;
    }
  }

  static Future<void> _updateLearnedCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> learnedWords = prefs.getStringList(_learnedWordsKey) ?? [];
      await prefs.setInt(_learnedCountKey, learnedWords.length);
    } catch (e) {
      print('Error updating learned count: $e');
    }
  }

  static Future<void> clearAllLearnedWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_learnedWordsKey);
      await prefs.remove(_learnedCountKey);
    } catch (e) {
      print('Error clearing learned words: $e');
    }
  }
}

