import 'package:numeracy_app/models/option.dart';

class Question {
  Question({
    required String question,
    required int questionNumber,
    required List<Option> options,
    required String correctAnswer,
  })  : _question = question,
        _questionNumber = questionNumber,
        _options = options,
        _correctAnswer = correctAnswer;

  final String _question;
  final int _questionNumber;
  late final List<Option> _options;
  final String _correctAnswer;

  //getters
  String get question => _question;
  int get questionNumber => _questionNumber;
  List<Option> get options =>
      List.unmodifiable(_options); // Return immutable copy
  String get correctAnswer => _correctAnswer;
}

final List<Question> questions = [
  Question(question: "5 + 3", correctAnswer: "b", questionNumber: 1, options: [
    Option(id: "a", text: "7"),
    Option(id: "b", text: "8"),
    Option(id: "c", text: "9"),
    Option(id: "d", text: "10")
  ]),
  Question(
    question: "15 - 7",
    questionNumber: 2,
    correctAnswer: "c",
    options: [
      Option(id: "a", text: "6"),
      Option(id: "b", text: "7"),
      Option(id: "c", text: "8"),
      Option(id: "d", text: "9")
    ],
  ),
  Question(
    question: "4 × 6",
    questionNumber: 3,
    correctAnswer: "d",
    options: [
      Option(id: "a", text: "18"),
      Option(id: "b", text: "20"),
      Option(id: "c", text: "22"),
      Option(id: "d", text: "24")
    ],
  ),
  Question(
    question: "20 ÷ 5",
    questionNumber: 4,
    correctAnswer: "b",
    options: [
      Option(id: "a", text: "3"),
      Option(id: "b", text: "4"),
      Option(id: "c", text: "5"),
      Option(id: "d", text: "6")
    ],
  ),
  Question(
    question: "9 + 7",
    questionNumber: 5,
    correctAnswer: "c",
    options: [
      Option(id: "a", text: "14"),
      Option(id: "b", text: "15"),
      Option(id: "c", text: "16"),
      Option(id: "d", text: "17")
    ],
  ),
  Question(
    question: "25 - 8",
    questionNumber: 6,
    correctAnswer: "a",
    options: [
      Option(id: "a", text: "17"),
      Option(id: "b", text: "16"),
      Option(id: "c", text: "15"),
      Option(id: "d", text: "18")
    ],
  ),
  Question(
    question: "3 × 8",
    questionNumber: 7,
    correctAnswer: "d",
    options: [
      Option(id: "a", text: "21"),
      Option(id: "b", text: "22"),
      Option(id: "c", text: "23"),
      Option(id: "d", text: "24")
    ],
  ),
  Question(
    question: "36 ÷ 6",
    questionNumber: 8,
    correctAnswer: "b",
    options: [
      Option(id: "a", text: "5"),
      Option(id: "b", text: "6"),
      Option(id: "c", text: "7"),
      Option(id: "d", text: "8")
    ],
  ),
  Question(
    question: "12 + 13",
    questionNumber: 9,
    correctAnswer: "c",
    options: [
      Option(id: "a", text: "23"),
      Option(id: "b", text: "24"),
      Option(id: "c", text: "25"),
      Option(id: "d", text: "26")
    ],
  ),
  Question(
    question: "30 - 14",
    questionNumber: 10,
    correctAnswer: "d",
    options: [
      Option(id: "a", text: "14"),
      Option(id: "b", text: "15"),
      Option(id: "c", text: "15"),
      Option(id: "d", text: "16")
    ],
  ),
];

/**
 * QuestionCard(
      questionNumber: '14',
      question: '5+4',
      options: const ['15', '9', '81', '91'],
    )
 */
/*
from typescript
export interface Question{
    id:string;
    question:string;
    difficulty: 1 | 2 | 3 | 4 | 5;
    category: string;
    subcategory: string;
    options: {
        id: string;
        text: string;
    }[];
    correctAnswer: string;
    tags: string[];
    relatedQuestions: string[];
    metadata:{
        author: string;
        usageStats: {
            timesAnswered: number;
            timesCorrect: number;
            averageTimeToAnswer: number; // in seconds
        };
    }
}*/