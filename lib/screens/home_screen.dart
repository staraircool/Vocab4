import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/word_card.dart';
import 'learned_words_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();
  List<WordModel> words = [];
  bool isLoading = true;
  int learnedCount = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWords();
    _updateLearnedCount();
  }

  Future<void> _loadWords() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get a batch of words from the predefined list
      final wordBatch = ApiService.getWordBatch(10);
      final fetchedWords = await ApiService.fetchMultipleWords(wordBatch);
      
      if (mounted) {
        setState(() {
          words = fetchedWords;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading words: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateLearnedCount() async {
    final count = await LocalStorageService.getLearnedWordsCount();
    if (mounted) {
      setState(() {
        learnedCount = count;
      });
    }
  }

  Future<void> _loadMoreWords() async {
    try {
      // Load more words when running low
      final wordBatch = ApiService.getWordBatch(5);
      final newWords = await ApiService.fetchMultipleWords(wordBatch);
      
      if (mounted) {
        setState(() {
          words.addAll(newWords);
        });
      }
    } catch (e) {
      print('Error loading more words: $e');
    }
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // Load more words when getting close to the end
    if (currentIndex != null && currentIndex >= words.length - 2) {
      _loadMoreWords();
    }
    
    setState(() {
      this.currentIndex = currentIndex ?? 0;
    });
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'VocabPro',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8845D1),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8845D1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Color(0xFF8845D1),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$learnedCount',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8845D1),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LearnedWordsScreen(),
                ),
              );
              _updateLearnedCount();
            },
            icon: const Icon(
              Icons.list,
              color: Color(0xFF8845D1),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8845D1),
              ),
            )
          : words.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No words available',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWords,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8845D1),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Progress indicator
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Card ${currentIndex + 1} of ${words.length}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Swipe to continue',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Card swiper
                    Expanded(
                      child: CardSwiper(
                        controller: controller,
                        cardsCount: words.length,
                        onSwipe: _onSwipe,
                        numberOfCardsDisplayed: 2,
                        backCardOffset: const Offset(0, -20),
                        padding: const EdgeInsets.all(16),
                        cardBuilder: (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                        ) {
                          return WordCard(
                            word: words[index],
                            onHeartTapped: _updateLearnedCount,
                          );
                        },
                      ),
                    ),
                    
                    // Control buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            heroTag: "previous",
                            onPressed: () {
                              controller.swipe(CardSwiperDirection.left);
                            },
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.grey,
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: "refresh",
                            onPressed: _loadWords,
                            backgroundColor: const Color(0xFF8845D1),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: "next",
                            onPressed: () {
                              controller.swipe(CardSwiperDirection.right);
                            },
                            backgroundColor: const Color(0xFF8845D1),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

