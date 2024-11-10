class Option {
  Option({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  // Factory constructor to create Option from Map
  factory Option.fromMap(Map<String, String> map) {
    return Option(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
    );
  }
}
