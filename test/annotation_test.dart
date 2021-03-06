import 'package:dart_code/dart_code.dart';
import 'package:test/test.dart';

main() {
  group('Annotation class', () {
    test("Should return: '@Hidden()'", () {
      String actual = CodeFormatter().unFormatted(Annotation(Type('Hidden')));
      String expected = '@Hidden()\n';
      expect(actual, expected);
    });

    test("Should return: '@Hidden(forRole: \'admin\')'", () {
      String actual = CodeFormatter().unFormatted(Annotation(
          Type('Hidden'),
          ParameterValues([
            ParameterValue.named('forRole', Expression.ofString('admin'))
          ])));
      String expected = '@Hidden(forRole: \'admin\')\n';
      expect(actual, expected);
    });

    test("Should return: '@override'", () {
      String actual = CodeFormatter().unFormatted(Annotation.override());
      String expected = '@override\n';
      expect(actual, expected);
    });

    test("Should return: '@required'", () {
      String actual = CodeFormatter().unFormatted(Annotation.required());
      String expected = '@required\n';
      expect(actual, expected);
    });

    test("Should return: '@deprecated'", () {
      String actual = CodeFormatter().unFormatted(Annotation.deprecated());
      String expected = '@deprecated\n';
      expect(actual, expected);
    });
  });
}
