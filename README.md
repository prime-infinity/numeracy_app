# Numeracy App

A Flutter-based mental math app that presents timed math questions with multiple choice answers. Test your arithmetic skills across different difficulty levels, track your progress over time, and follow a structured learning path with Journey mode.

## Features

- **Timed Questions**: Answer math problems within a 30-second time limit
- **Multiple Operations**: Addition, subtraction, multiplication, and division
- **Difficulty Levels**: Three ranges - Easy (1-10), Medium (1-100), Hard (1-1000)
- **Journey Mode**: Structured learning path with progressive difficulty and achievement tracking
- **Progress Tracking**: Comprehensive statistics and performance analytics
- **Streak Tracking**: Monitor current and best answer streaks

## Journey Mode

The Journey mode provides a structured learning experience that guides users through progressively challenging math problems:

### Features

- **Progressive Difficulty**: 12 steps covering each operation (addition, subtraction, multiplication, division) across three difficulty levels
- **Step Unlocking**: Complete previous steps to unlock new challenges
- **Achievement System**: Steps are completed when achieving 90% accuracy with at least 10 attempts
- **Visual Progress**: Track your journey with progress indicators and completion status
- **Dedicated Statistics**: Journey mode maintains separate statistics from regular practice

### Journey Structure

1. **Addition Easy** (1-10)
2. **Addition Medium** (1-100)
3. **Addition Hard** (1-1000)
4. **Subtraction Easy** (1-10)
5. **Subtraction Medium** (1-100)
6. **Subtraction Hard** (1-1000)
7. **Multiplication Easy** (1-10)
8. **Multiplication Medium** (1-100)
9. **Multiplication Hard** (1-1000)
10. **Division Easy** (1-10)
11. **Division Medium** (1-100)
12. **Division Hard** (1-1000)

## Architecture

### Models

The app uses a clean model-based architecture:

#### `Operation` (Enum)

- Defines four math operations: addition, subtraction, multiplication, division
- Provides calculation logic and display symbols
- Includes string conversion utilities

#### `Question`

- Represents a single math question with two operands and an operation
- Generates four multiple choice options (one correct, three incorrect)
- Validates that options include the correct answer

#### `QuestionAttempt`

- Records user performance data for analytics
- Stores date, operation type, difficulty level, result, and journey mode flag
- Serializable for local storage via Hive

#### `QuestionResponse`

- Captures user's answer to a specific question
- Tracks correctness and selected option

#### `Journey` & `JourneyStep`

- **Journey**: Manages the complete learning path with 12 progressive steps
- **JourneyStep**: Represents individual challenges with operation, difficulty, and completion status
- **JourneyDifficulty**: Enum defining easy, medium, and hard difficulty levels
- Tracks unlock status, completion, accuracy, and attempt counts

### Services

#### `QuestionGenerator`

- Generates sets of 10 random questions
- Supports filtering by operations and difficulty ranges
- Special logic for division to ensure clean integer results
- Creates unique incorrect options for each question

#### `StatsService`

- Handles all data persistence using Hive local database
- Tracks question attempts and performance metrics
- Provides analytics methods:
  - Overall accuracy calculations
  - Performance by operation/difficulty
  - Daily/weekly accuracy trends
  - Streak calculations
  - Time-based filtering
  - Journey vs. regular mode separation

#### `JourneyService`

- Manages Journey mode progression and state
- Handles step unlocking logic based on performance
- Tracks completion status (90% accuracy with 10+ attempts)
- Provides journey statistics and progress calculations
- Supports journey reset functionality

### State Management

#### `QuestionProvider` (Riverpod)

- Manages current question set and user responses
- Tracks answered questions during a session
- Provides methods to record answers and check completion status
- Handles question set replacement for new sessions

#### `JourneyProvider` (Riverpod)

- Manages Journey mode state and progress
- Provides real-time journey data updates
- Handles journey refresh and invalidation

## Technical Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Navigation**: GoRouter
- **Architecture Pattern**: Provider + Service Layer

## Data Flow

1. **Question Generation**: `QuestionGenerator` creates random questions based on selected operations and difficulty
2. **State Management**: `QuestionProvider` manages the current session state
3. **Journey Progression**: `JourneyService` tracks step completion and unlocking
4. **User Interaction**: Questions are presented with timed multiple choice interface
5. **Data Persistence**: `StatsService` records attempts to local Hive database with mode separation
6. **Analytics**: Historical data is processed for performance insights and progress tracking

## Project Structure

```
lib/
├── models/              # Data models
│   ├── operation.dart
│   ├── question.dart
│   ├── question_attempt.dart
│   ├── question_response.dart
│   └── journey.dart     # Journey models
├── providers/           # State management
│   └── question_provider.dart
├── services/           # Business logic
│   ├── question_generator.dart
│   ├── stats_service.dart
│   └── journey_service.dart  # Journey management
├── screens/            # UI screens
│   ├── journey/        # Journey mode screens
│   │   └── journey_screen.dart
│   └── ...
└── theme.dart          # App theming
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `dart run build_runner watch` for code generation
4. Launch with `flutter run`

The app initializes Hive storage on startup and is ready to generate questions immediately. Journey mode is available from the main menu and provides a structured learning experience.

## Navigation

- **Regular Mode**: Practice with custom operation and difficulty selections
- **Journey Mode**: Follow the structured 12-step learning path
- **Statistics**: View performance analytics for both modes
- **Settings**: Configure app preferences and reset journey progress

## Media

![Screenshot_20250630-122217](https://github.com/user-attachments/assets/490befa9-2952-4968-bf36-7f6aa9777e76)
![Screenshot_20250630-122205](https://github.com/user-attachments/assets/22f109ca-7bea-4cad-a85b-b2c05f531f8c)
![Screenshot_20250630-122203](https://github.com/user-attachments/assets/5a584e38-bf8c-40cf-a34f-2497b2352908)
![Screenshot_20250630-122157](https://github.com/user-attachments/assets/5be9b63f-61d4-44c1-b12f-132b53f770c6)
![Screenshot_20250630-122147](https://github.com/user-attachments/assets/d84e7b9d-d11f-4549-9de2-cd7229531234)
![Screenshot_20250630-122140](https://github.com/user-attachments/assets/270183bf-b396-42dc-ae99-bd165c68f49b)
![Screenshot_20250630-122115](https://github.com/user-attachments/assets/34e39e92-9a36-4cf6-91a5-2783c9200ca6)
![Screenshot_20250630-122259](https://github.com/user-attachments/assets/53629c18-2cbf-45f2-91f3-c5cdee3c1b40)
![Screenshot_20250630-122257](https://github.com/user-attachments/assets/969ca17a-430b-4b0f-a6d1-c8560a31dc28)
![Screenshot_20250630-122253](https://github.com/user-attachments/assets/1b69096e-1928-4d7e-bc8a-de40b86ed743)
![Screenshot_20250630-122249](https://github.com/user-attachments/assets/b3c46b32-6572-4c6d-9719-982144384c45)
![Screenshot_20250630-122241](https://github.com/user-attachments/assets/668f435b-7df3-42f3-abfc-414d0b9c32d4)
![Screenshot_20250630-122227](https://github.com/user-attachments/assets/530f5131-9895-4db8-8b4f-c6632a047813)
