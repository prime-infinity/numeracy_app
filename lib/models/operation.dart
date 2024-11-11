enum Operation {
  addition,
  subtraction,
  multiplication,
  division;

  int calculate(int a, int b) {
    switch (this) {
      case Operation.addition:
        return a + b;
      case Operation.subtraction:
        return a - b;
      case Operation.multiplication:
        return a * b;
      case Operation.division:
        // Note: Consider how to handle division carefully due to decimal results
        return a ~/ b; //
    }
  }

  String get symbol {
    switch (this) {
      case Operation.addition:
        return '+';
      case Operation.subtraction:
        return '-';
      case Operation.multiplication:
        return '×';
      case Operation.division:
        return '÷';
    }
  }
}
