import 'package:flutter_test/flutter_test.dart';
import 'lib/data/formulas.dart';

void main() {
  test('test formulas', () {
    try {
      List<double> vars = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
      var res = allFormulas.first.evaluate(vars);
      print("Success: $res");
    } catch (e, stack) {
      print("Error: $e");
      print(stack);
    }
  });
}
