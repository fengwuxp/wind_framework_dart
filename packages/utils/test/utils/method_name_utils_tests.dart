import 'package:test/test.dart';
import 'package:wind_utils/src/utils/method_name_utils.dart';

void main() {
  group('initialLowercase', () {
    test('Should convert the first letter to lowercase', () {
      expect(initialLowercase('HelloWorld'), equals('helloWorld'));
    });

    test('Should return empty string if input is empty', () {
      expect(initialLowercase(''), equals(''));
    });

    test('Should not change string if first letter is already lowercase', () {
      expect(initialLowercase('helloWorld'), equals('helloWorld'));
    });

    test('Should handle single character strings', () {
      expect(initialLowercase('A'), equals('a'));
    });
  });

  group('toHumpResolver', () {
    test('Should convert underscores to camel case', () {
      expect(toHumpResolver('hello_world'), equals('helloWorld'));
    });

    test('Should handle multiple underscores correctly', () {
      expect(toHumpResolver('my_function_name'), equals('myFunctionName'));
    });

    test('Should return the same string if no underscores', () {
      expect(toHumpResolver('helloWorld'), equals('helloWorld'));
    });

    test('Should return an empty string for empty input', () {
      expect(toHumpResolver(''), equals(''));
    });
  });

  group('toLineResolver', () {
    test('Should convert camel case to snake case', () {
      expect(toLineResolver('helloWorld'), equals('hello_world'));
    });

    test('Should handle multiple uppercase letters correctly', () {
      expect(toLineResolver('myFunctionName'), equals('my_function_name'));
    });

    test('Should return the same string if no uppercase letters', () {
      expect(toLineResolver('helloworld'), equals('helloworld'));
    });

    test('Should return an empty string for empty input', () {
      expect(toLineResolver(''), equals(''));
    });
  });
}
